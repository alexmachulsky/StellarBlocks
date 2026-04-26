import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_blocks/game/models/grid_point.dart';

void main() {
  group('GridPoint', () {
    test('construction stores x and y', () {
      const point = GridPoint(3, 5);
      expect(point.x, 3);
      expect(point.y, 5);
    });

    test('is const-constructable', () {
      const point1 = GridPoint(1, 2);
      const point2 = GridPoint(1, 2);
      expect(identical(point1, point2), true);
    });

    test('addition operator adds coordinates', () {
      const p1 = GridPoint(1, 2);
      const p2 = GridPoint(3, 4);
      final result = p1 + p2;
      expect(result.x, 4);
      expect(result.y, 6);
    });

    test('addition with negative coordinates', () {
      const p1 = GridPoint(5, 3);
      const p2 = GridPoint(-2, -1);
      final result = p1 + p2;
      expect(result.x, 3);
      expect(result.y, 2);
    });

    test('addition with zero coordinates', () {
      const p1 = GridPoint(7, 8);
      const p2 = GridPoint(0, 0);
      final result = p1 + p2;
      expect(result.x, 7);
      expect(result.y, 8);
    });

    test('equality: same coordinates are equal', () {
      const p1 = GridPoint(1, 2);
      const p2 = GridPoint(1, 2);
      expect(p1 == p2, true);
      expect(p1 != p2, false);
    });

    test('equality: different coordinates are not equal', () {
      const p1 = GridPoint(1, 2);
      const p2 = GridPoint(1, 3);
      expect(p1 == p2, false);
      expect(p1 != p2, true);
    });

    test('hashCode is consistent for equal objects', () {
      const p1 = GridPoint(1, 2);
      const p2 = GridPoint(1, 2);
      expect(p1.hashCode, p2.hashCode);
    });

    test('value type in Set: duplicate points collapse', () {
      const p1 = GridPoint(5, 5);
      const p2 = GridPoint(5, 5);
      final set = <GridPoint>{}
        ..add(p1)
        ..add(p2);
      expect(set.length, 1);
    });

    test('value type as Map key: retrieve by equal instance', () {
      const p1 = GridPoint(3, 4);
      const p2 = GridPoint(3, 4);
      final map = {p1: 'value'};
      expect(map[p2], 'value');
    });

    test('not equal to non-GridPoint objects', () {
      const p = GridPoint(0, 0);
      // The `other is GridPoint` guard in operator == rejects non-GridPoint objects
      expect(p == Object(), false);
    });

    test('toString returns formatted string', () {
      const p = GridPoint(3, 5);
      expect(p.toString(), 'GridPoint(3, 5)');
    });

    test('toString with negative coordinates', () {
      const p = GridPoint(-1, -2);
      expect(p.toString(), 'GridPoint(-1, -2)');
    });

    test('toString with zero coordinates', () {
      const p = GridPoint(0, 0);
      expect(p.toString(), 'GridPoint(0, 0)');
    });
  });
}
