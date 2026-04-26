/// A 2D grid coordinate with integer x and y values.
///
/// GridPoint is an immutable value type suitable for use in Sets, as Map keys,
/// and as const values. It enforces the contract: equal objects have equal hash codes,
/// and equality is based on coordinate values.
class GridPoint {
  final int x;
  final int y;

  const GridPoint(this.x, this.y);

  /// Returns a new GridPoint with coordinates offset by another GridPoint.
  GridPoint operator +(GridPoint other) => GridPoint(x + other.x, y + other.y);

  @override
  bool operator ==(Object other) =>
      other is GridPoint && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'GridPoint($x, $y)';
}
