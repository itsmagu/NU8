// I used this project to learn ZIG
const std = @import("std");
const U6 = @import("U6.zig");
const Allocator = std.mem.Allocator; // Import the Allocator Type

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit(); // This is why we don't need garbage collection B)
    const allocator = arena.allocator();
    print("Do you want to read a file[\"R\"] or write a line[\"W\"]");
    const in = try input(allocator);
    if (std.mem.eql(u8, in, "W")) {
        print("-" ** 20); // Very Python, I like it!
        print("The U6 format can only store a-z, A-Z, 0-9 and space"); // We can't include newline from a console read :(
        print("Write the text you want to store? MAX 128 Symbols!");
        const toWrite = try input(allocator);
        print("-" ** 20); // Very Python, I like it!
        print("What should be the name of the file? It will be stored in the current work directory");
        const fileName = try input(allocator);
        const mem = U6.b8ToB6(allocator, @as([]u8, @constCast(toWrite)));
        const file = try std.fs.cwd().createFile(fileName, .{});
        try U6.writeB6ToFile(mem, file);
        file.close();
    } else if (std.mem.eql(u8, in, "R")) {
        print("-" ** 20); // Very Python, I like it!
        print("What is the filename we should read in the current work directory?");
        const fileName = try input(allocator);
        if (std.fs.cwd().openFile(fileName, .{})) |file| {
            print("-" ** 20); // Very Python, I like it!
            const mem6B = try U6.loadB6FromFile(file, allocator);
            U6.printB6(mem6B);
            print(U6.b6ToB8(allocator, mem6B));
            file.close();
        } else |err| switch (err) {
            error.FileNotFound => {
                print("File was not found in the current work directory!");
            },
            error.InvalidUtf8 => {
                print("Filename is not valid UTF8");
            },
            error.FileTooBig => {
                print("File was too big");
            },
            error.DeviceBusy => {
                print("Device is busy Error!");
            },
            error.AccessDenied => {
                print("Access Denied Error!");
            },
            error.SystemResources => {
                print("System Resrouces Error!");
            },
            error.NoDevice => {
                print("No Device Error!");
            },
            error.AntivirusInterference => {
                print("Antivirus Interferance Error!");
            },
            error.SymLinkLoop => {
                print("Symlink loop Error!");
            },
            error.IsDir => {
                print("Filename is a Directory Error!");
            },
            error.FileBusy => {
                print("File is busy Error!");
            },
            else => {},
        }
    } else {
        print("-" ** 20); // Very Python, I like it!
        print("Not a valid operation!\nWrite a \"R\" or \"W\" next time");
    }
}

fn print(text: []const u8) void {
    const stdout = std.io.getStdOut().writer(); // We could cache this but whatever
    stdout.print("{s}\n", .{text}) catch unreachable; // Catch unreachable throws away erros, so we don't need to try on every print
}

fn input(allocator: Allocator) ![]const u8 {
    const stdin = std.io.getStdIn().reader();
    // The buffer is only 128 bytes so don't get your hopes up
    const bufinput: []u8 = try stdin.readUntilDelimiterOrEofAlloc(allocator, '\n', 128) orelse @constCast("");
    // We don't have to free this buffer since the passed allocator is a arena
    const result = std.mem.trimRight(u8, bufinput[0 .. bufinput.len - 1], "\r");
    return result;
}
