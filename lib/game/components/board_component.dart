import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:stellar_blocks/game/controller/game_controller.dart';
import 'package:stellar_blocks/game/models/block_piece.dart';
import 'package:stellar_blocks/game/models/grid_point.dart';
import 'package:stellar_blocks/game/models/game_board.dart';
import 'package:stellar_blocks/ui/design_tokens.dart';

class BoardComponent extends PositionComponent {
  final GameController controller;
  static const int _size = GameBoard.size;

  BlockPiece? _ghostPiece;
  GridPoint? _ghostPosition;
  bool _ghostValid = false;

  BoardComponent({required this.controller, required Vector2 boardSize})
      : super(size: boardSize);

  double get cellSize => size.x / _size;

  GridPoint gridPointFor(Vector2 localPosition) {
    final x = (localPosition.x / cellSize).floor().clamp(0, _size - 1);
    final y = (localPosition.y / cellSize).floor().clamp(0, _size - 1);
    return GridPoint(x, y);
  }

  bool isWithinBounds(Vector2 localPosition) {
    return localPosition.x >= 0 &&
        localPosition.y >= 0 &&
        localPosition.x < size.x &&
        localPosition.y < size.y;
  }

  void showGhost(BlockPiece piece, GridPoint position) {
    _ghostPiece = piece;
    _ghostPosition = position;
    _ghostValid = controller.board.canPlace(piece, position);
  }

  void hideGhost() {
    _ghostPiece = null;
    _ghostPosition = null;
    _ghostValid = false;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint();
    final cellSz = cellSize;

    paint.color = AppColors.surface;
    canvas.drawRect(size.toRect(), paint);

    for (int y = 0; y < _size; y++) {
      for (int x = 0; x < _size; x++) {
        final color = controller.colorAt(x, y);
        if (color != null) {
          paint
            ..color = color
            ..style = PaintingStyle.fill;
          canvas.drawRect(
            Rect.fromLTWH(
              x * cellSz + 1,
              y * cellSz + 1,
              cellSz - 2,
              cellSz - 2,
            ),
            paint,
          );
        } else {
          paint
            ..color = const Color(0xFF1E2540)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5;
          canvas.drawRect(
            Rect.fromLTWH(x * cellSz, y * cellSz, cellSz, cellSz),
            paint,
          );
          paint.style = PaintingStyle.fill;
        }
      }
    }

    if (_ghostPiece != null && _ghostPosition != null) {
      final ghostColor = _ghostValid
          ? AppColors.pieceColor(_ghostPiece!.color).withValues(alpha: 0.4)
          : Colors.red.withValues(alpha: 0.3);
      paint
        ..color = ghostColor
        ..style = PaintingStyle.fill;
      for (final offset in _ghostPiece!.cells) {
        final gx = _ghostPosition!.x + offset.x;
        final gy = _ghostPosition!.y + offset.y;
        if (gx >= 0 && gx < _size && gy >= 0 && gy < _size) {
          canvas.drawRect(
            Rect.fromLTWH(
              gx * cellSz + 1,
              gy * cellSz + 1,
              cellSz - 2,
              cellSz - 2,
            ),
            paint,
          );
        }
      }
    }
  }
}
