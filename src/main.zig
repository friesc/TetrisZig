const rl = @import("raylib");
const std = @import("std");
const pieces = @import("pieces.zig");
const st = @import("stage.zig");
const Piece = pieces.Piece;
const PieceType = pieces.PieceType;

const cellSize = 25;
const verticalCellCount: comptime_int = 24;
const horizontalCellCount: comptime_int = 10;
const topAreaHeight: comptime_int = 150;
const PlayStage = st.stage(verticalCellCount, horizontalCellCount, cellSize);
const PreStage = st.stage(4, 4, cellSize);

const screenWidth: comptime_int = horizontalCellCount * cellSize;
const screenHeight: comptime_int = verticalCellCount * cellSize;

pub fn main() !void {
    // Initialization
    //--------------------------------------------------------------------------------------
    var frameCounter: u64 = 0;
    var prevSecondsPassed: u32 = 0;

    var playStage = PlayStage.init(0, topAreaHeight);
    var preStage = PreStage.init(72, 25);

    rl.initWindow(screenWidth, screenHeight, "Test");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------
        frameCounter += 1;
        const currentSecondsPassed = @divTrunc(frameCounter, 60);

        if (currentSecondsPassed > prevSecondsPassed) {
            preStage.setPiece(0, 0, pieces.GetRandomPiece());
        }
        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.black);

        preStage.drawCells();
        preStage.drawGridLines();
        playStage.drawGridLines();

        var buf: [128]u8 = undefined;
        var buf_slice: [:0]u8 = try std.fmt.bufPrintZ(&buf, "Time: {d}", .{currentSecondsPassed});
        rl.drawText(buf_slice, 5, 5, 7, rl.Color.light_gray);
        //----------------------------------------------------------------------------------
    }
}
