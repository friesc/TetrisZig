const std = @import("std");
const rl = @import("raylib");
const pieces = @import("pieces.zig");
const Piece = pieces.Piece;
const PieceType = pieces.PieceType;

pub fn stageCell(comptime inSize: u8) type {
    return struct {
        const size: u8 = inSize;
        piece: ?PieceType = null,
    };
}

pub fn stage(comptime inRowCount: i32, comptime inColCount: i32, comptime inCellSize: i32) type {
    return struct {
        xPos: i32,
        yPos: i32,
        gridColor: rl.Color = rl.Color.light_gray,
        cells: [inColCount * inRowCount]?PieceType = [_]?PieceType{null} ** (inColCount * inRowCount),

        const cellSize: i32 = inCellSize;
        const rowCount: i32 = inRowCount;
        const colCount: i32 = inColCount;
        const width: i32 = inColCount * inCellSize;
        const height: i32 = inRowCount * inCellSize;
        const Self = @This();

        pub fn init(inXpos: i32, inYpos: i32) Self {
            return .{ .xPos = inXpos, .yPos = inYpos };
        }

        pub fn setPiece(self: *Self, x: u32, y: u32, piece: Piece) void {
            _ = x;
            _ = y;
            const RndGen = std.rand.DefaultPrng;
            var rnd = RndGen.init(0);
            const layoutIdx = rnd.random().int(usize) % piece.layout.len;
            for (0..piece.layout[layoutIdx].len) |col_idx| {
                for (0..piece.layout[layoutIdx][col_idx].len) |row_idx| {
                    const pieceIdx = col_idx * piece.layout[layoutIdx][col_idx].len + row_idx;
                    if (piece.layout[layoutIdx][col_idx][row_idx]) {
                        self.cells[pieceIdx] = piece.type;
                    } else {
                        self.cells[pieceIdx] = null;
                    }
                }
            }
        }

        pub fn drawCells(self: *Self) void {
            for (self.cells, 0..self.cells.len) |cell, idx| {
                if (cell) |pieceType| {
                    const piece = pieces.pieces[@intFromEnum(pieceType)];

                    const x = @rem(@as(i32, @intCast(idx)), Self.colCount);
                    const y = @mod(@as(i32, @intCast(idx)), Self.colCount);
                    rl.drawRectangle(x, y, Self.cellSize, Self.cellSize, piece.color);
                }
            }
        }

        pub fn drawGridLines(self: Self) void {
            for (0..colCount + 1) |col_idx| {
                const colXPos: i32 = self.xPos + @as(i32, @intCast(col_idx)) * Self.cellSize;
                rl.drawLine(colXPos, self.yPos, colXPos, self.yPos + Self.height, self.gridColor);
            }
            for (0..rowCount + 1) |row_idx| {
                const rowYPos: i32 = self.yPos + @as(i32, @intCast(row_idx)) * Self.cellSize;
                rl.drawLine(self.xPos, rowYPos, self.xPos + Self.width, rowYPos, self.gridColor);
            }
        }
    };
}
