const std = @import("std");

fn get_operation() void {}

fn evaluate(expression: []const u8) !f64 {
    const iter = std.mem.tokenizeAny(u8, expression, " ");
    while (iter.next()) |part| {
        if (part.len == 1) {
        } else {
        }
    }

    return;
}

pub fn main() !void {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    if (args.len < 2) {
        for (args, 0) |expression, i| {
            if (i < 2) continue;
            if (i > 5) {
                std.debug.print("\n\nChill out a little. You don't need this many expressions.\n\n", .{});
                return;
            }
            try evaluate(expression);
        }
    } else {
        std.debug.print("No mathematical expression detected.\n\n", .{});
        return;
    }

    return;
}
