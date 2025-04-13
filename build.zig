const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
         .name = "NU8",
         .root_source_file = b.path("zig-src/main.zig"),
         .target = b.graph.host
    });
    // exe.linkLibC();
    b.installArtifact(exe);
    const run_exe = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the program");
    run_step.dependOn(&run_exe.step);
}
