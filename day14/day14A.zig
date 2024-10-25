const std = @import("std");
const stdout = std.io.getStdOut().writer();
const allocator = std.heap.page_allocator;

const InputError = error{NoRowsDetected};

const TiltDirection = enum { North, South, East, West };

const Platform = struct {
    tiles: [][]u8,
    num_rows: usize,
    num_cols: usize,
    row_buffer: []u8,
    col_buffer: []u8,
    allocator: std.mem.Allocator,

    pub fn init(input: []u8, _allocator: std.mem.Allocator) !Platform {
        // Get number of rows and columns
        var row_it = std.mem.splitScalar(u8, input, '\n');
        const num_cols = (row_it.next() orelse return InputError.NoRowsDetected).len;
        var i: usize = 1;
        while (row_it.next()) |row| {
            if (row.len == 0) break;
            i += 1;
        }
        const num_rows = i;
        std.debug.print("Num rows: {d}, num cols: {d}\n", .{ num_rows, num_cols });

        var tiles: [][]u8 = try _allocator.alloc([]u8, num_rows);
        row_it.reset();
        i = 0;
        while (row_it.next()) |row| {
            if (row.len == 0) break;
            var new_row = try _allocator.alloc(u8, row.len);
            std.mem.copy(u8, new_row, row);
            tiles[i] = new_row;
            i += 1;
        }

        const row_buffer = try _allocator.alloc(u8, num_cols);
        const col_buffer = try _allocator.alloc(u8, num_rows);

        return Platform{ .tiles = tiles, .num_rows = tiles.len, .num_cols = tiles[0].len, .row_buffer = row_buffer, .col_buffer = col_buffer, .allocator = _allocator };
    }

    pub fn deinit(self: Platform) void {
        for (self.tiles) |row| {
            self.allocator.free(row);
        }
        self.allocator.free(self.tiles);
    }

    pub fn debug_print(self: Platform) void {
        for (self.tiles) |row| {
            std.debug.print("{s}\n", .{row});
        }
        std.debug.print("\n", .{});
    }

    fn map_cols(self: Platform, func: *const fn (arr: []u8) []u8) void {
        for (0..self.num_cols) |c| {
            for (0..self.num_rows) |r| {
                self.col_buffer[r] = self.tiles[r][c];
            }
            const new_col = func(self.col_buffer);
            for (0..self.num_rows) |r| {
                self.tiles[r][c] = new_col[r];
            }
        }
    }

    fn map_rows(self: Platform, func: *const fn (arr: []u8) []u8) void {
        for (0..self.num_rows) |r| {
            for (0..self.num_cols) |c| {
                self.row_buffer[c] = self.tiles[r][c];
            }
            const new_row = func(self.row_buffer);
            for (0..self.num_cols) |c| {
                self.tiles[r][c] = new_row[c];
            }
        }
    }

    fn shift_left(arr: []u8) []u8 {
        for (arr, 0..) |x, i| {
            if (x == 'O') {
                var new_i = i;
                while (new_i > 0 and arr[new_i - 1] == '.') : (new_i -= 1) {}

                if (i != new_i) {
                    arr[i] = '.';
                    arr[new_i] = 'O';
                }
            }
        }
        return arr;
    }

    fn shift_right(arr: []u8) []u8 {
        var i = arr.len;
        while (i > 0) {
            i -= 1;
            if (arr[i] == 'O') {
                var new_i = i;
                while (new_i < arr.len - 1 and arr[new_i + 1] == '.') : (new_i += 1) {}

                if (i != new_i) {
                    arr[i] = '.';
                    arr[new_i] = 'O';
                }
            }
        }
        return arr;
    }

    pub fn tilt(self: Platform, dir: TiltDirection) void {
        switch (dir) {
            TiltDirection.North => {
                self.map_cols(shift_left);
            },
            TiltDirection.South => {
                self.map_cols(shift_right);
            },
            TiltDirection.West => {
                self.map_rows(shift_left);
            },
            TiltDirection.East => {
                self.map_rows(shift_right);
            },
        }
        if (dir == TiltDirection.North) {
            self.map_cols(shift_left);
        }
    }

    pub fn get_north_load(self: Platform) i64 {
        var load: i64 = 0;
        for (self.tiles, 0..) |row, i| {
            const row_load: i64 = @intCast(self.num_rows - i);
            for (row) |tile| {
                if (tile == 'O') {
                    load += row_load;
                }
            }
        }
        return load;
    }
};

pub fn main() !void {
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    var platform: Platform = undefined;
    defer platform.deinit();
    {
        const input = try file.reader().readAllAlloc(allocator, 1000000);
        defer allocator.free(input);

        platform = try Platform.init(input, allocator);
    }

    const num_cycles: usize = 1030;
    for (0..num_cycles) |i| {
        platform.tilt(TiltDirection.North);
        platform.tilt(TiltDirection.West);
        platform.tilt(TiltDirection.South);
        platform.tilt(TiltDirection.East);

        std.debug.print("cycle {d}, load {d}\n", .{ i + 1, platform.get_north_load() });
    }

    //platform.debug_print();

    const load = platform.get_north_load();

    try stdout.print("{d}\n", .{load});
}
