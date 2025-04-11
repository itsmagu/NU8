const std = @import("std");
const print = std.debug.print;
const mem = std.mem;

pub fn main() !void {
    // Open
    var file = try std.fs.cwd().createFile("output", .{});
    defer file.close(); // Close file on scope exit

    // Generate
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const str = "Hellow Guys";
    print("\nstr is \"{s}\"\n",.{str});
    
    print("Arena is {} in size\n", .{arena.queryCapacity()});
    const memory8B = try allocator.alloc(u8, str.len);
    print("Arena is {} in size\n", .{arena.queryCapacity()});

    print("Memory is of size {}\n", .{str.len});
    @memcpy(memory8B, str);

    print("{s}\n",.{memory8B});
    for (0..memory8B.len-1) |i| {
        print("{c} - {b}\n", .{memory8B[i],memory8B[i]});
    }

// Transformat
    const memory7B = try allocator.alloc(u7, str.len); // size of u7
    print("Arena is {} in size\n", .{arena.queryCapacity()});
    for (0..memory7B.len-1) |i| {
        print("{c} - {b}\n", .{memory7B[i],memory7B[i]});
    }

    // Write
    try file.writeAll(memory8B);
}

fn b8ToB7(in: []u8) []u7 {
    _ = in;
}

// fn b7ToB8(in: []const u7) []const u8 {
    
// }
