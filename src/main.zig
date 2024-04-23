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
const screenHeight: comptime_int = verticalCellCount * cellSize;

pub fn main() !void {
    // Initialization
    //--------------------------------------------------------------------------------------
    var rnd: Rnd = std.rand.DefaultPrng.init(@as(u64, @bitCast(std.time.milliTimestamp())));
    var frameCounter: u64 = 0;
    var prevSecondsPassed: u64 = 0;

    var playStage = PlayStage.init(0, topAreaHeight);
    var preStage = PreStage.init(72, 25);

    var selectedPiece: ?Piece = null;
    var selectedOrientation: u64 = 0;

    rl.initWindow(screenWidth, screenHeight, "Tetris");
    rl.setWindowPosition(1920, 50);

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

        if (rl.isKeyPressed(rl.KeyboardKey.key_n) or frameCounter == 0) {
            const pieceIdx: u64 = rnd.random().uintLessThan(u64, pieces.pieces.len);
            selectedPiece = pieces.pieces[pieceIdx];

            selectedOrientation = rnd.random().uintLessThan(u64, 4);
            preStage.clearStage();
            preStage.setPiece(0, 0, selectedOrientation, selectedPiece.?);
            playStage.setPiece(4, 0, selectedOrientation, selectedPiece.?);
        }

        if (rl.isKeyPressed(rl.KeyboardKey.key_space)) {
            selectedOrientation = @mod(selectedOrientation + 1, 4);
            preStage.clearStage();
            preStage.setPiece(0, 0, selectedOrientation, selectedPiece.?);
            playStage.setPiece(4, 0, selectedOrientation, selectedPiece.?);
        }

        if (currentSecondsPassed > prevSecondsPassed) {
            prevSecondsPassed = currentSecondsPassed;
        }

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.black);

        preStage.drawCells();
        playStage.drawCells();
        preStage.drawGridLines();
        playStage.drawGridLines();

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
