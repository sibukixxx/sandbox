//! build.zig: Zig のビルドは Zig で書く。モジュールの定義と依存関係をここで宣言する。
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // 名前付きモジュール "geometry"。ルートファイルは src/geometry/root.zig
    const geometry = b.addModule("geometry", .{
        .root_source_file = b.path("src/geometry/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    // 実行ファイル。main.zig から @import("geometry") できるように imports に登録する
    const exe = b.addExecutable(.{
        .name = "modules",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "geometry", .module = geometry }},
        }),
    });
    b.installArtifact(exe);

    // `zig build run`
    const run = b.addRunArtifact(exe);
    b.step("run", "Run the app").dependOn(&run.step);

    // `zig build test`: geometry モジュールのテストを実行する
    const tests = b.addTest(.{ .root_module = geometry });
    b.step("test", "Run tests").dependOn(&b.addRunArtifact(tests).step);
}
