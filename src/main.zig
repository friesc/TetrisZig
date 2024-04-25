const rl = @import("raylib");
const std = @import("std");
const pieces = @import("pieces.zig");
const st = @import("stage.zig");
const Piece = pieces.Piece;
const PieceType = pieces.PieceType;
const Rnd = std.rand.Xoshiro256;

const cellSize = 25;
const verticalCellCount: comptime_int = 24;
const horizontalCellCount: comptime_int = 10;
const topAreaHeight: comptime_int = 150;
const PlayStage = st.stage(verticalCellCount, horizontalCellCount, cellSize);
const PreStage = st.stage(4, 4, cellSize);

const screenWidth: comptime_int = horizontalCellCount * cellSize;
const screenHeight: comptime_int = topAreaHeight + verticalCellCount * cellSize;

pub fn main() !void {
    // Initialization
    //--------------------------------------------------------------------------------------
    var frameCounter: u64 = 0;

    var playStage = PlayStage.init(0, topAreaHeight);

    rl.initWindow(screenWidth, screenHeight, "Tetris");
    rl.setWindowPosition(100, 100);

    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------
        const currentSecondsPassed: u64 = @divTrunc(frameCounter, 60);
        playStage.update(rl.getFrameTime());

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.black);

        playStage.draw();

        var time_str_buf: [128]u8 = undefined;
        var buf_str_slice: [:0]u8 = try std.fmt.bufPrintZ(&time_str_buf, "Time: {d}", .{currentSecondsPassed});
        rl.drawText(buf_str_slice, 5, 5, 7, rl.Color.light_gray);

        var score_str_buf: [128]u8 = undefined;
        var score_str_slice: [:0]u8 = try std.fmt.bufPrintZ(&score_str_buf, "Score: {d}", .{0});
        rl.drawText(score_str_slice, 75, 5, 7, rl.Color.light_gray);
        //----------------------------------------------------------------------------------
        frameCounter += 1;
    }
}
