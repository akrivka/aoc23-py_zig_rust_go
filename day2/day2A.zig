const std = @import("std");
const stdout = std.io.getStdOut().writer();

const red_limit: u32 = 12;
const green_limit: u32 = 13;
const blue_limit: u32 = 14;

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_reader = buf_reader.reader();
    var buffer: [1024]u8 = undefined;
    var result: u32 = 0;
    var id: u32 = 0;
    game_loop: while (try in_reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        // Bump id
        id += 1;

        // Iterate over all games
        var draws = line[(std.mem.indexOf(u8, line, ": ") orelse unreachable) + 2 .. line.len];
        var draw_it = std.mem.splitSequence(u8, draws, "; ");
        while (draw_it.next()) |draw| {
            // Iterate over all draws
            var cubes_it = std.mem.splitSequence(u8, draw, ", ");
            while (cubes_it.next()) |cube| {
                // Get number of cubes drawn and color
                var cube_it = std.mem.splitSequence(u8, cube, " ");
                var count = try std.fmt.parseInt(u32, (cube_it.next() orelse "0"), 10);
                var color = cube_it.next() orelse "green";

                // Check if within limits
                if (std.mem.eql(u8, color, "red")) {
                    if (count > red_limit) continue :game_loop;
                } else if (std.mem.eql(u8, color, "green")) {
                    if (count > green_limit) continue :game_loop;
                } else if (std.mem.eql(u8, color, "blue")) {
                    if (count > blue_limit) continue :game_loop;
                }
            }
        }

        // If we didn't break, all games were ok
        result += id;
    }

    // Print result
    try stdout.print("{d}\n", .{result});
}
