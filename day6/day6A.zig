// Let t be the time of the race and d the record distance.
// Let x be the time we hold the boat.
// We want (t - x) * x > d

const std = @import("std");
const stdout = std.io.getStdOut().writer();

const Race = struct { time: i32, record_distance: i32 };

pub fn main() !void {
    // Open file
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    // Read file
    var times: [1024]u8 = std.mem.zeroes([1024]u8);
    var distances: [1024]u8 = std.mem.zeroes([1024]u8);
    _ = try file.reader().readUntilDelimiterOrEof(&times, '\n');
    _ = try file.reader().readUntilDelimiterOrEof(&distances, '\n');

    // Tokenize
    var times_it = std.mem.tokenizeAny(u8, &times, " \n\x00");
    var distances_it = std.mem.tokenizeAny(u8, &distances, " \n\x00");

    // Skip "Time:" and "Distance:"
    _ = times_it.next();
    _ = distances_it.next();

    // Initialize variables
    var result: i32 = 1;

    // Process races
    while (times_it.next()) |time_s| {
        var distance_s = distances_it.next() orelse unreachable;

        var time = try std.fmt.parseInt(i32, time_s, 10);
        var distance = try std.fmt.parseInt(i32, distance_s, 10);

        var x: i32 = 0;
        var ways: i32 = 0;
        while (x < time) {
            var reached = (time - x) * x;
            if (reached > distance) {
                ways += 1;
            }
            x += 1;
        }
        result *= ways;
    }

    try stdout.print("{d}\n", .{result});
}
