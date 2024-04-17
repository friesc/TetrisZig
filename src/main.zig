const rl = @import("raylib");
const std = @import("std");

const BlockType = enum { Empty, I, J, L, O, S, T, Z };

pub fn main() !void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 250;
    const screenHeight = 700;

    //const stage = [3][4]BlockType{
    //    [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
    //    [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
    //    [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
    //}

    const playgrid = [24][10]BlockType{
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
        [_]BlockType{ BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty, BlockType.Empty },
    };

    rl.initWindow(screenWidth, screenHeight, "Test");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    var frame_counter: u64 = 0;

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------
        frame_counter += 1;

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.black);

        for (1..10) |col_idx| {
            rl.drawLine(@intCast(col_idx * 25), 100, @intCast(col_idx * 25), screenHeight, rl.Color.light_gray);
        }
        for (0..24) |row_idx| {
            rl.drawLine(0, @intCast((row_idx * 25) + 100), screenWidth, @intCast((row_idx * 25) + 100), rl.Color.light_gray);
        }

        for (playgrid, 0..) |row, row_idx| {
            for (row, 0..) |block, col_idx| {
                const posX: i32 = @intCast(col_idx * 25);
                const posY: i32 = @intCast((row_idx * 25) + 100);

                switch (block) {
                    BlockType.I => {
                        rl.drawRectangle(posX, posY, 25, 25, rl.Color.pink);
                    },
                    BlockType.J => {
                        rl.drawRectangle(posX, posY, 25, 25, rl.Color.blue);
                    },
                    BlockType.L => {
                        rl.drawRectangle(posX, posY, 25, 25, rl.Color.orange);
                    },
                    BlockType.O => {
                        rl.drawRectangle(posX, posY, 25, 25, rl.Color.yellow);
                    },
                    BlockType.S => {
                        rl.drawRectangle(posX, posY, 25, 25, rl.Color.green);
                    },
                    BlockType.T => {
                        rl.drawRectangle(posX, posY, 25, 25, rl.Color.purple);
                    },
                    BlockType.Z => {
                        rl.drawRectangle(posX, posY, 25, 25, rl.Color.red);
                    },
                    else => {},
                }
            }
        }

        var buf: [128]u8 = undefined;
        var buf_slice: [:0]u8 = try std.fmt.bufPrintZ(&buf, "Time: {d}", .{@divTrunc(frame_counter, 60)});
        rl.drawText(buf_slice, 5, 5, 7, rl.Color.light_gray);
        //----------------------------------------------------------------------------------
    }
}
