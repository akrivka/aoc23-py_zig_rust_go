// Let t be the time of the race and d the record distance.
// Let x be the time we hold the boat.
// We want (t - x) * x > d

const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const time: i64 = 44806572;
    const distance: i64 = 208158110501102;

    var x: i64 = 0;
    var ways: i64 = 0;
    while (x < time) {
        var reached = (time - x) * x;
        if (reached > distance) {
            ways += 1;
        }
        x += 1;
    }

    try stdout.print("{d}\n", .{ways});
}
