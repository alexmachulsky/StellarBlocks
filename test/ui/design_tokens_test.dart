import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_blocks/game/models/block_piece.dart';
import 'package:stellar_blocks/ui/design_tokens.dart';

void main() {
  group('AppColors.pieceColor', () {
    test('returns a Color for every PieceColor value', () {
      for (final color in PieceColor.values) {
        final result = AppColors.pieceColor(color);
        expect(result, isA<Color>(), reason: '$color mapped to a Color');
      }
    });

    test('red maps to a reddish color', () {
      final c = AppColors.pieceColor(PieceColor.red);
      // 0xFFE53935: Red is 229, Blue is 53
      expect(c.r > c.b, isTrue);
    });

    test('blue maps to a bluish color', () {
      final c = AppColors.pieceColor(PieceColor.blue);
      // 0xFF1E88E5: Blue is 229, Red is 30
      expect(c.b > c.r, isTrue);
    });
  });
}
