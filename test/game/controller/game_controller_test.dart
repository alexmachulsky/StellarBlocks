import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_blocks/game/controller/game_controller.dart';
import 'package:stellar_blocks/game/logic/piece_shapes.dart';
import 'package:stellar_blocks/game/logic/seeded_rng.dart';
import 'package:stellar_blocks/game/models/block_piece.dart';
import 'package:stellar_blocks/game/models/grid_point.dart';

BlockPiece _singlePiece(String id, PieceColor color) =>
    BlockPiece(id: id, color: color, cells: PieceShapes.all[0]); // 1×1 dot

void main() {
  group('GameController', () {
    late GameController ctrl;

    setUp(() {
      ctrl = GameController(rng: SeededRng(42));
    });

    test('newGame resets board and score', () {
      ctrl.newGame();
      expect(ctrl.score, 0);
      expect(ctrl.isGameOver, false);
      expect(ctrl.rack.length, 3);
    });

    test('placePieceOnBoard updates board state', () {
      final piece = _singlePiece('p0', PieceColor.red);
      const pos = GridPoint(0, 0);
      ctrl.placePieceOnBoard(piece, pos);
      expect(ctrl.board, isNotNull);
    });

    test('score increases after placement', () {
      final piece = _singlePiece('p0', PieceColor.blue);
      final before = ctrl.score;
      ctrl.placePieceOnBoard(piece, const GridPoint(3, 3));
      expect(ctrl.score, greaterThan(before));
    });

    test('undo restores previous score', () {
      final piece = _singlePiece('p0', PieceColor.green);
      const pos = GridPoint(2, 2);
      ctrl.placePieceOnBoard(piece, pos);
      final scoreAfter = ctrl.score;
      ctrl.undo();
      expect(ctrl.score, lessThan(scoreAfter));
      expect(ctrl.canUndo, false);
    });

    test('notifyListeners called after placePiece', () {
      int callCount = 0;
      ctrl.addListener(() => callCount++);
      ctrl.placePieceOnBoard(
        _singlePiece('p0', PieceColor.cyan),
        const GridPoint(0, 0),
      );
      expect(callCount, greaterThan(0));
    });

    test('newGame notifies listeners', () {
      int callCount = 0;
      ctrl.addListener(() => callCount++);
      ctrl.newGame();
      expect(callCount, greaterThan(0));
    });
  });
}
