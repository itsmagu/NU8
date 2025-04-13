const std = @import("std");
const print = std.debug.print;
const mem = std.mem;

// Let main look as close to client/user code as possible!
pub fn main() !void {
    // Open
    var file = try std.fs.cwd().createFile("output", .{});
    defer file.close(); // Close file on scope exit

    // Generate
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const str = "Hellow Guys";
    print("\nstr is \"{s}\"\n", .{str});

    const memory8B = try allocator.alloc(u8, str.len);
    print("Memory is of size {}\n", .{str.len});
    @memcpy(memory8B, str);

    // Transformat
    const memory6B = try allocator.alloc(Set, 2);
    b8ToB6(memory8B, memory6B);

    // Print
    printB6(memory6B);

    // Write
    try file.writeAll(memory8B);
}

const Set = packed struct { pri: u6, duo: u6, tri: u6, tet: u6 };

const U6 = enum(u6) {
    A,
    B,
    C,
    D,
    E,
    F,
    G,
    H,
    I,
    J,
    K,
    L,
    M,
    N,
    O,
    P,
    Q,
    R,
    S,
    T,
    U,
    V,
    W,
    X,
    Y,
    Z,
    a,
    b,
    c,
    d,
    e,
    f,
    g,
    h,
    i,
    j,
    k,
    l,
    m,
    n,
    o,
    p,
    q,
    r,
    s,
    t,
    u,
    v,
    w,
    x,
    y,
    z,
    zero,
    one,
    two,
    three,
    four,
    five,
    six,
    seven,
    eight,
    nine,
    SPECIAL1,  // Space
    SPECIAL2,  // NEWLINE
};

fn charTob6(in: u8) u6 {
    return switch (in) {
        65...90 => @intCast(in-65),
        97...122 => @intCast(in-97+26),
        else => 23
    };
}

fn b8ToB6(src: []u8, dest: []Set) void {
    // Split src into sets of 4
    const sets = src.len / 4;
    print("sets = {}\n", .{sets});
    for (0..sets) |set| {
        const i = set * 4;
        print("i = {}\n", .{i});
        for (0..4) |j| {
            src[i + j] = @intCast(49 + j);
            print("i + j = {}\n", .{i + j});
        }
        print("{}\n", .{charTob6(src[i])});
        dest[set].pri = charTob6(src[i]);
        dest[set].duo = charTob6(src[i+1]);
        dest[set].tri = charTob6(src[i+2]);
        dest[set].tet = charTob6(src[i+3]);
    }
    const reminder = src.len % 4;
    if (reminder != 0) {
        for (0..reminder) |i| {
            src[sets * 4 + i] = 37;
        }
    }
}

fn printB6(src: []Set) void {
    for (0..src.len) |i| {
        print("{b} {b} {b} {b} {d}{d}{d}{d}\n", .{ src[i].pri, src[i].duo, src[i].tri, src[i].tet, src[i].pri, src[i].duo, src[i].tri, src[i].tet });
    }
}
