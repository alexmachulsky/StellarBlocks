import 'package:stellar_blocks/game/logic/piece_shapes.dart';
import 'package:stellar_blocks/game/logic/seeded_rng.dart';
import 'package:stellar_blocks/game/models/block_piece.dart';

/// Generates random block pieces from a seeded RNG.
///
/// Given the same seed, [PieceGenerator] produces an identical sequence of
/// piece racks. Each rack contains exactly 3 [BlockPiece] instances, each with
/// a random shape from [PieceShapes.all] and a random [PieceColor].
///
/// Piece IDs are auto-incremented globally within the generator instance,
/// ensuring uniqueness across multiple [nextRack()] calls.
class PieceGenerator {
  final SeededRng _rng;
  int _pieceCounter = 0;

  /// Creates a new [PieceGenerator] using the provided [SeededRng].
  PieceGenerator(this._rng);

  /// Returns a rack of exactly 3 [BlockPiece] instances.
  ///
  /// Each piece has a random shape from [PieceShapes.all] and a random
  /// [PieceColor]. Pieces are assigned unique IDs in the format 'piece_N'
  /// where N increments globally.
  List<BlockPiece> nextRack() {
    return List.generate(3, (_) => _nextPiece());
  }

  /// Generates a single [BlockPiece] with random shape and color.
  BlockPiece _nextPiece() {
    final shapeIndex = _rng.nextInt(PieceShapes.all.length);
    final colorIndex = _rng.nextInt(PieceColor.values.length);
    final cells = PieceShapes.all[shapeIndex];
    final color = PieceColor.values[colorIndex];
    final id = 'piece_$_pieceCounter';
    _pieceCounter++;
    return BlockPiece(id: id, color: color, cells: cells);
  }
}
