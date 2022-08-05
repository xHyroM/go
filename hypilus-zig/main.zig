const std = @import("std");

pub fn main() void {
    const strings = [_]u8{'a', 'b', 'c'};

    std.debug.print("{s}", .{strings});
}