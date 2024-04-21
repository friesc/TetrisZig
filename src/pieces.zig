const std = @import("std");
const rl = @import("raylib");

pub const PieceType = enum { I, J, L, O, S, T, Z };

pub const Piece = struct {
    type: PieceType,
    color: rl.Color,
    layout: [4][4][4]bool,
};

const F = false;
const T = true;

pub const pieces = [_]Piece{
    Piece{
        .type = PieceType.I,
        .color = rl.Color.pink,
        .layout = [_][4][4]bool{
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, F, F, F },
                [_]bool{ T, T, T, T },
                [_]bool{ F, F, F, F },
            },
            [_][4]bool{
                [_]bool{ F, T, F, F },
                [_]bool{ F, T, F, F },
                [_]bool{ F, T, F, F },
                [_]bool{ F, T, F, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, F, F, F },
                [_]bool{ T, T, T, T },
                [_]bool{ F, F, F, F },
            },
            [_][4]bool{
                [_]bool{ F, T, F, F },
                [_]bool{ F, T, F, F },
                [_]bool{ F, T, F, F },
                [_]bool{ F, T, F, F },
            },
        },
    },
    Piece{
        .type = PieceType.J,
        .color = rl.Color.blue,
        .layout = [_][4][4]bool{
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, T, F, F },
                [_]bool{ F, T, F, F },
                [_]bool{ T, T, F, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ T, F, F, F },
                [_]bool{ T, T, T, F },
                [_]bool{ F, F, F, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, T, T, F },
                [_]bool{ F, T, F, F },
                [_]bool{ F, T, F, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, F, F, F },
                [_]bool{ T, T, T, F },
                [_]bool{ F, F, T, F },
            },
        },
    },
    Piece{
        .type = PieceType.L,
        .color = rl.Color.orange,
        .layout = [_][4][4]bool{
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, T, F, F },
                [_]bool{ F, T, F, F },
                [_]bool{ F, T, T, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, F, F, F },
                [_]bool{ T, T, T, F },
                [_]bool{ T, F, F, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ T, T, F, F },
                [_]bool{ F, T, F, F },
                [_]bool{ F, T, F, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, F, T, F },
                [_]bool{ T, T, T, F },
                [_]bool{ F, F, F, F },
            },
        },
    },
    Piece{
        .type = PieceType.O,
        .color = rl.Color.yellow,
        .layout = [_][4][4]bool{
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, F, F, F },
                [_]bool{ T, T, F, F },
                [_]bool{ T, T, F, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, F, F, F },
                [_]bool{ T, T, F, F },
                [_]bool{ T, T, F, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, F, F, F },
                [_]bool{ T, T, F, F },
                [_]bool{ T, T, F, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, F, F, F },
                [_]bool{ T, T, F, F },
                [_]bool{ T, T, F, F },
            },
        },
    },
    Piece{
        .type = PieceType.S,
        .color = rl.Color.green,
        .layout = [_][4][4]bool{
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, F, F, F },
                [_]bool{ F, T, T, F },
                [_]bool{ T, T, F, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ T, F, F, F },
                [_]bool{ T, T, F, F },
                [_]bool{ F, T, F, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, F, F, F },
                [_]bool{ F, T, T, F },
                [_]bool{ T, T, F, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ T, F, F, F },
                [_]bool{ T, T, F, F },
                [_]bool{ F, T, F, F },
            },
        },
    },
    Piece{
        .type = PieceType.T,
        .color = rl.Color.purple,
        .layout = [_][4][4]bool{
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, F, F, F },
                [_]bool{ T, T, T, F },
                [_]bool{ F, T, F, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, T, F, F },
                [_]bool{ T, T, F, F },
                [_]bool{ F, T, F, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, T, F, F },
                [_]bool{ T, T, T, F },
                [_]bool{ F, F, F, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, T, F, F },
                [_]bool{ F, T, T, F },
                [_]bool{ F, T, F, F },
            },
        },
    },
    Piece{
        .type = PieceType.Z,
        .color = rl.Color.red,
        .layout = [_][4][4]bool{
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, F, F, F },
                [_]bool{ T, T, F, F },
                [_]bool{ F, T, T, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, F, T, F },
                [_]bool{ F, T, T, F },
                [_]bool{ F, T, F, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, F, F, F },
                [_]bool{ T, T, F, F },
                [_]bool{ F, T, T, F },
            },
            [_][4]bool{
                [_]bool{ F, F, F, F },
                [_]bool{ F, F, T, F },
                [_]bool{ F, T, T, F },
                [_]bool{ F, T, F, F },
            },
        },
    },
};

pub fn GetRandomPiece() Piece {
    const RndGen = std.rand.DefaultPrng;
    var rnd = RndGen.init(0);
    const idx = rnd.random().int(usize) % pieces.len;
    return pieces[idx];
}
