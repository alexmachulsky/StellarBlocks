import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_blocks/game/logic/piece_generator.dart';
import 'package:stellar_blocks/game/logic/piece_shapes.dart';
import 'package:stellar_blocks/game/logic/seeded_rng.dart';
import 'package:stellar_blocks/game/models/block_piece.dart';

void main() {
  group('PieceGenerator', () {
    test('nextRack returns exactly 3 pieces', () {
      final rng = SeededRng(42);
      final generator = PieceGenerator(rng);
      final rack = generator.nextRack();

      expect(rack.length, equals(3));
    });

    test('every piece in rack has non-empty cells and valid color', () {
      final rng = SeededRng(42);
      final generator = PieceGenerator(rng);
      final rack = generator.nextRack();

      for (final piece in rack) {
        expect(piece.cells.isNotEmpty, isTrue);
        expect(PieceColor.values.contains(piece.color), isTrue);
      }
    });

    test('piece IDs are unique across multiple nextRack calls', () {
      final rng = SeededRng(42);
      final generator = PieceGenerator(rng);

      final rack1 = generator.nextRack();
      final rack2 = generator.nextRack();
      final rack3 = generator.nextRack();

      final allIds = <String>[
        ...rack1.map((p) => p.id),
        ...rack2.map((p) => p.id),
        ...rack3.map((p) => p.id),
      ];

      expect(allIds.toSet().length, equals(9),
          reason: 'All 9 piece IDs should be unique');
    });

    test('same seed produces same rack sequence', () {
      final gen1 = PieceGenerator(SeededRng(42));
      final gen2 = PieceGenerator(SeededRng(42));

      final rack1a = gen1.nextRack();
      final rack2a = gen2.nextRack();

      expect(rack1a.length, equals(rack2a.length));
      for (int i = 0; i < rack1a.length; i++) {
        expect(rack1a[i].id, equals(rack2a[i].id));
        expect(rack1a[i].color, equals(rack2a[i].color));
        expect(rack1a[i].cells, equals(rack2a[i].cells));
      }
    });

    test('different seeds produce different first racks', () {
      final gen1 = PieceGenerator(SeededRng(1));
      final gen2 = PieceGenerator(SeededRng(2));

      final rack1 = gen1.nextRack();
      final rack2 = gen2.nextRack();

      bool racksAreSame = true;
      for (int i = 0; i < rack1.length; i++) {
        if (rack1[i].color != rack2[i].color ||
            rack1[i].cells != rack2[i].cells) {
          racksAreSame = false;
          break;
        }
      }

      expect(racksAreSame, isFalse,
          reason: 'Different seeds should produce different racks');
    });

    test('sequential racks on same generator are different', () {
      final rng = SeededRng(42);
      final generator = PieceGenerator(rng);

      final rack1 = generator.nextRack();
      final rack2 = generator.nextRack();

      bool racksAreSame = true;
      for (int i = 0; i < rack1.length; i++) {
        if (rack1[i].color != rack2[i].color ||
            rack1[i].cells != rack2[i].cells) {
          racksAreSame = false;
          break;
        }
      }

      expect(racksAreSame, isFalse,
          reason: 'Sequential racks should be different');
    });

    test('piece counter advances correctly', () {
      final rng = SeededRng(42);
      final generator = PieceGenerator(rng);

      final rack1 = generator.nextRack();
      expect(rack1[0].id, equals('piece_0'));
      expect(rack1[1].id, equals('piece_1'));
      expect(rack1[2].id, equals('piece_2'));

      final rack2 = generator.nextRack();
      expect(rack2[0].id, equals('piece_3'));
      expect(rack2[1].id, equals('piece_4'));
      expect(rack2[2].id, equals('piece_5'));
    });

    test('cells come from PieceShapes.all', () {
      final rng = SeededRng(42);
      final generator = PieceGenerator(rng);

      for (int i = 0; i < 10; i++) {
        final rack = generator.nextRack();
        for (final piece in rack) {
          bool cellsMatch = false;
          for (final shape in PieceShapes.all) {
            if (identical(piece.cells, shape)) {
              cellsMatch = true;
              break;
            }
          }
          expect(cellsMatch, isTrue,
              reason:
                  'Piece cells must be reference-identical to a shape in PieceShapes.all');
        }
      }
    });

    test('all pieces have valid PieceColor enum values', () {
      final rng = SeededRng(123);
      final generator = PieceGenerator(rng);

      for (int i = 0; i < 20; i++) {
        final rack = generator.nextRack();
        for (final piece in rack) {
          expect(
            piece.color == PieceColor.red ||
                piece.color == PieceColor.blue ||
                piece.color == PieceColor.green ||
                piece.color == PieceColor.yellow ||
                piece.color == PieceColor.purple ||
                piece.color == PieceColor.orange ||
                piece.color == PieceColor.cyan,
            isTrue,
            reason: 'Piece color must be one of the 7 valid PieceColor values',
          );
        }
      }
    });
  });
}
