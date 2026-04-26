/// A deterministic pseudo-random number generator using the Mulberry32 algorithm.
///
/// Given the same seed, [SeededRng] produces an identical sequence of values.
/// This is essential for reproducible game states (e.g., Daily Puzzle fairness).
///
/// The internal state is maintained as a 32-bit integer; all operations are
/// masked with `& 0xFFFFFFFF` to ensure 32-bit arithmetic.
///
/// No imports of flutter, flame, or dart:ui.
class SeededRng {
  /// The internal 32-bit state.
  int _state;

  /// Creates a new [SeededRng] with the given seed.
  ///
  /// The seed is masked to 32 bits. Seed 0 is handled gracefully by the
  /// Mulberry32 algorithm and will not produce all zeros.
  SeededRng(int seed) : _state = (seed & 0xFFFFFFFF);

  /// Returns the next pseudo-random integer in the range [0, max).
  ///
  /// Advances the internal state by one Mulberry32 step.
  int nextInt(int max) {
    final random = _nextRaw();
    return (random % max).abs();
  }

  /// Returns the next pseudo-random double in the range [0.0, 1.0).
  ///
  /// Advances the internal state by one Mulberry32 step and normalizes
  /// the result to [0.0, 1.0) by dividing by 2^32.
  double nextDouble() {
    final random = _nextRaw();
    return (random & 0xFFFFFFFF) / 4294967296.0; // 2^32
  }

  /// Executes one Mulberry32 step and updates [_state].
  ///
  /// Returns the output of the Mulberry32 transformation.
  /// All arithmetic is masked to 32 bits to prevent Dart's 64-bit integers
  /// from affecting the algorithm.
  int _nextRaw() {
    _state = (_state + 0x6D2B79F5) & 0xFFFFFFFF;
    int t = _state;

    // t = (t ^ (t >> 15)) * (t | 1)
    t = (((t ^ (t >> 15)) * (t | 1)) & 0xFFFFFFFF);

    // t ^= t + (t ^ (t >> 7)) * (t | 61)
    final temp = ((t ^ (t >> 7)) * (t | 61)) & 0xFFFFFFFF;
    t = (t ^ (t + temp)) & 0xFFFFFFFF;

    // return t ^ (t >> 14)
    return (t ^ (t >> 14)) & 0xFFFFFFFF;
  }
}
