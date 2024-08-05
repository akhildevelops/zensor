const std = @import("std");
const zigtest = @import("zigtest");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const zensor_module = b.addModule("zensor", .{ .root_source_file = b.path("src/lib.zig"), .target = target, .optimize = optimize });

    //Add test runner
    test_blk: {
        const test_file = std.fs.cwd().openFile("build.zig.zon", .{}) catch {
            break :test_blk;
        };
        defer test_file.close();

        const test_file_contents = try test_file.readToEndAlloc(b.allocator, std.math.maxInt(usize));
        defer b.allocator.free(test_file_contents);

        // Hack for identifying if the current root is cudaz project, if not don't register tests.
        if (std.mem.indexOf(u8, test_file_contents, ".name = \"zensor\"") == null) {
            break :test_blk;
        }

        var zigTestBuilder = zigtest.init(b, .{ .target = target, .optimize = optimize });
        try zigTestBuilder.addModule("zensor", zensor_module);
        try zigTestBuilder.register();
    }
}
