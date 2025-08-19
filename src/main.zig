const std = @import("std");

fn get_operation(operation: []const u8) u8 {
    if (operation[0] == '+') return 1;
    if (operation[1] == '-') return 2;
    if (operation[2] == '*') return 3;
    if (operation[3] == '/') return 4 else return 0;
}

fn operate(current_value: f64, next_value: f64, operation: u8) !f64 {
    var result: f64 = undefined;
    switch (operation) {
        1 => {result = current_value + next_value;},
        2 => {result = current_value - next_value;},
        3 => {result = current_value * next_value;},
        4 => {result = current_value / next_value;},
        else => { std.debug.print("Something went horribly wrong... Please try again.", .{}); return error.operateErr; },
    }
    return result;
}

fn evaluate(expression: []const u8) !f64 {
    var last_operation: u8 = 3;
    var current_value: f64 = 1;

    var iter = std.mem.tokenizeAny(u8, expression, " ");
    while (iter.next()) |part| {
        if (part.len == 1) {
            last_operation = get_operation(part);
        } else {
            current_value = try operate(current_value, try std.fmt.parseFloat(f64, part), last_operation);
        }
    }

    return current_value;
}

pub fn main() !void {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    if (args.len > 1) {
        for (args, 0..) |expression, i| {
            if (i == 1) continue;
            if (i > 5) {
                std.debug.print("\n\nChill out a little. You don't need this many expressions.\n\n", .{});
                return;
            }
            const result = try evaluate(expression);
            std.debug.print("{d}, ", .{result});
        }
    } else {
        std.debug.print("No mathematical expression detected.\n\n", .{});
        return;
    }

    return;
}
