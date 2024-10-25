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
    var start_char: u8 = 0;
    // Make the first step
    // |
    if (i > 0 and i < num_rows and (p(i - 1, j) == '|' or p(i - 1, j) == 'F' or p(i - 1, j) == '7') and (p(i + 1, j) == '|' or p(i + 1, j) == 'L' or p(i + 1, j) == 'J')) {
        i = i + 1;
        start_char = '|';
        // -
    } else if (j > 0 and j < num_cols and (p(i, j - 1) == '-' or p(i, j - 1) == 'L' or p(i, j - 1) == 'F') and (p(i, j + 1) == '-' or p(i, j + 1) == 'J' or p(i, j + 1) == '7')) {
        j = j + 1;
        start_char = '-';
    }
    // L
    else if (i > 0 and j < num_cols and (p(i - 1, j) == '|' or p(i - 1, j) == 'F' or p(i - 1, j) == '7') and (p(i, j + 1) == '-' or p(i, j + 1) == 'J' or p(i, j + 1) == '7')) {
        j = j + 1;
        start_char = 'L';
    }
    // F
    else if (i < num_rows and j < num_cols and (p(i + 1, j) == '|' or p(i + 1, j) == 'J' or p(i + 1, j) == 'L') and (p(i, j + 1) == '-' or p(i, j + 1) == 'J' or p(i, j + 1) == '7')) {
        i = i + 1;
        start_char = 'F';
    }
    // J
    else if (i > 0 and j > 0 and (p(i - 1, j) == '|' or p(i - 1, j) == 'F' or p(i - 1, j) == '7') and (p(i, j - 1) == '-' or p(i, j - 1) == 'L' or p(i, j - 1) == 'F')) {
        j = j - 1;
        start_char = 'J';
    }
    // 7
    else if (i < num_rows and j > 0 and (p(i + 1, j) == '|' or p(i + 1, j) == 'J' or p(i + 1, j) == 'L') and (p(i, j - 1) == '-' or p(i, j - 1) == 'L' or p(i, j - 1) == 'F')) {
        i = i + 1;
        start_char = '7';
    }
    map.items[@as(usize, @intCast(start_i))].items[@as(usize, @intCast(start_j))] = start_char;

    var loop = std.ArrayList([2]i64).init(allocator);
    try loop.append(.{ start_i, start_j });
    var len: i64 = 1;
    while (true) {
        // Move
        if (i == start_i and j == start_j) {
            break;
        }
        try loop.append(.{ i, j });
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

    var num_inside: i64 = 0;
    var entered_with: u8 = 0;
    var inside = false;
    for (0..num_rows) |ii| {
        inside = false;
        for (0..num_cols) |jj| {
            // Check if on loop
            var on_loop = false;
            for (loop.items) |loc| {
                if (loc[0] == ii and loc[1] == jj) {
                    on_loop = true;
                    break;
                }
            }

            if (!on_loop and inside) {
                std.debug.print("{d} {d}\n", .{ ii, jj });
                num_inside += 1;
            } else if (on_loop) {
                switch (p(@as(i64, @intCast(ii)), @as(i64, @intCast(jj)))) {
                    '|' => {
                        inside = !inside;
                        entered_with = 0;
                    },
                    'F' => {
                        entered_with = 'F';
                    },
                    'L' => {
                        entered_with = 'L';
                    },
                    'J' => {
                        if (entered_with == 'F') {
                            inside = !inside;
                            entered_with = 0;
                        }
                    },
                    '7' => {
                        if (entered_with == 'L') {
                            inside = !inside;
                            entered_with = 0;
                        }
                    },
                    else => {},
                }
            }
        }
    }

    try stdout.print("{d}\n", .{num_inside});
}
