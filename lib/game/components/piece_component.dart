import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:stellar_blocks/game/components/board_component.dart';
import 'package:stellar_blocks/game/controller/game_controller.dart';
import 'package:stellar_blocks/game/models/block_piece.dart';
import 'package:stellar_blocks/game/models/grid_point.dart';
import 'package:stellar_blocks/game/models/game_board.dart';
import 'package:stellar_blocks/ui/design_tokens.dart';

class PieceComponent extends PositionComponent with DragCallbacks {
  final BlockPiece piece;
  final GameController controller;
  final BoardComponent board;
  final double cellSize;

  late Vector2 _homePosition;

  PieceComponent({
    required this.piece,
    required this.controller,
    required this.board,
    required this.cellSize,
    required Vector2 position,
  }) : super(position: position, size: _computeSize(piece, cellSize));

  static Vector2 _computeSize(BlockPiece piece, double cellSize) {
    int maxX = 0, maxY = 0;
    for (final c in piece.cells) {
      if (c.x > maxX) maxX = c.x;
      if (c.y > maxY) maxY = c.y;
    }
    return Vector2((maxX + 1) * cellSize, (maxY + 1) * cellSize);
  }

  @override
  void onMount() {
    super.onMount();
    _homePosition = position.clone();
  }

  @override
  bool onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    priority = 10;
    return true;
  }

  @override
  bool onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position.add(event.localDelta);
    final boardLocal = board.absoluteToLocal(absoluteCenter);
    final gridPos = _computeDropPosition(boardLocal);
    board.showGhost(piece, gridPos);
    return true;
  }

  @override
  bool onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    priority = 0;
    board.hideGhost();

    final boardLocal = board.absoluteToLocal(absoluteCenter);
    if (board.isWithinBounds(boardLocal)) {
      final dropPos = _computeDropPosition(boardLocal);
      if (controller.board.canPlace(piece, dropPos)) {
        controller.placePieceOnBoard(piece, dropPos);
        removeFromParent();
        return true;
      }
    }
    position = _homePosition.clone();
    return true;
  }

  @override
  bool onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    priority = 0;
    board.hideGhost();
    position = _homePosition.clone();
    return true;
  }

  GridPoint _computeDropPosition(Vector2 boardLocalCenter) {
    final cellSz = board.cellSize;
    int maxX = 0, maxY = 0;
    for (final c in piece.cells) {
      if (c.x > maxX) maxX = c.x;
      if (c.y > maxY) maxY = c.y;
    }
    final halfW = (maxX + 1) / 2;
    final halfH = (maxY + 1) / 2;
    final topLeftX = boardLocalCenter.x - halfW * cellSz;
    final topLeftY = boardLocalCenter.y - halfH * cellSz;
    return GridPoint(
      (topLeftX / cellSz).round().clamp(0, GameBoard.size - 1),
      (topLeftY / cellSz).round().clamp(0, GameBoard.size - 1),
    );
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = AppColors.pieceColor(piece.color)
      ..style = PaintingStyle.fill;

    for (final c in piece.cells) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            c.x * cellSize + 1,
            c.y * cellSize + 1,
            cellSize - 2,
            cellSize - 2,
          ),
          const Radius.circular(3),
        ),
        paint,
      );
    }
  }
}
