import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_blocks/game/models/grid_point.dart';
import 'package:stellar_blocks/game/models/block_piece.dart';

void main() {
  group('PieceColor', () {
    test('enum has exactly 7 values', () {
      expect(PieceColor.values.length, equals(7));
    });

    test('all 7 named values exist', () {
      expect(PieceColor.red, isNotNull);
      expect(PieceColor.blue, isNotNull);
      expect(PieceColor.green, isNotNull);
      expect(PieceColor.yellow, isNotNull);
      expect(PieceColor.purple, isNotNull);
      expect(PieceColor.orange, isNotNull);
      expect(PieceColor.cyan, isNotNull);
    });
  });

  group('BlockPiece', () {
    test('construction returns correct field values', () {
      const cells = [GridPoint(0, 0)];
      const piece = BlockPiece(
        id: 's1',
        color: PieceColor.red,
        cells: cells,
      );

      expect(piece.id, equals('s1'));
      expect(piece.color, equals(PieceColor.red));
      expect(piece.cells.length, equals(1));
      expect(piece.cells[0], equals(const GridPoint(0, 0)));
    });

    test('multi-cell piece has correct cell positions', () {
      const cells = [
        GridPoint(0, 0),
        GridPoint(1, 0),
        GridPoint(1, 1),
      ];
      const piece = BlockPiece(
        id: 'l1',
        color: PieceColor.blue,
        cells: cells,
      );

      expect(piece.cells.length, equals(3));
      expect(piece.cells[0], equals(const GridPoint(0, 0)));
      expect(piece.cells[1], equals(const GridPoint(1, 0)));
      expect(piece.cells[2], equals(const GridPoint(1, 1)));
    });

    test('const construction works with const list', () {
      const piece = BlockPiece(
        id: 'const1',
        color: PieceColor.green,
        cells: [
          GridPoint(0, 0),
          GridPoint(1, 0),
        ],
      );

      expect(piece.id, equals('const1'));
      expect(piece.color, equals(PieceColor.green));
      expect(piece.cells.length, equals(2));
    });

    test('different pieces with different ids are distinct', () {
      const cells = [GridPoint(0, 0)];
      const piece1 = BlockPiece(
        id: 'piece1',
        color: PieceColor.red,
        cells: cells,
      );
      const piece2 = BlockPiece(
        id: 'piece2',
        color: PieceColor.red,
        cells: cells,
      );

      expect(piece1.id, isNot(equals(piece2.id)));
      expect(identical(piece1, piece2), isFalse);
    });

    test('cells list has correct length for complex shape', () {
      const cells = [
        GridPoint(0, 0),
        GridPoint(1, 0),
        GridPoint(2, 0),
        GridPoint(2, 1),
      ];
      const piece = BlockPiece(
        id: 'complex',
        color: PieceColor.yellow,
        cells: cells,
      );

      expect(piece.cells.length, equals(4));
    });
  });
}
