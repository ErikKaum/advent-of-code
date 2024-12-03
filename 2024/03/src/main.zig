const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile("input/real.txt", .{});
    defer file.close();

    const contents = try file.readToEndAlloc(allocator, std.math.maxInt(usize)); // should be large enough
    defer allocator.free(contents);

    var index: usize = 0;
    var res_one: u32 = 0;

    while (index < contents.len) {
        if (index + 4 < contents.len and std.mem.eql(u8, contents[index .. index + 4], "mul(")) {
            index += 4;

            const num1_start = index;
            while (index < contents.len and contents[index] != ',') : (index += 1) {
                if (contents[index] < '0' or contents[index] > '9') break;
            }
            if (contents[index] != ',') continue;

            index += 1; // skip comma
            const num2_start = index;
            while (index < contents.len and contents[index] != ')') : (index += 1) {
                if (contents[index] < '0' or contents[index] > '9') break;
            }
            if (contents[index] != ')') continue;

            const x = std.fmt.parseInt(u32, contents[num1_start .. num2_start - 1], 10) catch continue;
            const y = std.fmt.parseInt(u32, contents[num2_start..index], 10) catch continue;

            res_one += x * y;
        }
        index += 1;
    }
    std.debug.print("result from day one: {}\n", .{res_one});

    ////////////////////
    // Second part
    ///////////////////

    index = 0;
    var res_two: u32 = 0;
    var enabled: bool = true;

    while (index < contents.len) {
        // ugly but works
        if (index + 4 < contents.len and std.mem.eql(u8, contents[index .. index + 4], "do()")) {
            enabled = true;
            index += 4;
            continue;
        }
        if (index + 7 < contents.len and std.mem.eql(u8, contents[index .. index + 7], "don't()")) {
            enabled = false;
            index += 7;
            continue;
        }

        if (enabled and index + 4 < contents.len and std.mem.eql(u8, contents[index .. index + 4], "mul(")) {
            index += 4;

            const num1_start = index;
            while (index < contents.len and contents[index] != ',') : (index += 1) {
                if (contents[index] < '0' or contents[index] > '9') break;
            }
            if (contents[index] != ',') continue;

            index += 1; // skip comma
            const num2_start = index;
            while (index < contents.len and contents[index] != ')') : (index += 1) {
                if (contents[index] < '0' or contents[index] > '9') break;
            }
            if (contents[index] != ')') continue;

            const x = std.fmt.parseInt(u32, contents[num1_start .. num2_start - 1], 10) catch continue;
            const y = std.fmt.parseInt(u32, contents[num2_start..index], 10) catch continue;

            res_two += x * y;
        }
        index += 1;
    }

    std.debug.print("result from day two: {}\n", .{res_two});
}
