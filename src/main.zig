const std = @import("std");

fn operator_bind_power(operand: method) u8 {
    switch (operand.operator) {
        '*' => { return 3; },
        '/' => { return 3; },
        '-' => { return 1; },
        '+' => { return 1; },
        else => { return 0; }
    }

    return 0;
}

fn calculate(operand: u8, lhs: f64, rhs: f64) !f64 {
    return switch (operand) {
        '*' => { return lhs * rhs; },
        '/' => { return lhs / rhs; },
        '-' => { return lhs - rhs; },
        '+' => { return lhs + rhs; },
        else => { std.debug.print("Syntax Error.\n\n", .{}); return error.syntax; }
    };
}

// TODO: Just fix this.
fn parse_expression(tokens: []const method, left_bp: u8, index: usize) !f64 {
    if (tokens.len <= index + 2) return tokens[index].value;

    const right_bp = operator_bind_power(tokens[index+1]);
    const left_value = tokens[index].value;
    var value: f64 = undefined;

    if (left_bp < right_bp) {
        value = try calculate(tokens[index + 1].operator, left_value, try parse_expression(tokens, right_bp, index + 2));
    } else {
        return tokens[index].value;
    }

    return try calculate(tokens[index + 1].operator, value, try parse_expression(tokens, operator_bind_power(tokens[index + 1]), index + 2));
}

const method_tag = enum {
    operator,
    value,
};

const method = union(method_tag) {
    operator: u8,
    value: f64,
};

fn evaluate(expr: []const u8) !f64 {
    if (expr.len == 0) {
        return 0;
    }
    var buf_m: [100]method = undefined;

    for (expr, 0..) |part, i| {
        if (part >= '0' and part <= '9') {
            buf_m[i] = method{ .value = @as(f64, @floatFromInt(part - '0')) };
        } else {
            switch (part) {
                '*' => { buf_m[i] = method{ .operator = part }; },
                '/' => { buf_m[i] = method{ .operator = part }; },
                '-' => { buf_m[i] = method{ .operator = part }; },
                '+' => { buf_m[i] = method{ .operator = part }; },
                ' ' => continue,
                else => { std.debug.print("Syntax Error.\n\n", .{}); }
            }
        }
    }

    const expr_method = buf_m[0..expr.len];
    const value = try parse_expression(expr_method, 0, 0);
    return value;
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

test "e1" {
    const eval = try evaluate("1+1");
    try std.testing.expect(eval == 2.0);
}
test "e2" {
    const eval = try evaluate("  4 - 3");
    try std.testing.expect(eval == 1.0);
}
test "e3" {
    const eval = try evaluate("3*3+4*2");
    try std.testing.expect(eval == 17.0);
}
test "e4" {
    const eval = try evaluate("3/3+ 3+1");
    try std.testing.expect(eval == 5.0);
}
