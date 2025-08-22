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

// TODO: Fix calculation statements.
fn parse_expression(tokens: []const method, bp: u8, index: usize) !f64 {
    if (tokens.len <= index + 2) return tokens[index].value;

    const lhs = tokens[index].value;

    const cbp = operator_bind_power(tokens[index + 1]);
    if (bp + 1 < cbp) {
        return calculate(tokens[index + 1].operator, lhs, tokens[index + 2].value);
    } else {
        return calculate(tokens[index + 1].operator, lhs, try parse_expression(tokens, cbp, index + 2));
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
    std.debug.print("{s}\n", .{expr});
    std.debug.print("{any}\n", .{expr_method});
    return try parse_expression(expr_method, 0, 0);
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
            std.debug.print("{d}, ", .{result});
        }
    } else {
        std.debug.print("No mathematical expression detected.\n\n", .{});
        return;
    }

    return;
}
