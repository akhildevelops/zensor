const std = @import("std");
const zigtest = @import("zigtest");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const zensor_module = b.addModule("zensor", .{ .root_source_file = b.path("src/lib.zig"), .target = target, .optimize = optimize });

    //Register zigTestBuilder
    var zigTestBuilder = zigtest.init(b, .{ .target = target, .optimize = optimize, .package_name = "zensor" });
    try zigTestBuilder.addModule("zensor", zensor_module);
    try zigTestBuilder.register();
}
