const std = @import("std");
const rl = @import("raylib");
const pieces = @import("pieces.zig");
const Piece = pieces.Piece;
const PieceType = pieces.PieceType;

pub fn stage(comptime inRowCount: i32, comptime inColCount: i32, comptime inCellSize: i32) type {
    return struct {
        xPos: i32,
        yPos: i32,

        activePiece: ?PieceType = null,
        activePieceIndices: [4]usize = [_]usize{0} ** 4,
        activePieceRotationIdx: usize = 0,
        activePieceSourceRowIndex: i32 = 0,
        activePieceSourceColIndex: i32 = 0,

        gridColor: rl.Color = rl.Color.light_gray,
        cells: [inColCount * inRowCount]?PieceType = [_]?PieceType{null} ** (inColCount * inRowCount),
        timeUntilNextDrop: f32 = 0.0,

        const cellSize: i32 = inCellSize;
        pub const rowCount: i32 = inRowCount;
        pub const colCount: i32 = inColCount;
        const width: i32 = inColCount * inCellSize;
        const height: i32 = inRowCount * inCellSize;

        const Move = enum { Down, Left, Right };
        const Self = @This();

        pub fn init(inXpos: i32, inYpos: i32) Self {
            var self: Self = .{ .xPos = inXpos, .yPos = inYpos };

            const randomPiece = Self.selectRandomPiece();
            const piece = pieces.pieces[@intFromEnum(randomPiece.pieceType)];
            self.spawnPiece(3, 0, randomPiece.rotationIdx, piece);

            return self;
        }

        pub fn update(self: *Self, dt: f32) void {
            self.timeUntilNextDrop = if (self.timeUntilNextDrop > dt) self.timeUntilNextDrop - dt else 0.0;

            if (self.timeUntilNextDrop == 0) {
                self.timeUntilNextDrop = 1.0;
                if (self.willActivePieceCollide(Move.Down)) {
                    // check furll lines
                    for (self.checkForFullLines()) |fullRowIdx| {
                        if (fullRowIdx == null)
                            continue;

                        // shift all blocks above this (from 0 - rowIdx) one down
                        for (0..fullRowIdx.?) |reverseCurrentRowIdx| {
                            const currentRowIdx = fullRowIdx.? - reverseCurrentRowIdx;
                            for (0..Self.colCount) |colIndx|
                                self.cells[currentRowIdx * Self.colCount + colIndx] = if (currentRowIdx > 0) self.cells[(currentRowIdx - 1) * Self.colCount + colIndx] else null;
                        }
                    }

                    const randomPiece = Self.selectRandomPiece();
                    const piece = pieces.pieces[@intFromEnum(randomPiece.pieceType)];
                    self.spawnPiece(3, 0, randomPiece.rotationIdx, piece);
                } else {
                    self.movePiece(Move.Down);
                }
            }

            if (rl.isKeyPressed(rl.KeyboardKey.key_right) and !self.willActivePieceCollide(Move.Right)) {
                self.movePiece(Move.Right);
            } else if (rl.isKeyPressed(rl.KeyboardKey.key_left) and !self.willActivePieceCollide(Move.Left)) {
                self.movePiece(Move.Left);
            } else if (rl.isKeyPressed(rl.KeyboardKey.key_down) and !self.willActivePieceCollide(Move.Down)) {
                self.movePiece(Move.Down);
            } else if (rl.isKeyPressed(rl.KeyboardKey.key_space)) {
                while (!self.willActivePieceCollide(Move.Down))
                    self.movePiece(Move.Down);
            } else if (rl.isKeyPressed(rl.KeyboardKey.key_up)) {
                self.tryRotatePiece();
            }
        }

        pub fn clearStage(self: *Self) void {
            for (0..self.cells.len) |idx| {
                self.cells[idx] = null;
            }
        }

        pub fn draw(self: *Self) void {
            const fullRowIndices = self.checkForFullLines();

            for (self.cells, 0..self.cells.len) |cell, idx| {
                if (cell) |pieceType| {
                    const piece = pieces.pieces[@intFromEnum(pieceType)];

                    const colIdx = @rem(@as(i32, @intCast(idx)), Self.colCount);
                    const rowIdx = @divFloor(@as(i32, @intCast(idx)), Self.colCount);
                    const x = self.xPos + (colIdx * Self.cellSize);
                    const y = self.yPos + (rowIdx * Self.cellSize);

                    var color = piece.color;
                    for (fullRowIndices) |fullRowIdx| {
                        if (fullRowIdx == null)
                            continue;

                        if (fullRowIdx.? == rowIdx) {
                            color = rl.Color.white;
                            break;
                        }
                    }

                    rl.drawRectangle(x, y, Self.cellSize, Self.cellSize, color);
                }
            }
            for (0..colCount + 1) |col_idx| {
                const colXPos: i32 = self.xPos + @as(i32, @intCast(col_idx)) * Self.cellSize;
                rl.drawLine(colXPos, self.yPos, colXPos, self.yPos + Self.height, self.gridColor);
            }
            for (0..rowCount + 1) |row_idx| {
                const rowYPos: i32 = self.yPos + @as(i32, @intCast(row_idx)) * Self.cellSize;
                rl.drawLine(self.xPos, rowYPos, self.xPos + Self.width, rowYPos, self.gridColor);
            }
        }

        fn selectRandomPiece() struct { rotationIdx: usize, pieceType: PieceType } {
            var rnd = std.rand.DefaultPrng.init(@as(u64, @bitCast(std.time.milliTimestamp())));
            const pieceIdx: u64 = rnd.random().uintLessThan(u64, pieces.pieces.len);
            const layoutIdx: u64 = rnd.random().uintLessThan(u64, pieces.pieces[pieceIdx].layout.len);
            return .{ .rotationIdx = layoutIdx, .pieceType = pieces.pieces[pieceIdx].type };
        }

        fn spawnPiece(self: *Self, x: i32, y: i32, rotationIdx: usize, piece: Piece) void {
            self.activePieceSourceColIndex = x;
            self.activePieceSourceRowIndex = y;

            self.activePieceRotationIdx = rotationIdx;
            self.activePiece = piece.type;
            var currentPieceIndex: usize = 0;
            for (0..piece.layout[rotationIdx].len) |row_idx| {
                for (0..piece.layout[rotationIdx][row_idx].len) |col_idx| {
                    const cellColIdx = x + @as(i32, @intCast(col_idx));
                    const cellRowIdx = (y + @as(i32, @intCast(row_idx))) * Self.colCount;
                    const cellIdx = @as(usize, @intCast(cellColIdx + cellRowIdx));
                    if (piece.layout[rotationIdx][row_idx][col_idx]) {
                        self.cells[cellIdx] = piece.type;
                        self.activePieceIndices[currentPieceIndex] = cellIdx;
                        currentPieceIndex = currentPieceIndex + 1;
                    } else {
                        self.cells[cellIdx] = null;
                    }
                }
            }
        }

        // There is a bug here that rotating a piece at the left edge will not shift it 1 to the right
        fn tryRotatePiece(self: *Self) void {
            if (self.activePiece == null)
                return;

            const piece = pieces.pieces[@intFromEnum(self.activePiece.?)];
            const newRotationIndex = @mod(self.activePieceRotationIdx + 1, piece.layout.len);

            var willCollide = false;

            var numFoundActiveIndices: u8 = 0;
            var newActiveIndices: [4]usize = [_]usize{0} ** 4;

            outer: for (0..piece.layout[newRotationIndex].len) |row_idx| {
                for (0..piece.layout[newRotationIndex][row_idx].len) |col_idx| {
                    const cellColIdx = self.activePieceSourceColIndex + @as(i32, @intCast(col_idx));
                    const cellRowIdx = (self.activePieceSourceRowIndex + @as(i32, @intCast(row_idx))) * Self.colCount;
                    const cellIdx = @as(usize, @intCast(cellColIdx + cellRowIdx));
                    if (piece.layout[newRotationIndex][row_idx][col_idx]) {
                        const willSelfCollide = std.mem.indexOf(usize, &self.activePieceIndices, &[_]usize{cellIdx}) != null;
                        if (self.cells[cellIdx] != null and !willSelfCollide) {
                            willCollide = true;
                            break :outer;
                        } else {
                            newActiveIndices[numFoundActiveIndices] = cellIdx;
                            numFoundActiveIndices = numFoundActiveIndices + 1;
                        }
                    }
                }
            }

            if (!willCollide) {
                for (self.activePieceIndices) |cellIdx| {
                    self.cells[cellIdx] = null;
                }

                self.activePieceIndices = newActiveIndices;

                for (self.activePieceIndices) |cellIdx| {
                    self.cells[cellIdx] = self.activePiece;
                }

                self.activePieceRotationIdx = newRotationIndex;
            }
        }

        fn movePiece(self: *Self, move: Move) void {
            for (self.activePieceIndices) |cellIdx| {
                self.cells[cellIdx] = null;
            }

            for (self.activePieceIndices, 0..self.activePieceIndices.len) |cellIdx, activePiecesIdx| {
                const newCellIdx = switch (move) {
                    Move.Down => cellIdx + Self.colCount,
                    Move.Left => cellIdx - 1,
                    Move.Right => cellIdx + 1,
                };

                self.cells[newCellIdx] = self.activePiece;
                self.activePieceIndices[activePiecesIdx] = newCellIdx;
            }

            switch (move) {
                Move.Down => self.activePieceSourceRowIndex = self.activePieceSourceRowIndex + 1,
                Move.Left => self.activePieceSourceColIndex = self.activePieceSourceColIndex - 1,
                Move.Right => self.activePieceSourceColIndex = self.activePieceSourceColIndex + 1,
            }
        }

        fn willActivePieceCollide(self: Self, move: Move) bool {
            for (self.activePieceIndices) |cellIdx| {
                const colIdx = @rem(@as(i32, @intCast(cellIdx)), Self.colCount);
                const rowIdx = @divFloor(@as(i32, @intCast(cellIdx)), Self.colCount);

                var newCellIdx = cellIdx;
                if (move == Move.Down) {
                    if (rowIdx + 1 >= Self.rowCount)
                        return true;

                    newCellIdx = cellIdx + Self.colCount;
                }

                if (move == Move.Right) {
                    if (colIdx + 1 >= Self.colCount)
                        return true;

                    newCellIdx = cellIdx + 1;
                }

                if (move == Move.Left) {
                    if (colIdx - 1 < 0)
                        return true;

                    newCellIdx = cellIdx - 1;
                }

                const collidesWithSelf = std.mem.indexOf(usize, &self.activePieceIndices, &[_]usize{newCellIdx}) != null;
                if (self.cells[newCellIdx] != null and !collidesWithSelf)
                    return true;
            }

            return false;
        }

        fn checkForFullLines(self: *Self) [4]?usize {
            var numFullLines: usize = 0;
            var fullLines: [4]?usize = [_]?usize{null} ** 4;

            for (0..Self.rowCount) |rowIdx| {
                var fullLine = true;
                for (0..Self.colCount) |colIdx| {
                    if (self.cells[(rowIdx * Self.colCount) + colIdx] == null) {
                        fullLine = false;
                        break;
                    }
                }

                if (fullLine) {
                    fullLines[numFullLines] = rowIdx;
                    numFullLines = numFullLines + 1;
                }
            }

            return fullLines;
        }
    };
}
