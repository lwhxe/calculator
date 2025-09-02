const std = @import("std");

fn nextLine(reader: anytype, buffer: []u8) !?[]const u8 {
    const line = (try reader.readUntilDelimiterOrEof(
            buffer,
            '\n',
    )) orelse return null;
    return std.mem.trimRight(u8, line, "\r");
}

pub fn main() void {
    const stdin = std.io.getStdIn();
    _ = stdin;

    return;
}
