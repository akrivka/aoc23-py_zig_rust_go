const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    // Open file
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    // Initialize reader
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_reader = buf_reader.reader();
    var buffer: [1024]u8 = undefined;

    // Initialize program variables
    var result: u32 = 0;
    var id: u32 = 0;

    while (try in_reader.readUntilDelimiterOrEof(&buffer, '\n')) |game| {
        // Bump id
        id += 1;

        // Initialize game minimums
        var red_min: u32 = 0;
        var green_min: u32 = 0;
        var blue_min: u32 = 0;

        // Iterate over all draws
        var draws = game[(std.mem.indexOf(u8, game, ": ") orelse unreachable) + 2 .. game.len];
        var draw_it = std.mem.splitSequence(u8, draws, "; ");
        while (draw_it.next()) |draw| {
            // Iterate over all cube types
            var cubes_it = std.mem.splitSequence(u8, draw, ", ");
            while (cubes_it.next()) |cube| {
                // Get number of cubes drawn and color
                var cube_it = std.mem.splitSequence(u8, cube, " ");
                var count = try std.fmt.parseInt(u32, (cube_it.next() orelse "0"), 10);
                var color = cube_it.next() orelse "green";

                // Check if within limits
                if (std.mem.eql(u8, color, "red")) {
                    if (count > red_min) red_min = count;
                } else if (std.mem.eql(u8, color, "green")) {
                    if (count > green_min) green_min = count;
                } else if (std.mem.eql(u8, color, "blue")) {
                    if (count > blue_min) blue_min = count;
                }
            }
        }

        result += red_min * green_min * blue_min;
    }

    // Print result
    try stdout.print("{d}\n", .{result});
}
