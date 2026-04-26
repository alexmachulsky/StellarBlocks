import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:stellar_blocks/game/components/board_component.dart';
import 'package:stellar_blocks/game/components/rack_component.dart';
import 'package:stellar_blocks/game/components/star_burst_effect.dart';
import 'package:stellar_blocks/game/controller/game_controller.dart';
import 'package:stellar_blocks/game/models/game_board.dart';
import 'package:stellar_blocks/ui/design_tokens.dart';

class StellarGame extends FlameGame {
  final GameController controller;
  late BoardComponent _boardComponent;
  late RackComponent _rackComponent;

  StellarGame({required this.controller});

  @override
  Color backgroundColor() => AppColors.background;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final boardSide = size.x * 0.82;
    final boardX = (size.x - boardSide) / 2;
    final boardY = size.y * 0.10;

    _boardComponent = BoardComponent(
      controller: controller,
      boardSize: Vector2(boardSide, boardSide),
    )..position = Vector2(boardX, boardY);

    await add(_boardComponent);

    final rackY = boardY + boardSide + AppSpacing.md;
    final rackHeight = size.y - rackY - AppSpacing.md;

    _rackComponent = RackComponent(
      controller: controller,
      board: _boardComponent,
      position: Vector2(boardX, rackY),
      rackSize: Vector2(boardSide, rackHeight),
    );

    await add(_rackComponent);
  }

  void playClearEffect(
      List<int> clearedRows, List<int> clearedCols, Color color) {
    final cellSz = _boardComponent.cellSize;
    final boardPos = _boardComponent.position;

    for (final y in clearedRows) {
      for (int x = 0; x < GameBoard.size; x++) {
        add(StarBurstEffect(
          position: boardPos + Vector2((x + 0.5) * cellSz, (y + 0.5) * cellSz),
          color: color,
        ));
      }
    }
    for (final x in clearedCols) {
      for (int y = 0; y < GameBoard.size; y++) {
        add(StarBurstEffect(
          position: boardPos + Vector2((x + 0.5) * cellSz, (y + 0.5) * cellSz),
          color: color,
        ));
      }
    }
  }
}
