import 'package:flutter/material.dart';
import 'package:stellar_blocks/game/logic/piece_generator.dart';
import 'package:stellar_blocks/game/logic/seeded_rng.dart';
import 'package:stellar_blocks/game/models/block_piece.dart';
import 'package:stellar_blocks/game/models/game_board.dart';
import 'package:stellar_blocks/game/models/grid_point.dart';
import 'package:stellar_blocks/ui/design_tokens.dart';

class _UndoRecord {
  final GameBoard board;
  final List<BlockPiece> rack;
  final int score;
  final List<List<Color?>> colorGrid;
  const _UndoRecord({
    required this.board,
    required this.rack,
    required this.score,
    required this.colorGrid,
  });
}

class GameController extends ChangeNotifier {
  final SeededRng _rng;
  late PieceGenerator _generator;
  late GameBoard _board;
  late List<BlockPiece> _rack;
  late List<List<Color?>> _colorGrid;
  int _score = 0;
  bool _isGameOver = false;
  final List<_UndoRecord> _undoStack = [];

  GameController({required SeededRng rng}) : _rng = rng {
    newGame();
  }

  GameBoard get board => _board;
  List<BlockPiece> get rack => List.unmodifiable(_rack);
  int get score => _score;
  bool get isGameOver => _isGameOver;
  bool get canUndo => _undoStack.isNotEmpty;

  Color? colorAt(int x, int y) => _colorGrid[y][x];

  void newGame() {
    _generator = PieceGenerator(_rng);
    _board = GameBoard.empty();
    _colorGrid = List.generate(
      GameBoard.size,
      (_) => List.filled(GameBoard.size, null),
    );
    _rack = _generator.nextRack();
    _score = 0;
    _isGameOver = false;
    _undoStack.clear();
    notifyListeners();
  }

  void placePieceOnBoard(BlockPiece piece, GridPoint position) {
    if (!_board.canPlace(piece, position)) {
      throw StateError('Cannot place piece ${piece.id} at $position');
    }

    _undoStack.add(_UndoRecord(
      board: _board.snapshot(),
      rack: List.of(_rack),
      score: _score,
      colorGrid: _copyColorGrid(),
    ));

    final result = _board.place(piece, position);
    _board = result.board;

    final pieceColor = AppColors.pieceColor(piece.color);
    for (final offset in piece.cells) {
      final x = position.x + offset.x;
      final y = position.y + offset.y;
      _colorGrid[y][x] = pieceColor;
    }

    for (final y in result.clearResult.clearedRows) {
      for (int x = 0; x < GameBoard.size; x++) {
        _colorGrid[y][x] = null;
      }
    }
    for (final x in result.clearResult.clearedCols) {
      for (int y = 0; y < GameBoard.size; y++) {
        _colorGrid[y][x] = null;
      }
    }

    _score += piece.cells.length;
    final lines = result.clearResult.linesCleared;
    if (lines > 0) _score += 50 * lines * lines;

    _rack = _rack.where((p) => p.id != piece.id).toList();
    if (_rack.isEmpty) _rack = _generator.nextRack();

    _isGameOver = !_board.hasValidMove(_rack);
    notifyListeners();
  }

  void undo() {
    if (_undoStack.isEmpty) return;
    final record = _undoStack.removeLast();
    _board = record.board;
    _rack = List.of(record.rack);
    _score = record.score;
    _colorGrid =
        List.generate(GameBoard.size, (y) => List.of(record.colorGrid[y]));
    _isGameOver = false;
    notifyListeners();
  }

  List<List<Color?>> _copyColorGrid() {
    return List.generate(
      GameBoard.size,
      (y) => List.of(_colorGrid[y]),
    );
  }
}
