import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_blocks/game/logic/seeded_rng.dart';

void main() {
  group('SeededRng', () {
    test('determinism: identical sequences from identical seeds', () {
      final rng1 = SeededRng(42);
      final rng2 = SeededRng(42);

      for (int i = 0; i < 10; i++) {
        final val1 = rng1.nextInt(100);
        final val2 = rng2.nextInt(100);
        expect(val1, equals(val2),
            reason: 'Iteration $i: same seed should produce same value');
      }
    });

    test('seed independence: different seeds produce different first values',
        () {
      final rng1 = SeededRng(1);
      final rng2 = SeededRng(2);

      final val1 = rng1.nextInt(100000); // large range to avoid collision
      final val2 = rng2.nextInt(100000);

      expect(val1, isNot(equals(val2)),
          reason: 'Different seeds should produce different first values');
    });

    test('seed 0 edge case: does not crash or infinite loop', () {
      final rng = SeededRng(0);
      final values = <int>[];

      for (int i = 0; i < 10; i++) {
        values.add(rng.nextInt(100));
      }

      // Should have produced 10 distinct-ish values (not all zeros)
      expect(values.length, equals(10));
      final allZero = values.every((v) => v == 0);
      expect(allZero, isFalse,
          reason: 'Seed 0 should not produce all zeros forever');
    });

    test('nextInt bounds: always in [0, max)', () {
      final rng = SeededRng(999);
      const max = 10;
      const iterations = 1000;

      for (int i = 0; i < iterations; i++) {
        final value = rng.nextInt(max);
        expect(value, greaterThanOrEqualTo(0),
            reason: 'Value at iteration $i should be >= 0');
        expect(value, lessThan(max),
            reason: 'Value at iteration $i should be < $max');
      }
    });

    test('nextDouble bounds: always in [0.0, 1.0)', () {
      final rng = SeededRng(999);
      const iterations = 1000;

      for (int i = 0; i < iterations; i++) {
        final value = rng.nextDouble();
        expect(value, greaterThanOrEqualTo(0.0),
            reason: 'Value at iteration $i should be >= 0.0');
        expect(value, lessThan(1.0),
            reason: 'Value at iteration $i should be < 1.0');
      }
    });

    test('sequence reproducibility: same seed yields identical sequence', () {
      final rng1 = SeededRng(12345);
      final seq1 = <int>[];
      for (int i = 0; i < 5; i++) {
        seq1.add(rng1.nextInt(1000000));
      }

      final rng2 = SeededRng(12345);
      final seq2 = <int>[];
      for (int i = 0; i < 5; i++) {
        seq2.add(rng2.nextInt(1000000));
      }

      expect(seq1, equals(seq2),
          reason: 'Resetting with same seed should produce identical sequence');
    });

    test('nextInt with max=1 always returns 0', () {
      final rng = SeededRng(777);
      for (int i = 0; i < 100; i++) {
        expect(rng.nextInt(1), equals(0));
      }
    });

    test('nextDouble produces reasonable distribution', () {
      final rng = SeededRng(54321);
      final values = <double>[];
      const iterations = 100;

      for (int i = 0; i < iterations; i++) {
        values.add(rng.nextDouble());
      }

      // Check that we get a reasonable spread (not all clustered at one end)
      final min = values.reduce((a, b) => a < b ? a : b);
      final max = values.reduce((a, b) => a > b ? a : b);

      expect(min, lessThan(0.2), reason: 'Should have values in lower range');
      expect(max, greaterThan(0.8),
          reason: 'Should have values in upper range');
    });
  });
}
