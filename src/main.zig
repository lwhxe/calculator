const std = @import("std");

fn prompt() !f64 {
    const stdin = std.io.getStdIn();
    var buffer: [100]u8 = undefined;
    std.debug.print("Please input a numeric value: ", .{});
    return try std.fmt.parseFloat(f64, try nextLine(stdin.reader(), &buffer) orelse "");
}

fn nextLine(reader: anytype, buffer: []u8) !?[]const u8 {
    const line = (try reader.readUntilDelimiterOrEof(
            buffer,
            '\n',
    )) orelse return null;
    return std.mem.trimRight(u8, line, "\r");
}

pub fn main() !void {
    const stdin = std.io.getStdIn();
    defer stdin.close();
    var buffer: [100]u8 = undefined;

    std.debug.print(\\Welcome to the calculator.
                    \\You will be prompted to input values and operands, until you input \"n\" or \"stop\".
                    \\
                    , .{});

    var total: f64 = undefined;
    std.debug.print("Please input a numeric value: ", .{});
    const first_value_string = try nextLine(stdin.reader(), &buffer) orelse "";
    total = try std.fmt.parseFloat(f64, first_value_string);

    while (true) {
        std.debug.print("Which operand would you like to use? (+, -, *, /) ", .{});
        const operand_string = try nextLine(stdin.reader(), &buffer) orelse "";

        p: switch (operand_string[0]) {
            '*' => {
                total *= try prompt();
            },
            '/' => {
                const div = try prompt();
                if (div == 0) continue :p '/';
                total /= div;
            },
            '+' => {
                total += try prompt();
            },
            '-' => {
                total -= try prompt();
            },
            else => { break; },
        }

        std.debug.print("Current total: {d}\n", .{total});
    }

    return;
}
