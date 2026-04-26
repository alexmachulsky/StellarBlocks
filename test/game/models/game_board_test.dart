import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_blocks/game/models/block_piece.dart';
import 'package:stellar_blocks/game/models/game_board.dart';
import 'package:stellar_blocks/game/models/grid_point.dart';

void main() {
  // Helper: a 1-cell piece for simple placement tests
  const singlePiece = BlockPiece(
    id: 'single',
    color: PieceColor.red,
    cells: [GridPoint(0, 0)],
  );

  // Helper: a 1×8 horizontal bar to fill a row
  const hBar = BlockPiece(
    id: 'hbar',
    color: PieceColor.blue,
    cells: [
      GridPoint(0, 0),
      GridPoint(1, 0),
      GridPoint(2, 0),
      GridPoint(3, 0),
      GridPoint(4, 0),
      GridPoint(5, 0),
      GridPoint(6, 0),
      GridPoint(7, 0),
    ],
  );

  // Helper: a 1×8 vertical bar to fill a column
  const vBar = BlockPiece(
    id: 'vbar',
    color: PieceColor.green,
    cells: [
      GridPoint(0, 0),
      GridPoint(0, 1),
      GridPoint(0, 2),
      GridPoint(0, 3),
      GridPoint(0, 4),
      GridPoint(0, 5),
      GridPoint(0, 6),
      GridPoint(0, 7),
    ],
  );

  // Helper: a 2-cell horizontal piece
  const hPair = BlockPiece(
    id: 'hpair',
    color: PieceColor.blue,
    cells: [
      GridPoint(0, 0),
      GridPoint(1, 0),
    ],
  );

  group('ClearResult', () {
    test('linesCleared returns sum of cleared rows and cols', () {
      const result =
          ClearResult(clearedRows: [0, 1], clearedCols: [2, 3, 4]);
      expect(result.linesCleared, equals(5));
    });

    test('linesCleared is 0 when no clears', () {
      const result = ClearResult(clearedRows: [], clearedCols: []);
      expect(result.linesCleared, equals(0));
    });

    test('hasClears is true when rows are cleared', () {
      const result = ClearResult(clearedRows: [0], clearedCols: []);
      expect(result.hasClears, isTrue);
    });

    test('hasClears is true when cols are cleared', () {
      const result = ClearResult(clearedRows: [], clearedCols: [1]);
      expect(result.hasClears, isTrue);
    });

    test('hasClears is true when both rows and cols are cleared', () {
      const result = ClearResult(clearedRows: [0], clearedCols: [1]);
      expect(result.hasClears, isTrue);
    });

    test('hasClears is false when neither rows nor cols are cleared', () {
      const result = ClearResult(clearedRows: [], clearedCols: []);
      expect(result.hasClears, isFalse);
    });

    test('ClearResult equality', () {
      const result1 = ClearResult(clearedRows: [0, 1], clearedCols: [2]);
      const result2 = ClearResult(clearedRows: [0, 1], clearedCols: [2]);
      expect(result1, equals(result2));
    });

    test('ClearResult inequality', () {
      const result1 = ClearResult(clearedRows: [0], clearedCols: []);
      const result2 = ClearResult(clearedRows: [1], clearedCols: []);
      expect(result1, isNot(equals(result2)));
    });
  });

  group('GameBoard', () {
    group('construction', () {
      test('GameBoard.empty() creates 8x8 unoccupied board', () {
        final board = GameBoard.empty();
        for (int y = 0; y < 8; y++) {
          for (int x = 0; x < 8; x++) {
            expect(board.isOccupied(x, y), isFalse);
          }
        }
      });

      test('isOccupied returns false for every cell on empty board', () {
        final board = GameBoard.empty();
        expect(board.isOccupied(0, 0), isFalse);
        expect(board.isOccupied(7, 7), isFalse);
        expect(board.isOccupied(3, 4), isFalse);
      });

      test('isOccupied throws RangeError for out-of-bounds coordinates', () {
        final board = GameBoard.empty();
        expect(() => board.isOccupied(-1, 0), throwsRangeError);
        expect(() => board.isOccupied(0, -1), throwsRangeError);
        expect(() => board.isOccupied(8, 0), throwsRangeError);
        expect(() => board.isOccupied(0, 8), throwsRangeError);
      });
    });

    group('canPlace', () {
      test('can place single cell at (0,0) on empty board', () {
        final board = GameBoard.empty();
        expect(board.canPlace(singlePiece, const GridPoint(0, 0)), isTrue);
      });

      test('can place single cell at (7,7) on empty board (corner)', () {
        final board = GameBoard.empty();
        expect(board.canPlace(singlePiece, const GridPoint(7, 7)), isTrue);
      });

      test('cannot place single cell at (-1, 0) (out-of-bounds x)', () {
        final board = GameBoard.empty();
        expect(board.canPlace(singlePiece, const GridPoint(-1, 0)), isFalse);
      });

      test('cannot place single cell at (8, 0) (out-of-bounds x)', () {
        final board = GameBoard.empty();
        expect(board.canPlace(singlePiece, const GridPoint(8, 0)), isFalse);
      });

      test('cannot place single cell at (0, 8) (out-of-bounds y)', () {
        final board = GameBoard.empty();
        expect(board.canPlace(singlePiece, const GridPoint(0, 8)), isFalse);
      });

      test('cannot place at occupied cell', () {
        var board = GameBoard.empty();
        final result1 = board.place(singlePiece, const GridPoint(3, 3));
        board = result1.board;

        expect(board.canPlace(singlePiece, const GridPoint(3, 3)), isFalse);
      });

      test('cannot place 2-cell horizontal piece at (7,0)', () {
        final board = GameBoard.empty();
        expect(board.canPlace(hPair, const GridPoint(7, 0)), isFalse);
      });

      test('can place 2-cell horizontal piece at (6,0)', () {
        final board = GameBoard.empty();
        expect(board.canPlace(hPair, const GridPoint(6, 0)), isTrue);
      });
    });

    group('place', () {
      test('placing single cell at (2,2) makes isOccupied(2,2) true', () {
        final board = GameBoard.empty();
        final result = board.place(singlePiece, const GridPoint(2, 2));
        expect(result.board.isOccupied(2, 2), isTrue);
      });

      test('placing at occupied cell throws StateError', () {
        var board = GameBoard.empty();
        final result1 = board.place(singlePiece, const GridPoint(3, 3));
        board = result1.board;

        expect(
          () => board.place(singlePiece, const GridPoint(3, 3)),
          throwsStateError,
        );
      });

      test('row clear: fill row 0, clearedRows contains 0', () {
        var board = GameBoard.empty();
        final result = board.place(hBar, const GridPoint(0, 0));

        expect(result.clearResult.clearedRows, equals([0]));
        expect(result.clearResult.clearedCols, isEmpty);
      });

      test('row clear: after clearing, all cells in row 0 are unoccupied', () {
        var board = GameBoard.empty();
        final result = board.place(hBar, const GridPoint(0, 0));
        board = result.board;

        for (int x = 0; x < 8; x++) {
          expect(board.isOccupied(x, 0), isFalse);
        }
      });

      test('col clear: fill col 0, clearedCols contains 0', () {
        var board = GameBoard.empty();
        final result = board.place(vBar, const GridPoint(0, 0));

        expect(result.clearResult.clearedRows, isEmpty);
        expect(result.clearResult.clearedCols, equals([0]));
      });

      test('col clear: after clearing, all cells in col 0 are unoccupied', () {
        var board = GameBoard.empty();
        final result = board.place(vBar, const GridPoint(0, 0));
        board = result.board;

        for (int y = 0; y < 8; y++) {
          expect(board.isOccupied(0, y), isFalse);
        }
      });

      test(
          'simultaneous row+col clear: fill row 3 with 7, col 5 with 7, '
          'place at intersection (5,3)', () {
        var board = GameBoard.empty();

        // Fill row 3 with 7 cells (all except x=5)
        const row3 = BlockPiece(
          id: 'row3',
          color: PieceColor.red,
          cells: [
            GridPoint(0, 0),
            GridPoint(1, 0),
            GridPoint(2, 0),
            GridPoint(3, 0),
            GridPoint(4, 0),
            // skip x=5
            GridPoint(6, 0),
            GridPoint(7, 0),
          ],
        );
        var result = board.place(row3, const GridPoint(0, 3));
        board = result.board;

        // Fill col 5 with 7 cells (all except y=3)
        const col5 = BlockPiece(
          id: 'col5',
          color: PieceColor.blue,
          cells: [
            GridPoint(0, 0),
            GridPoint(0, 1),
            GridPoint(0, 2),
            // skip y=3
            GridPoint(0, 4),
            GridPoint(0, 5),
            GridPoint(0, 6),
            GridPoint(0, 7),
          ],
        );
        result = board.place(col5, const GridPoint(5, 0));
        board = result.board;

        // Place the final piece at the intersection
        result = board.place(singlePiece, const GridPoint(5, 3));

        expect(result.clearResult.clearedRows, equals([3]));
        expect(result.clearResult.clearedCols, equals([5]));
        expect(result.clearResult.linesCleared, equals(2));
      });

      test(
          'placing cell that does NOT complete row/col returns '
          'ClearResult with empty lists', () {
        final board = GameBoard.empty();
        final result = board.place(singlePiece, const GridPoint(2, 2));

        expect(result.clearResult.clearedRows, isEmpty);
        expect(result.clearResult.clearedCols, isEmpty);
        expect(result.clearResult.hasClears, isFalse);
      });

      test('original board is not modified by place', () {
        final originalBoard = GameBoard.empty();
        originalBoard.place(singlePiece, const GridPoint(3, 3));

        expect(originalBoard.isOccupied(3, 3), isFalse);
      });

      test('multiple placements return correct state', () {
        var board = GameBoard.empty();

        // Place first piece at (0, 0)
        var result = board.place(singlePiece, const GridPoint(0, 0));
        board = result.board;
        expect(board.isOccupied(0, 0), isTrue);

        // Place second piece at (1, 0)
        result = board.place(singlePiece, const GridPoint(1, 0));
        board = result.board;
        expect(board.isOccupied(1, 0), isTrue);
        expect(board.isOccupied(0, 0), isTrue);
      });
    });

    group('hasValidMove', () {
      test('on empty board, hasValidMove with single piece is true', () {
        final board = GameBoard.empty();
        expect(board.hasValidMove([singlePiece]), isTrue);
      });

      test(
          'game-over detection: 3-piece rack cannot fit on checkerboard board', () {
        var board = GameBoard.empty();

        // Checkerboard: occupy cells where (x + y) is even.
        // Each row/col gets 4 cells — no row or col ever completes, so no clears occur.
        // Every empty cell is surrounded by occupied cells on all 4 sides,
        // so no 2+ cell piece can fit.
        for (int y = 0; y < 8; y++) {
          for (int x = (y.isEven ? 0 : 1); x < 8; x += 2) {
            final result = board.place(singlePiece, GridPoint(x, y));
            board = result.board;
          }
        }

        // Rack of 3 pieces — all need 2+ adjacent empty cells to fit
        const h2 = BlockPiece(
          id: 'h2',
          color: PieceColor.red,
          cells: [GridPoint(0, 0), GridPoint(1, 0)],
        );
        const v2 = BlockPiece(
          id: 'v2',
          color: PieceColor.blue,
          cells: [GridPoint(0, 0), GridPoint(0, 1)],
        );
        const sq2Piece = BlockPiece(
          id: 'sq2p',
          color: PieceColor.green,
          cells: [
            GridPoint(0, 0), GridPoint(1, 0),
            GridPoint(0, 1), GridPoint(1, 1),
          ],
        );

        expect(board.hasValidMove([h2, v2, sq2Piece]), isFalse);
      });

      test('hasValidMove with multiple pieces returns true if any fits', () {
        var board = GameBoard.empty();

        // Place one piece at (0, 0)
        final result = board.place(singlePiece, const GridPoint(0, 0));
        board = result.board;

        // Check that at least some other position works
        expect(board.hasValidMove([singlePiece]), isTrue);
      });

      test('hasValidMove can find move at edge of board', () {
        var board = GameBoard.empty();

        // Fill most of the board, leaving (7, 7) available
        for (int y = 0; y < 7; y++) {
          for (int x = 0; x < 8; x++) {
            final result = board.place(singlePiece, GridPoint(x, y));
            board = result.board;
          }
        }
        for (int x = 0; x < 7; x++) {
          final result = board.place(singlePiece, GridPoint(x, 7));
          board = result.board;
        }

        expect(board.hasValidMove([singlePiece]), isTrue);
      });
    });

    group('immutability and snapshots', () {
      test('snapshot returns board equal in state', () {
        var board = GameBoard.empty();
        final result1 = board.place(singlePiece, const GridPoint(2, 2));
        board = result1.board;

        final snapshotBoard = board.snapshot();

        expect(snapshotBoard.isOccupied(2, 2), isTrue);
      });

      test('after placing more pieces on original, snapshot is unchanged', () {
        var board = GameBoard.empty();
        final result1 = board.place(singlePiece, const GridPoint(2, 2));
        board = result1.board;

        final snapshot = board.snapshot();

        final result2 = board.place(singlePiece, const GridPoint(3, 3));
        board = result2.board;

        // Snapshot should not have (3, 3) occupied
        expect(snapshot.isOccupied(3, 3), isFalse);
        expect(snapshot.isOccupied(2, 2), isTrue);
      });

      test('two empty boards are independent', () {
        final board1 = GameBoard.empty();
        final board2 = GameBoard.empty();

        final result = board1.place(singlePiece, const GridPoint(0, 0));

        expect(result.board.isOccupied(0, 0), isTrue);
        expect(board2.isOccupied(0, 0), isFalse);
      });

      test('snapshot is fully independent copy', () {
        var board = GameBoard.empty();
        final result1 = board.place(singlePiece, const GridPoint(0, 0));
        board = result1.board;

        final snapshot = board.snapshot();

        final result2 = board.place(singlePiece, const GridPoint(1, 1));
        result2.board.place(singlePiece, const GridPoint(2, 2));

        expect(snapshot.isOccupied(0, 0), isTrue);
        expect(snapshot.isOccupied(1, 1), isFalse);
        expect(snapshot.isOccupied(2, 2), isFalse);
      });
    });

    group('edge cases and complex scenarios', () {
      test('simultaneous multi-row clear when one piece completes two rows', () {
        var board = GameBoard.empty();

        // Fill row 0 and row 1 each with 7 cells, leaving x=4 empty in both
        const partialRow = BlockPiece(
          id: 'prow',
          color: PieceColor.red,
          cells: [
            GridPoint(0, 0), GridPoint(1, 0), GridPoint(2, 0), GridPoint(3, 0),
            GridPoint(5, 0), GridPoint(6, 0), GridPoint(7, 0),
          ],
        );
        var result = board.place(partialRow, const GridPoint(0, 0)); // fills row 0 except x=4
        board = result.board;
        result = board.place(partialRow, const GridPoint(0, 1)); // fills row 1 except x=4
        board = result.board;

        // Place a vertical 2-cell piece at (4,0) — fills (4,0) and (4,1) simultaneously,
        // completing row 0 and row 1 in a single place() call
        const vPair = BlockPiece(
          id: 'vpair',
          color: PieceColor.green,
          cells: [GridPoint(0, 0), GridPoint(0, 1)],
        );
        result = board.place(vPair, const GridPoint(4, 0));

        expect(result.clearResult.clearedRows, equals([0, 1]));
        expect(result.clearResult.linesCleared, equals(2));
      });

      test('simultaneous multi-col clear when one piece completes two cols', () {
        var board = GameBoard.empty();

        // Fill col 0 and col 1 each with 7 cells, leaving row 4 empty in both
        const partialCol = BlockPiece(
          id: 'pcol',
          color: PieceColor.red,
          cells: [
            GridPoint(0, 0), GridPoint(0, 1), GridPoint(0, 2), GridPoint(0, 3),
            GridPoint(0, 5), GridPoint(0, 6), GridPoint(0, 7),
          ],
        );
        var result = board.place(partialCol, const GridPoint(0, 0)); // fills col 0 except row 4
        board = result.board;
        result = board.place(partialCol, const GridPoint(1, 0)); // fills col 1 except row 4
        board = result.board;

        // Place a horizontal 2-cell piece at (0,4) — fills (0,4) and (1,4) simultaneously,
        // completing col 0 and col 1 in a single place() call
        const hPairPiece = BlockPiece(
          id: 'hpair2',
          color: PieceColor.green,
          cells: [GridPoint(0, 0), GridPoint(1, 0)],
        );
        result = board.place(hPairPiece, const GridPoint(0, 4));

        expect(result.clearResult.clearedCols, equals([0, 1]));
        expect(result.clearResult.linesCleared, equals(2));
      });

      test('placing piece does not clear non-full lines', () {
        var board = GameBoard.empty();

        // Place 7 cells in row 0 (leaving x=7 empty)
        const partialRow = BlockPiece(
          id: 'partial',
          color: PieceColor.red,
          cells: [
            GridPoint(0, 0),
            GridPoint(1, 0),
            GridPoint(2, 0),
            GridPoint(3, 0),
            GridPoint(4, 0),
            GridPoint(5, 0),
            GridPoint(6, 0),
          ],
        );
        var result = board.place(partialRow, const GridPoint(0, 0));
        board = result.board;

        // Verify row 0 is not cleared and still has 7 pieces
        expect(result.clearResult.clearedRows, isEmpty);
        int count = 0;
        for (int x = 0; x < 8; x++) {
          if (board.isOccupied(x, 0)) count++;
        }
        expect(count, equals(7));
      });

      test('GameBoard.size constant is 8', () {
        expect(GameBoard.size, equals(8));
      });
    });

    group('equality and hashing', () {
      test('two empty boards are equal', () {
        final board1 = GameBoard.empty();
        final board2 = GameBoard.empty();
        expect(board1, equals(board2));
      });

      test('board with piece at (2,2) is not equal to empty board', () {
        var board1 = GameBoard.empty();
        final result = board1.place(singlePiece, const GridPoint(2, 2));
        board1 = result.board;

        final board2 = GameBoard.empty();

        expect(board1, isNot(equals(board2)));
      });

      test('identical boards have identical hash codes', () {
        final board1 = GameBoard.empty();
        final board2 = GameBoard.empty();
        expect(board1.hashCode, equals(board2.hashCode));
      });
    });
  });
}
