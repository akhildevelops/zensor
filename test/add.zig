const zensor = @import("zensor");
const std = @import("std");
test "add" {
    try std.testing.expectEqual(7, zensor.add(3, 4));
}
