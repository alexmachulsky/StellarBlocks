import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:stellar_blocks/game/components/board_component.dart';
import 'package:stellar_blocks/game/components/piece_component.dart';
import 'package:stellar_blocks/game/controller/game_controller.dart';
import 'package:stellar_blocks/ui/design_tokens.dart';

class RackComponent extends PositionComponent {
  final GameController controller;
  final BoardComponent board;

  static const int _slots = 3;
  static const double _slotPadding = AppSpacing.sm;

  RackComponent({
    required this.controller,
    required this.board,
    required Vector2 position,
    required Vector2 rackSize,
  }) : super(position: position, size: rackSize);

  double get _slotWidth => (size.x - (_slots + 1) * _slotPadding) / _slots;

  double get _pieceCellSize => _slotWidth / 3;

  void _rebuildPieces() {
    removeAll(children.whereType<PieceComponent>().toList());
    final pieces = controller.rack;
    for (int i = 0; i < pieces.length; i++) {
      final piece = pieces[i];
      final slotX = _slotPadding + i * (_slotWidth + _slotPadding);
      add(PieceComponent(
        piece: piece,
        controller: controller,
        board: board,
        cellSize: _pieceCellSize,
        position: Vector2(slotX, _slotPadding),
      ));
    }
  }

  @override
  void onMount() {
    super.onMount();
    _rebuildPieces();
    controller.addListener(_onControllerUpdate);
  }

  @override
  void onRemove() {
    controller.removeListener(_onControllerUpdate);
    super.onRemove();
  }

  void _onControllerUpdate() {
    _rebuildPieces();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)),
      Paint()..color = AppColors.surface,
    );
  }
}
