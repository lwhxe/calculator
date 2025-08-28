const std = @import("std");

fn evaluate(expr: []const u8) !f64 {
    if (expr.len == 0) {
        return 0;
    }



    return 0;
}

pub fn main() !void {
    const args = try std.process.argsAlloc(std.heap.page_allocator);

    if (args.len > 1) {
        for (args, 0..) |expression, i| {
            if (i == 0) continue;
            if (i > 5) {
                std.debug.print("\n\nChill out a little. You don't need this many expressions.\n\n", .{});
                return;
            }
            const result = try evaluate(expression);
            std.debug.print("{s}={d}\n\n", .{expression, result});
        }
    } else {
        std.debug.print("No mathematical expression detected.\n\n", .{});

        _ = try evaluate("1+1");
        _ = try evaluate("4-3");
        _ = try evaluate("3*3+4*2");
        _ = try evaluate("3/3+3+1");
        return;
    }

    return;
}
