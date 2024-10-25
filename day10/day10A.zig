// Let t be the time of the race and d the record distance.
// Let x be the time we hold the boat.
// We want (t - x) * x > d

const std = @import("std");
const stdout = std.io.getStdOut().writer();
const allocator = std.heap.page_allocator;
var map = std.ArrayList(std.ArrayList(u8)).init(allocator);

fn p(i: i64, j: i64) u8 {
    return map.items[@intCast(i)].items[@intCast(j)];
}

pub fn main() !void {
    // Open file
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    // Read map
    defer map.deinit();

    const first_row = std.ArrayList(u8).init(allocator);
    try map.append(first_row);
    defer first_row.deinit();

    var start_i: i64 = 0;
    var start_j: i64 = 0;
    var i: i64 = 0;
    var j: i64 = 0;
    while (true) {
        const byte = file.reader().readByte();

        if (byte == error.EndOfStream)
            break;

        const b = try byte;
        switch (b) {
            '\n' => {
                i += 1;
                j = 0;
                const next_row = std.ArrayList(u8).init(allocator);
                defer next_row.deinit();
                try map.append(next_row);
            },
            else => {
                if (b == 'S') {
                    start_i = i;
                    start_j = j;
                }
                j += 1;
                try map.items[map.items.len - 1].append(b);
            },
        }
    }

    // Testing
    //for (map.items) |row| {
    //    for (row.items) |byte| {
    //        try stdout.print("{c}", .{byte});
    //    }
    //    try stdout.print("\n", .{});
    //}
    //
    //try stdout.print("{d} {d} {c}\n", .{ start_i, start_j, map.items[start_i].items[start_j] });

    const num_rows = map.items.len;
    const num_cols = map.items[0].items.len;

    i = start_i;
    j = start_j;

    var prev_i: i64 = start_i;
    var prev_j: i64 = start_j;
    // Make the first step
    // Only need to check bottom three since at least one of the must be valid
    // Left
    if (j > 0 and (p(i, j - 1) == '-' or p(i, j - 1) == 'F' or p(i, j - 1) == 'L')) {
        j = j - 1;
    }
    // Below
    else if (i < num_rows and (p(i + 1, j) == '|' or p(i + 1, j) == 'L' or p(i + 1, j) == 'J')) {
        i = i + 1;
    }
    // Right
    else if (j < num_cols and (p(i, j + 1) == '-' or p(i, j + 1) == 'J' or p(i, j + 1) == '7')) {
        j = j + 1;
    }

    var len: i64 = 1;
    while (true) {
        std.debug.print("{d} {d}\n", .{ i, j });
        // Move
        if (i == start_i and j == start_j) {
            break;
        }
        // else
        var new_i: i64 = i;
        var new_j: i64 = j;
        len += 1;
        switch (p(i, j)) {
            '|' => {
                new_i += i - prev_i;
            },
            '-' => {
                new_j += j - prev_j;
            },
            'L' => {
                if (i != prev_i) {
                    new_j += 1;
                } else {
                    new_i -= 1;
                }
            },
            'F' => {
                if (i != prev_i) {
                    new_j += 1;
                } else {
                    new_i += 1;
                }
            },
            'J' => {
                if (i != prev_i) {
                    new_j -= 1;
                } else {
                    new_i -= 1;
                }
            },
            '7' => {
                if (i != prev_i) {
                    new_j -= 1;
                } else {
                    new_i += 1;
                }
            },
            else => unreachable,
        }
        prev_i = i;
        prev_j = j;
        i = new_i;
        j = new_j;
    }

    try stdout.print("{d}\n", .{@divFloor(len, 2)});
}
