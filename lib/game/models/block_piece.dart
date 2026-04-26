import 'package:stellar_blocks/game/models/grid_point.dart';

/// Seven distinct colors for block pieces.
enum PieceColor { red, blue, green, yellow, purple, orange, cyan }

/// An immutable block piece consisting of a color and a set of relative cell positions.
///
/// [id] uniquely identifies this piece instance.
/// [color] is the color of this piece.
/// [cells] is a list of GridPoint offsets relative to the piece's origin (0,0).
///
/// For const construction, pass a const list literal of GridPoints.
/// For runtime construction, consider using an unmodifiable list to prevent external mutation.
class BlockPiece {
  final String id;
  final PieceColor color;
  final List<GridPoint> cells;

  const BlockPiece({
    required this.id,
    required this.color,
    required this.cells,
  });
}
