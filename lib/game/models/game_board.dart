import 'package:stellar_blocks/game/models/block_piece.dart';
import 'package:stellar_blocks/game/models/grid_point.dart';

/// Result of clearing fully-occupied rows and columns.
///
/// When a piece is placed and completes one or more full rows/columns,
/// they are cleared simultaneously. [linesCleared] counts the total number
/// of rows and columns cleared in a single placement.
class ClearResult {
  /// Row indices (y values) that were fully occupied and cleared.
  final List<int> clearedRows;

  /// Column indices (x values) that were fully occupied and cleared.
  final List<int> clearedCols;

  const ClearResult({
    required this.clearedRows,
    required this.clearedCols,
  });

  /// Total number of lines cleared (rows + columns).
  int get linesCleared => clearedRows.length + clearedCols.length;

  /// True if any rows or columns were cleared.
  bool get hasClears => clearedRows.isNotEmpty || clearedCols.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      other is ClearResult &&
      _listEquals(clearedRows, other.clearedRows) &&
      _listEquals(clearedCols, other.clearedCols);

  @override
  int get hashCode => Object.hash(clearedRows, clearedCols);

  static bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Result of placing a block piece on the board.
///
/// Contains the new board state after placement and clearing.
class PlaceResult {
  /// The board state after the piece was placed and lines were cleared.
  final GameBoard board;

  /// The result of clearing full rows and columns.
  final ClearResult clearResult;

  const PlaceResult({
    required this.board,
    required this.clearResult,
  });
}

/// An 8×8 grid-based game board for the block-fitting puzzle.
///
/// The board tracks which cells are occupied. Pieces can be placed on empty cells.
/// When a row or column becomes fully occupied, it is automatically cleared.
class GameBoard {
  /// Standard board size: 8×8.
  static const int size = 8;

  /// Internal grid representation: _grid[y][x] = true means occupied.
  final List<List<bool>> _grid;

  GameBoard._(this._grid);

  /// Creates an empty 8×8 board with all cells unoccupied.
  factory GameBoard.empty() {
    final grid = List.generate(
        size, (_) => List.filled(size, false, growable: false),
        growable: false);
    return GameBoard._(grid);
  }

  /// Returns true if the cell at (x, y) is occupied.
  ///
  /// Throws [RangeError] if coordinates are out of bounds.
  bool isOccupied(int x, int y) {
    if (x < 0 || x >= size || y < 0 || y >= size) {
      throw RangeError('Coordinates ($x, $y) out of bounds for 8x8 board');
    }
    return _grid[y][x];
  }

  /// Returns true if the piece can be placed with its origin at [position].
  ///
  /// A piece can be placed if:
  /// - All of its cells fall within the board bounds
  /// - None of its cells overlap with already-occupied cells
  bool canPlace(BlockPiece piece, GridPoint position) {
    for (final offset in piece.cells) {
      final x = position.x + offset.x;
      final y = position.y + offset.y;

      // Check bounds
      if (x < 0 || x >= size || y < 0 || y >= size) {
        return false;
      }

      // Check occupancy
      if (_grid[y][x]) {
        return false;
      }
    }
    return true;
  }

  /// Places the piece on the board, clears full rows and columns, and returns the result.
  ///
  /// The algorithm:
  /// 1. Assert the piece can be placed at [position]
  /// 2. Create a mutable copy of the grid
  /// 3. Mark all cells occupied by the piece
  /// 4. Detect fully-occupied rows and columns
  /// 5. Clear them simultaneously
  /// 6. Return the new board and clear result
  ///
  /// Throws [StateError] if [canPlace] returns false.
  PlaceResult place(BlockPiece piece, GridPoint position) {
    if (!canPlace(piece, position)) {
      throw StateError('Cannot place piece at $position');
    }

    // Step 2: Create a mutable copy of the grid
    final newGrid = List.generate(
      size,
      (y) => List.of(_grid[y], growable: true),
      growable: false,
    );

    // Step 3: Mark cells occupied by the piece
    for (final offset in piece.cells) {
      final x = position.x + offset.x;
      final y = position.y + offset.y;
      newGrid[y][x] = true;
    }

    // Step 4: Detect fully-occupied rows and columns
    final clearedRows = <int>[];
    final clearedCols = <int>[];

    // Check rows
    for (int y = 0; y < size; y++) {
      if (newGrid[y].every((cell) => cell)) {
        clearedRows.add(y);
      }
    }

    // Check columns
    for (int x = 0; x < size; x++) {
      if (List.generate(size, (y) => newGrid[y][x]).every((cell) => cell)) {
        clearedCols.add(x);
      }
    }

    // Step 5: Clear rows and columns simultaneously
    for (final y in clearedRows) {
      for (int x = 0; x < size; x++) {
        newGrid[y][x] = false;
      }
    }

    for (final x in clearedCols) {
      for (int y = 0; y < size; y++) {
        newGrid[y][x] = false;
      }
    }

    // Step 6: Return new board and clear result
    return PlaceResult(
      board: GameBoard._(newGrid),
      clearResult:
          ClearResult(clearedRows: clearedRows, clearedCols: clearedCols),
    );
  }

  /// Returns true if any of the given pieces can be placed anywhere on the board.
  ///
  /// This is useful for checking if the game is over: if no valid moves exist
  /// with the current piece rack, the game cannot continue.
  bool hasValidMove(List<BlockPiece> pieces) {
    // For each piece, try every position on the board
    for (final piece in pieces) {
      for (int y = 0; y < size; y++) {
        for (int x = 0; x < size; x++) {
          if (canPlace(piece, GridPoint(x, y))) {
            return true;
          }
        }
      }
    }
    return false;
  }

  /// Returns a deep copy of this board.
  ///
  /// The copy is completely independent; modifying the original via [place]
  /// will not affect the snapshot. Useful for implementing undo or tentative moves.
  GameBoard snapshot() {
    final copiedGrid = List.generate(
      size,
      (y) => List.of(_grid[y], growable: false),
      growable: false,
    );
    return GameBoard._(copiedGrid);
  }

  @override
  bool operator ==(Object other) =>
      other is GameBoard &&
      List.generate(size, (y) => _gridRowEquals(_grid[y], other._grid[y]))
          .every((x) => x);

  @override
  int get hashCode {
    int hash = 0;
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        if (_grid[y][x]) {
          hash = Object.hash(hash, x, y);
        }
      }
    }
    return hash;
  }

  static bool _gridRowEquals(List<bool> a, List<bool> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
