const std = @import("std");

fn isSequenceSafe(numbers: []const u32) bool {
    if (numbers.len < 2) return false;

    var is_decreasing: ?bool = null;

    for (numbers[1..], 0..) |num, i| {
        const prev = numbers[i];
        const diff = @abs(@as(i32, @intCast(num)) - @as(i32, @intCast(prev)));

        if (diff < 1 or diff > 3) return false;

        if (is_decreasing == null) {
            is_decreasing = num < prev;
        } else if (is_decreasing.? != (num < prev)) {
            return false;
        }
    }
    return true;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile("input/real.txt", .{});
    defer file.close();

    const contents = try file.readToEndAlloc(allocator, std.math.maxInt(usize)); // should be large enough
    defer allocator.free(contents);

    var lines = std.mem.splitAny(u8, contents, "\n");
    var res_one: i32 = 0;

    while (lines.next()) |line| {
        var numbers = std.ArrayList(u32).init(allocator);
        defer numbers.deinit();

        var nums_iter = std.mem.splitAny(u8, line, " ");
        while (nums_iter.next()) |num| {
            const number = try std.fmt.parseInt(u32, num, 10);
            try numbers.append(number);
        }

        if (isSequenceSafe(numbers.items)) {
            res_one += 1;
        }
    }
    std.debug.print("res one: {} \n", .{res_one});

    ///////////////////////////////
    // Second Part
    ////////////////////////////////

    lines = std.mem.splitAny(u8, contents, "\n");
    var res_two: i32 = 0;

    while (lines.next()) |line| {
        var numbers = std.ArrayList(u32).init(allocator);
        defer numbers.deinit();

        var nums_iter = std.mem.splitAny(u8, line, " ");
        while (nums_iter.next()) |num| {
            const number = try std.fmt.parseInt(u32, num, 10);
            try numbers.append(number);
        }

        var can_be_safe = false;
        for (numbers.items, 0..) |_, i| {
            var test_sequence = std.ArrayList(u32).init(allocator);
            defer test_sequence.deinit();

            for (numbers.items, 0..) |n, j| {
                if (j != i) try test_sequence.append(n);
            }

            if (isSequenceSafe(test_sequence.items)) {
                can_be_safe = true;
                break;
            }
        }

        if (can_be_safe) {
            res_two += 1;
        }
    }
    std.debug.print("res two: {} \n", .{res_two});
}
