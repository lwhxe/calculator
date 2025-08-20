const std = @import("std");

fn operator_bind_power(operand: method) !u8 {
    switch (operand.operator) {
        '*' => { return 3; },
        '/' => { return 3; },
        '-' => { return 1; },
        '+' => { return 1; },
        else => { std.debug.print("Syntax Error.\n\n", .{}); return error.syntax; }
    }

    return 0;
}

fn calculate(operand: method, lhs: f64, rhs: f64) !f64 {
    return switch (operand.operator) {
        '*' => { return lhs * rhs; },
        '/' => { return lhs / rhs; },
        '-' => { return lhs - rhs; },
        '+' => { return lhs + rhs; },
        else => { std.debug.print("Syntax Error.\n\n", .{}); return error.syntax; }
    };
}

fn parse_expression(tokens: []const method, bp: u8, index: usize) !f64 {
    if (tokens.len == index) return tokens[index].value;

    const lhs = tokens[index].value;

    const cbp = try operator_bind_power(tokens[index + 1]);
    if (bp + 1 > cbp) {
        return calculate(tokens[index + 1], lhs, tokens[index + 2].value);
    } else {
        return calculate(tokens[index + 1], lhs, try parse_expression(tokens, cbp, index + 2));
    }
}

const method_tag = enum {
    operator,
    value,
};

const method = union(method_tag) {
    operator: u8,
    value: f64,
};

fn evaluate(expression: []const u8) !f64 {
    if (expression.len == 0) {
        return 0;
    }
    var buf_e: [100]u8 = undefined;
    var buf_m: [100]method = undefined;
    const len = std.mem.replace(u8, expression, " ", "", &buf_e);
    const expr = buf_e[0..len];

    for (expr, 0..) |part, i| {
        if (part >= '0' and part <= '9') {
            buf_m[i] = method{ .value = @as(f64, @floatFromInt(part - '0')) };
        } else {
            switch (part) {
                '*' => { buf_m[i] = method{ .operator = part }; },
                '/' => { buf_m[i] = method{ .operator = part }; },
                '-' => { buf_m[i] = method{ .operator = part }; },
                '+' => { buf_m[i] = method{ .operator = part }; },
                else => { std.debug.print("Syntax Error.\n\n", .{}); }
            }
        }
    }

    const expr_method = buf_m[0..expr.len];
    return try parse_expression(expr_method, 0, 0);
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
