const std = @import("std");

fn prompt() !f64 {
    const stdin = std.io.getStdIn();
    var buffer: [100]u8 = undefined;
    std.debug.print("Please input a numeric value: ", .{});
    return std.fmt.parseFloat(f64, try nextLine(stdin.reader(), &buffer) orelse "") catch { std.debug.print("\x1b[A\x1b[2K\x1b[31mInvalid Character; \x1b[0m", .{}); return error.InvalidCharacter; };
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

    std.debug.print("Welcome to the calculator.\nYou will be prompted to input values and operands, until you input \x1b[32m\"n\"\x1b[0m as the operand.\n\n" , .{});

    var total: f64 = undefined;
    std.debug.print("Please input a numeric value: ", .{});
    const first_value_string = try nextLine(stdin.reader(), &buffer) orelse "";
    total = try std.fmt.parseFloat(f64, first_value_string);

    while (true) {
        std.debug.print("Which operand would you like to use? (+, -, *, /) \x1b[32m(\"n\" to quit)\x1b[0m ", .{});
        const operand_string = try nextLine(stdin.reader(), &buffer) orelse "";

        p: switch (operand_string[0]) {
            '*' => {
                total *= prompt() catch { continue :p operand_string[0]; };
            },
            '/' => {
                const div = prompt() catch { continue :p operand_string[0]; };
                if (div == 0) {
                    std.debug.print("\x1b[A\x1b[2K\x1b[31mDivision by zero; \x1b[0m", .{});
                    continue :p '/';
                }
                total /= div;
            },
            '+' => {
                total += prompt() catch { continue :p operand_string[0]; };
            },
            '-' => {
                total -= prompt() catch { continue :p operand_string[0]; };
            },
            'n' => { break; },
            else => { std.debug.print("\x1b[A\x1b[2K\x1b[31mInvalid Operand; \x1b[0m", .{}); continue; },
        }

        std.debug.print("Current total: {d}\n", .{total});
    }

    return;
}
