const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile("input/real.txt", .{});
    defer file.close();

    const contents = try file.readToEndAlloc(allocator, std.math.maxInt(usize)); // should be large enough
    defer allocator.free(contents);

    var lines = std.mem.splitAny(u8, contents, "\n");

    var first_array = std.ArrayList(i32).init(allocator);
    var second_array = std.ArrayList(i32).init(allocator);
    var comparison_array = std.ArrayList(i32).init(allocator);
    defer first_array.deinit();
    defer second_array.deinit();
    defer comparison_array.deinit();

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        var nums = std.mem.tokenizeAny(u8, line, " \t");

        const first_num = try std.fmt.parseInt(i32, nums.next().?, 10);
        const second_num = try std.fmt.parseInt(i32, nums.next().?, 10);

        try first_array.append(first_num);
        try second_array.append(second_num);
    }

    std.mem.sort(i32, first_array.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, second_array.items, {}, std.sort.asc(i32));

    for (first_array.items, second_array.items) |a, b| {
        const larger = if (a > b) a else b;
        const smaller = if (a > b) b else a;
        try comparison_array.append(larger - smaller);
    }

    var res_one: i32 = 0;
    for (comparison_array.items) |diff| res_one += diff;

    std.debug.print("res: {}\n", .{res_one});

    // Second part

    var first_sim = std.ArrayList(i32).init(allocator);
    defer first_sim.deinit();

    for (first_array.items) |first_num| {
        const needle = [_]i32{first_num};
        const occurrences = std.mem.count(i32, second_array.items, &needle);
        const sim_score = @as(i32, @intCast(occurrences)) * first_num;
        try first_sim.append(sim_score);
    }

    var res_two: i32 = 0;
    for (first_sim.items) |item| res_two += item;

    std.debug.print("second res: {}\n", .{res_two});
}
