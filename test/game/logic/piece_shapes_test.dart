import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_blocks/game/logic/piece_shapes.dart';
import 'package:stellar_blocks/game/models/grid_point.dart';

void main() {
  group('PieceShapes', () {
    test('all contains exactly 19 shapes', () {
      expect(PieceShapes.all.length, equals(19));
    });

    test('every shape in all is non-empty', () {
      for (final shape in PieceShapes.all) {
        expect(shape.isNotEmpty, isTrue, reason: 'Shape should not be empty');
      }
    });

    test('no shape has duplicate cells', () {
      for (final shape in PieceShapes.all) {
        final uniqueCells = shape.toSet();
        expect(uniqueCells.length, equals(shape.length),
            reason: 'Shape has duplicate cells');
      }
    });

    test('all cells in all shapes have non-negative coordinates', () {
      for (final shape in PieceShapes.all) {
        for (final cell in shape) {
          expect(cell.x, greaterThanOrEqualTo(0),
              reason: 'Cell x coordinate must be non-negative');
          expect(cell.y, greaterThanOrEqualTo(0),
              reason: 'Cell y coordinate must be non-negative');
        }
      }
    });

    test('single has exactly 1 cell at (0,0)', () {
      expect(PieceShapes.single.length, equals(1));
      expect(PieceShapes.single[0], equals(const GridPoint(0, 0)));
    });

    test('h2 is horizontal domino', () {
      expect(PieceShapes.h2.length, equals(2));
      expect(
        PieceShapes.h2,
        containsAll([const GridPoint(0, 0), const GridPoint(1, 0)]),
      );
    });

    test('v2 is vertical domino', () {
      expect(PieceShapes.v2.length, equals(2));
      expect(
        PieceShapes.v2,
        containsAll([const GridPoint(0, 0), const GridPoint(0, 1)]),
      );
    });

    test('h3 is horizontal tromino with 3 cells on y=0', () {
      expect(PieceShapes.h3.length, equals(3));
      expect(
        PieceShapes.h3,
        containsAll([
          const GridPoint(0, 0),
          const GridPoint(1, 0),
          const GridPoint(2, 0),
        ]),
      );
      // All cells should be on y=0
      for (final cell in PieceShapes.h3) {
        expect(cell.y, equals(0));
      }
    });

    test('v3 is vertical tromino with 3 cells on x=0', () {
      expect(PieceShapes.v3.length, equals(3));
      expect(
        PieceShapes.v3,
        containsAll([
          const GridPoint(0, 0),
          const GridPoint(0, 1),
          const GridPoint(0, 2),
        ]),
      );
      // All cells should be on x=0
      for (final cell in PieceShapes.v3) {
        expect(cell.x, equals(0));
      }
    });

    test('cornerNE forms an L with cells at (0,0), (1,0), (1,1)', () {
      expect(
        PieceShapes.cornerNE,
        containsAll([
          const GridPoint(0, 0),
          const GridPoint(1, 0),
          const GridPoint(1, 1),
        ]),
      );
    });

    test('cornerNW forms an L with cells at (0,0), (1,0), (0,1)', () {
      expect(
        PieceShapes.cornerNW,
        containsAll([
          const GridPoint(0, 0),
          const GridPoint(1, 0),
          const GridPoint(0, 1),
        ]),
      );
    });

    test('cornerSE forms an L with cells at (0,0), (0,1), (1,1)', () {
      expect(
        PieceShapes.cornerSE,
        containsAll([
          const GridPoint(0, 0),
          const GridPoint(0, 1),
          const GridPoint(1, 1),
        ]),
      );
    });

    test('cornerSW forms an L with cells at (1,0), (0,1), (1,1)', () {
      expect(
        PieceShapes.cornerSW,
        containsAll([
          const GridPoint(1, 0),
          const GridPoint(0, 1),
          const GridPoint(1, 1),
        ]),
      );
    });

    test('h4 is horizontal tetromino with 4 cells on y=0', () {
      expect(PieceShapes.h4.length, equals(4));
      expect(
        PieceShapes.h4,
        containsAll([
          const GridPoint(0, 0),
          const GridPoint(1, 0),
          const GridPoint(2, 0),
          const GridPoint(3, 0),
        ]),
      );
      // All cells should be on y=0
      for (final cell in PieceShapes.h4) {
        expect(cell.y, equals(0));
      }
    });

    test('v4 is vertical tetromino with 4 cells on x=0', () {
      expect(PieceShapes.v4.length, equals(4));
      expect(
        PieceShapes.v4,
        containsAll([
          const GridPoint(0, 0),
          const GridPoint(0, 1),
          const GridPoint(0, 2),
          const GridPoint(0, 3),
        ]),
      );
      // All cells should be on x=0
      for (final cell in PieceShapes.v4) {
        expect(cell.x, equals(0));
      }
    });

    test('sq2 is a 2x2 square with exactly 4 cells', () {
      expect(PieceShapes.sq2.length, equals(4));
      expect(
        PieceShapes.sq2,
        containsAll([
          const GridPoint(0, 0),
          const GridPoint(1, 0),
          const GridPoint(0, 1),
          const GridPoint(1, 1),
        ]),
      );
    });

    test('lNE is big L with vertical bar and right foot', () {
      expect(PieceShapes.lNE.length, equals(4));
      expect(
        PieceShapes.lNE,
        containsAll([
          const GridPoint(0, 0),
          const GridPoint(0, 1),
          const GridPoint(0, 2),
          const GridPoint(1, 2),
        ]),
      );
    });

    test('lNW is big L with vertical bar and left foot', () {
      expect(PieceShapes.lNW.length, equals(4));
      expect(
        PieceShapes.lNW,
        containsAll([
          const GridPoint(1, 0),
          const GridPoint(1, 1),
          const GridPoint(0, 2),
          const GridPoint(1, 2),
        ]),
      );
    });

    test('lSE is big L with horizontal bar and stem down', () {
      expect(PieceShapes.lSE.length, equals(4));
      expect(
        PieceShapes.lSE,
        containsAll([
          const GridPoint(0, 0),
          const GridPoint(1, 0),
          const GridPoint(0, 1),
          const GridPoint(0, 2),
        ]),
      );
    });

    test('lSW is big L with horizontal bar and stem down-right', () {
      expect(PieceShapes.lSW.length, equals(4));
      expect(
        PieceShapes.lSW,
        containsAll([
          const GridPoint(0, 0),
          const GridPoint(1, 0),
          const GridPoint(1, 1),
          const GridPoint(1, 2),
        ]),
      );
    });

    test('h5 is horizontal pentomino with 5 cells on y=0, x in [0,4]', () {
      expect(PieceShapes.h5.length, equals(5));
      expect(
        PieceShapes.h5,
        containsAll([
          const GridPoint(0, 0),
          const GridPoint(1, 0),
          const GridPoint(2, 0),
          const GridPoint(3, 0),
          const GridPoint(4, 0),
        ]),
      );
      // All cells should be on y=0
      for (final cell in PieceShapes.h5) {
        expect(cell.y, equals(0));
      }
    });

    test('v5 is vertical pentomino with 5 cells on x=0, y in [0,4]', () {
      expect(PieceShapes.v5.length, equals(5));
      expect(
        PieceShapes.v5,
        containsAll([
          const GridPoint(0, 0),
          const GridPoint(0, 1),
          const GridPoint(0, 2),
          const GridPoint(0, 3),
          const GridPoint(0, 4),
        ]),
      );
      // All cells should be on x=0
      for (final cell in PieceShapes.v5) {
        expect(cell.x, equals(0));
      }
    });

    test('sq3 is a 3x3 square with exactly 9 cells', () {
      expect(PieceShapes.sq3.length, equals(9));
      // All 9 cells of a 3x3 grid
      const expected = [
        GridPoint(0, 0),
        GridPoint(1, 0),
        GridPoint(2, 0),
        GridPoint(0, 1),
        GridPoint(1, 1),
        GridPoint(2, 1),
        GridPoint(0, 2),
        GridPoint(1, 2),
        GridPoint(2, 2),
      ];
      expect(PieceShapes.sq3, containsAll(expected));
    });

    test('all named shapes are contained in PieceShapes.all', () {
      final allShapes = [
        PieceShapes.single,
        PieceShapes.h2,
        PieceShapes.v2,
        PieceShapes.h3,
        PieceShapes.v3,
        PieceShapes.cornerNE,
        PieceShapes.cornerNW,
        PieceShapes.cornerSE,
        PieceShapes.cornerSW,
        PieceShapes.h4,
        PieceShapes.v4,
        PieceShapes.sq2,
        PieceShapes.lNE,
        PieceShapes.lNW,
        PieceShapes.lSE,
        PieceShapes.lSW,
        PieceShapes.h5,
        PieceShapes.v5,
        PieceShapes.sq3,
      ];

      for (final shape in allShapes) {
        expect(
          PieceShapes.all,
          contains(shape),
          reason: 'Shape should be in PieceShapes.all',
        );
      }
    });

    test('all shapes are identical to their named counterparts', () {
      expect(PieceShapes.all[0], equals(PieceShapes.single));
      expect(PieceShapes.all[1], equals(PieceShapes.h2));
      expect(PieceShapes.all[2], equals(PieceShapes.v2));
      expect(PieceShapes.all[3], equals(PieceShapes.h3));
      expect(PieceShapes.all[4], equals(PieceShapes.v3));
      expect(PieceShapes.all[5], equals(PieceShapes.cornerNE));
      expect(PieceShapes.all[6], equals(PieceShapes.cornerNW));
      expect(PieceShapes.all[7], equals(PieceShapes.cornerSE));
      expect(PieceShapes.all[8], equals(PieceShapes.cornerSW));
      expect(PieceShapes.all[9], equals(PieceShapes.h4));
      expect(PieceShapes.all[10], equals(PieceShapes.v4));
      expect(PieceShapes.all[11], equals(PieceShapes.sq2));
      expect(PieceShapes.all[12], equals(PieceShapes.lNE));
      expect(PieceShapes.all[13], equals(PieceShapes.lNW));
      expect(PieceShapes.all[14], equals(PieceShapes.lSE));
      expect(PieceShapes.all[15], equals(PieceShapes.lSW));
      expect(PieceShapes.all[16], equals(PieceShapes.h5));
      expect(PieceShapes.all[17], equals(PieceShapes.v5));
      expect(PieceShapes.all[18], equals(PieceShapes.sq3));
    });
  });
}
