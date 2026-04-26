import 'package:stellar_blocks/game/models/grid_point.dart';

/// A collection of predefined piece shapes as lists of GridPoint cell offsets.
///
/// Each shape is defined with cells positioned relative to a canonical top-left
/// origin (0, 0), using non-negative coordinates only. Shapes are immutable and
/// suitable for const construction.
///
/// There are exactly 19 shapes: 1 single, 2 dominoes, 4 triominoes, 4 tetrominoes
/// (including one square), 4 big L-shapes, 2 pentominoes, and 1 big 3×3 square.
class PieceShapes {
  // Single cell
  static const List<GridPoint> single = [
    GridPoint(0, 0),
  ];

  // Dominoes (2 cells)
  static const List<GridPoint> h2 = [
    GridPoint(0, 0),
    GridPoint(1, 0),
  ];

  static const List<GridPoint> v2 = [
    GridPoint(0, 0),
    GridPoint(0, 1),
  ];

  // Triominoes (3 cells)
  static const List<GridPoint> h3 = [
    GridPoint(0, 0),
    GridPoint(1, 0),
    GridPoint(2, 0),
  ];

  static const List<GridPoint> v3 = [
    GridPoint(0, 0),
    GridPoint(0, 1),
    GridPoint(0, 2),
  ];

  static const List<GridPoint> cornerNE = [
    GridPoint(0, 0),
    GridPoint(1, 0),
    GridPoint(1, 1),
  ];

  static const List<GridPoint> cornerNW = [
    GridPoint(0, 0),
    GridPoint(1, 0),
    GridPoint(0, 1),
  ];

  static const List<GridPoint> cornerSE = [
    GridPoint(0, 0),
    GridPoint(0, 1),
    GridPoint(1, 1),
  ];

  static const List<GridPoint> cornerSW = [
    GridPoint(1, 0),
    GridPoint(0, 1),
    GridPoint(1, 1),
  ];

  // Tetrominoes (4 cells)
  static const List<GridPoint> h4 = [
    GridPoint(0, 0),
    GridPoint(1, 0),
    GridPoint(2, 0),
    GridPoint(3, 0),
  ];

  static const List<GridPoint> v4 = [
    GridPoint(0, 0),
    GridPoint(0, 1),
    GridPoint(0, 2),
    GridPoint(0, 3),
  ];

  static const List<GridPoint> sq2 = [
    GridPoint(0, 0),
    GridPoint(1, 0),
    GridPoint(0, 1),
    GridPoint(1, 1),
  ];

  // Big L-shapes (4 cells)
  static const List<GridPoint> lNE = [
    GridPoint(0, 0),
    GridPoint(0, 1),
    GridPoint(0, 2),
    GridPoint(1, 2),
  ];

  static const List<GridPoint> lNW = [
    GridPoint(1, 0),
    GridPoint(1, 1),
    GridPoint(0, 2),
    GridPoint(1, 2),
  ];

  static const List<GridPoint> lSE = [
    GridPoint(0, 0),
    GridPoint(1, 0),
    GridPoint(0, 1),
    GridPoint(0, 2),
  ];

  static const List<GridPoint> lSW = [
    GridPoint(0, 0),
    GridPoint(1, 0),
    GridPoint(1, 1),
    GridPoint(1, 2),
  ];

  // Pentominoes (5 cells)
  static const List<GridPoint> h5 = [
    GridPoint(0, 0),
    GridPoint(1, 0),
    GridPoint(2, 0),
    GridPoint(3, 0),
    GridPoint(4, 0),
  ];

  static const List<GridPoint> v5 = [
    GridPoint(0, 0),
    GridPoint(0, 1),
    GridPoint(0, 2),
    GridPoint(0, 3),
    GridPoint(0, 4),
  ];

  // Big 3×3 square (9 cells)
  static const List<GridPoint> sq3 = [
    GridPoint(0, 0),
    GridPoint(1, 0),
    GridPoint(2, 0),
    GridPoint(0, 1),
    GridPoint(1, 1),
    GridPoint(2, 1),
    GridPoint(0, 2),
    GridPoint(1, 2),
    GridPoint(2, 2),
  ];

  /// Master list of all 19 shapes.
  /// Used by PieceGenerator to pick random shapes.
  static const List<List<GridPoint>> all = [
    single,
    h2,
    v2,
    h3,
    v3,
    cornerNE,
    cornerNW,
    cornerSE,
    cornerSW,
    h4,
    v4,
    sq2,
    lNE,
    lNW,
    lSE,
    lSW,
    h5,
    v5,
    sq3,
  ];
}
