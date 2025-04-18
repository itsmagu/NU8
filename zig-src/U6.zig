const std = @import("std");
const print = std.debug.print;

// Our 24 bit type
pub const Set = packed struct { pri: u6, duo: u6, tri: u6, tet: u6 };

pub fn charTob6(in: u8) u6 {
    return switch (in) {
        97...122 => @intCast(in - 96),
        65...90 => @intCast((in - 32)),
        48...52 => @intCast(in - 21),
        53...57 => @intCast(in + 6),
        32 => 0,
        10 => 32,
        else => 0,
    };
}

pub fn b6ToChar(in: u6) u8 {
    return switch (in) {
        0 => 32,
        1...26 => @as(u8, @intCast(in)) + 96,
        27...31 => @as(u8, @intCast(in)) + 21,
        32 => 10,
        33...58 => @as(u8, @intCast(in)) + 32,
        59...63 => @as(u8, @intCast(in)) - 6,
    };
}

pub fn b8ToB6(allocator: std.mem.Allocator, src: []u8) []Set {
    const sets = src.len / 4;
    const reminder = src.len % 4;
    var dest: []Set = undefined;
    if (reminder != 0) {
        dest = allocator.alloc(Set, sets+1) catch &[_]Set{};
    } else {
        dest = allocator.alloc(Set, sets) catch &[_]Set{};
    }
    for (0..sets) |set| {
        const i = set * 4;
        dest[set].pri = charTob6(src[i]);
        dest[set].duo = charTob6(src[i + 1]);
        dest[set].tri = charTob6(src[i + 2]);
        dest[set].tet = charTob6(src[i + 3]);
    }
    switch (reminder) {
        1 => {
            dest[sets].pri = charTob6(src[sets * 4]);
            dest[sets].duo = 0;
            dest[sets].tri = 0;
            dest[sets].tet = 0;
        },
        2 => {
            dest[sets].pri = charTob6(src[sets * 4]);
            dest[sets].duo = charTob6(src[sets * 4 + 1]);
            dest[sets].tri = 0;
            dest[sets].tet = 0;
        },
        3 => {
            dest[sets].pri = charTob6(src[sets * 4]);
            dest[sets].duo = charTob6(src[sets * 4 + 1]);
            dest[sets].tri = charTob6(src[sets * 4 + 2]);
            dest[sets].tet = 0;
        },
        else => {},
    }
    return dest;
}

pub fn b6ToB8(allocator: std.mem.Allocator, src: []Set) []u8 {
    var dest = allocator.alloc(u8, src.len*4) catch return "";
    for (src,0..) |set,i| {
        dest[i*4] = b6ToChar(set.pri);
        dest[i*4+1] = b6ToChar(set.duo);
        dest[i*4+2] = b6ToChar(set.tri);
        dest[i*4+3] = b6ToChar(set.tet);
    }
    return dest;
    //TODO strip trailing spaces
}

pub fn printB6(src: []Set) void { // Debug
    const stdin = std.io.getStdOut().writer();
    for (0..src.len) |i| {
        stdin.print("{b} {b} {b} {b} = {c} {c} {c} {c}\n", .{ src[i].pri, src[i].duo, src[i].tri, src[i].tet, b6ToChar(src[i].pri), b6ToChar(src[i].duo), b6ToChar(src[i].tri), b6ToChar(src[i].tet) }) catch unreachable;
    }
}

pub fn loadB6FromFile(file: std.fs.File, allocator: std.mem.Allocator) ![]Set {
    const stat = try file.stat();
    // print("{} bits in {} bytes\n", .{ stat.size * 8, stat.size });
    const memory = try allocator.alloc(Set, stat.size / 3);
    // print("We will read {} bytes into {} sets\n", .{ stat.size, stat.size / 3 });
    var reader = std.io.bitReader(.big, file.reader());
    for (memory, 0..) |_, i| {
        const bits = try reader.readBitsNoEof(u24, 24);
        // print("{b}\n", .{bits});
        const sets: *Set = @ptrCast(@constCast(&bits));
        memory[i] = sets.*;
    }
    return memory;
}

pub fn writeB6ToFile(memory6B: []Set, file: std.fs.File) !void {
    const memoryptr: *[]u24 = @ptrCast(@constCast(&memory6B));
    var writer = std.io.bitWriter(.big, file.writer());
    for (memory6B, 0..) |_, i| {
        try writer.writeBits(memoryptr.*[i], 24);
    }
}
