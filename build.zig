const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
         .name = "NU8",
         .root_source_file = b.path("zig-src/main.zig"),
         .target = b.graph.host
    });
    exe.linkLibC();
    b.installArtifact(exe);
}
