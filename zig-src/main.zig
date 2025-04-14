const std = @import("std");
const print = std.debug.print;
const mem = std.mem;

// Let main look as close to client/user code as possible!
pub fn main() !void {
    // Open
    var file = try std.fs.cwd().createFile("output", .{});

    // Generate
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const str = "Cool String with upper and lowercase symbols with support for space and newlines aswell as numbers";
    print("\nstr is \"{s}\"\n", .{str});

    const memory8B = try allocator.alloc(u8, str.len);
    print("Memory8B is of size {}\n", .{memory8B.len * @bitSizeOf(u8)});
    @memcpy(memory8B, str);

    // Transformat
    var sets = str.len / 4;
    if (str.len % 4 != 0 ){
        sets += 1;
    }
    const memory6B = try allocator.alloc(Set, sets);
    print("Memory6B is of size {}\n", .{memory6B.len * @bitSizeOf(Set)});
    b8ToB6(memory8B, memory6B);

    // Print
    printB6(memory6B);
    
    // Write file
    const memoryptr: *[]u24 = @ptrCast(@constCast(&memory6B));
    var writer = std.io.bitWriter(.little, file.writer());
    for (memory6B,0..) |_,i| {
        try writer.writeBits(memoryptr.*[i], 24);
    }
    file.close();
    // Read file
    const readfile = try std.fs.cwd().openFile("output", .{});
    const newmem6B = try loadB6fromFile(readfile, allocator);
    printB6(newmem6B);
    readfile.close();
}

const Set = packed struct { pri: u6, duo: u6, tri: u6, tet: u6 };

fn charTob6(in: u8) u6 {
    return switch (in) {
        48...57 => @intCast(in + 5),
        65...90 => @intCast(in - 65),
        97...122 => @intCast((in - 71)),
        32 => 62,
        10 => 63,
        else => 23,
    };
}

fn b6ToChar(in: u6) u8 {
    return switch (in) {
        0...25 => @as(u8, in) + 65,
        26...51 => @as(u8, in) + 71,
        52...61 => @as(u8, in) - 4,
        62 => 32,
        63 => 10,
    };
}

fn b8ToB6(src: []u8, dest: []Set) void {
    const sets = src.len / 4;
    const reminder = src.len % 4;
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
            dest[sets].duo = 62;
            dest[sets].tri = 62;
            dest[sets].tet = 62;
        },
        2 => {
            dest[sets].pri = charTob6(src[sets * 4]);
            dest[sets].duo = charTob6(src[sets * 4 + 1]);
            dest[sets].tri = 62;
            dest[sets].tet = 62;
        },
        3 => {
            dest[sets].pri = charTob6(src[sets * 4]);
            dest[sets].duo = charTob6(src[sets * 4 + 1]);
            dest[sets].tri = charTob6(src[sets * 4 + 2]);
            dest[sets].tet = 62;
        },
        else => {},
    }
}

fn printB6(src: []Set) void {
    for (0..src.len) |i| {
        print("{b} {b} {b} {b} = {c} {c} {c} {c}\n", .{ src[i].pri, src[i].duo, src[i].tri, src[i].tet, b6ToChar(src[i].pri), b6ToChar(src[i].duo), b6ToChar(src[i].tri), b6ToChar(src[i].tet) });
    }
}

fn loadB6fromFile(file:std.fs.File,allocator: std.mem.Allocator) ![]Set {
    const stat = try file.stat();
    print("{}\n", .{stat.size*8});
    const memory = try allocator.alloc(Set, stat.size/4);
    var reader = std.io.bitReader(.little, file.reader());
    for (memory,0..) |_,i| {
        const bits = try reader.readBitsNoEof(u24, 24);
        print("{b}\n", .{bits});
        const sets: *Set = @ptrCast(@constCast(&bits));
        memory[i] = sets.*;
    }
    return memory;
}
