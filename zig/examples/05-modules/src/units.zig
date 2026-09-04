//! main.zig と同じディレクトリのファイル。@import("units.zig") で読む
pub const Meters = struct {
    val: f32,
    pub fn toCm(self: Meters) f32 {
        return self.val * 100;
    }
};
