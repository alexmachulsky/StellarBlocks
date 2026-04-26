# StellarBlocks

A Block Blast–style block-fitting puzzle where every cleared line lights up a star
in a slowly-revealed constellation. Each season is a themed night sky (zodiac → mythology → user-voted).

**Platform:** Android first (Google Play). iOS later via the same codebase.
**Stack:** Flutter + flame game engine.

---

## Stack

- **Flutter** 3.24+ (stable channel)
- **Dart** 3.5+
- **flame** ^1.18 — 2D game engine for the live game scene
- **flame_audio** — sound effects and music
- **shared_preferences** — local persistence
- **google_mobile_ads** — rewarded video only (see FEATURES.md, ads policy)
- **in_app_purchase** — single non-consumable IAP
- **games_services** — Google Play Games leaderboards (later phase)
- Unit tests use the built-in `flutter_test` package
- No other dependencies without explicit approval

---

## Architecture rules

These rules exist to keep the game logic testable and the codebase replaceable in pieces.
Do not violate them without flagging it explicitly.

1. **`lib/game/models/` and `lib/game/logic/` are pure Dart.**
   They must NOT import `package:flame`, `package:flutter`, or `dart:ui`.
   Logic types are plain Dart classes — testable without a game loop.
2. **flame lives only in `lib/game/components/` and `lib/game/scenes/`.**
   Components call into `GameBoard` / `ScoreEngine` / `PieceGenerator` and translate
   results into visual effects. Logic never reaches up into a component.
3. **All randomness goes through `SeededRng`.**
   Non-negotiable: `DailyPuzzle` must be reproducible from a date seed,
   and tests must be deterministic. Never call `Random()` directly in logic code.
4. **Persistence is isolated in `lib/persistence/`.**
   Logic types are JSON-serializable but never read/write themselves.
   `SaveManager` does that.
5. **UI never mutates models directly.**
   Use a single `GameController` (a `ChangeNotifier`) as the bridge between Flutter widgets and the flame game.
6. **Monetization is isolated in `lib/monetization/`.**
   `AdManager` and `PurchaseManager` are the only files that import the ad / IAP packages.
   The rest of the codebase talks to them through small interfaces.

---

## Conventions

- **Tests are required** for anything in `lib/game/logic/` and `lib/game/models/`.
  A change that adds logic without tests is incomplete.
- **File size cap: ~300 lines.** If a file is growing past that, split it.
- **Naming:** classes are `UpperCamelCase` nouns (`GameBoard`), methods are `lowerCamelCase` verbs (`canPlace`, `clearLines`), booleans read as questions (`isFull`, `hasValidMove`).
- **No `print` statements** in shipping code. Use `package:logging` with a per-file logger.
- **No analytics SDK** that tracks individual users. Stats are local-only via `shared_preferences`.
- **Colors and spacing** live in `lib/ui/design_tokens.dart` — never hardcode hex or magic numbers in widgets.
- **Run `dart format .` before committing.**
- **Run `flutter analyze` and fix all warnings.** No `// ignore:` without a one-line justification comment.

---

## Project layout

```
StellarBlocks/
├── CLAUDE.md
├── FEATURES.md
├── pubspec.yaml
├── android/                    # Android-specific config (manifest, gradle)
├── lib/
│   ├── main.dart               # App entry, MaterialApp, route table
│   ├── app/
│   │   └── stellar_blocks_app.dart
│   ├── game/
│   │   ├── models/             # Pure Dart: GameBoard, BlockPiece, GridPoint
│   │   ├── logic/              # ScoreEngine, PieceGenerator, GameOverChecker, SeededRng
│   │   ├── components/         # flame: BoardComponent, PieceComponent, StarBurstEffect
│   │   ├── scenes/             # flame: StellarGame (FlameGame subclass)
│   │   └── controller/         # GameController (ChangeNotifier)
│   ├── meta/                   # Constellation, ConstellationStore, DailyPuzzle
│   ├── persistence/            # SaveManager, Stats
│   ├── monetization/           # AdManager, PurchaseManager
│   └── ui/                     # Flutter widgets: HomeScreen, GalleryScreen, design_tokens.dart
├── assets/
│   ├── constellations.json
│   ├── audio/
│   └── images/
└── test/                       # Mirrors lib/
    ├── game/
    │   ├── models/
    │   └── logic/
    └── meta/
```

---

## Common commands

All commands work natively on Ubuntu.

```bash
# One-time setup (Ubuntu)
sudo snap install flutter --classic    # or use the tarball + add to PATH
flutter doctor                          # follow whatever it asks for
flutter doctor --android-licenses       # accept Android SDK licenses

# Project lifecycle
flutter pub get                         # install dependencies
flutter analyze                         # static analysis
dart format .                           # format
flutter test                            # run unit tests
flutter test --coverage                 # with coverage report

# Run on device / emulator
flutter devices                         # list available
flutter run                             # debug build on default device
flutter run --release                   # release build (test perf)

# Build artifacts
flutter build apk --release             # APK for sideloading / testing
flutter build appbundle --release       # AAB for Google Play upload
```

---

## How to work with Claude Code on this project

- **Always read this file first** in a new session, plus FEATURES.md.
- **Plan before editing** any file in `lib/game/models/` or `lib/game/logic/` — these are foundational.
- **Run `flutter test` after any change to logic.** Don't claim "done" without a green run.
- **Show diffs**, not whole-file rewrites, for files over 100 lines.
- **Ask before adding a dependency.** This project ships only the dependencies listed at the top of this file.
- **One feature per branch.** Don't pile unrelated changes into one PR.
- **When implementing UI, follow the architecture rules strictly** — no `package:flame` imports in logic files, no `print()` calls, no inline hex colors.

---

## Current focus

<!-- Update this section every working session so Claude has fresh context -->

- [ ] Phase 0: Project scaffold, pubspec, folder structure, asset pipeline
- [ ] Phase 1: `GameBoard`, `BlockPiece`, `GridPoint`, `PieceShapes`, `SeededRng`, full unit test coverage
- [ ] Phase 2: flame `StellarGame` with drag-and-drop, ghost preview, snap-to-grid
- [ ] Phase 3: `ConstellationStore`, line-clear → star-light animation
- [ ] Phase 4: Daily Puzzle (seeded by date) + shareable result card
- [ ] Phase 5: Persistence, Play Games leaderboards, Google Play soft launch (Philippines + Canada)

---

## Out of scope (for now)

- iOS build (will revisit once Android is shipping; codebase is already iOS-ready via Flutter)
- Multiplayer or real-time online play
- In-app purchases beyond the single "Stargazer Pass" tier
- Custom shaders beyond what flame provides out of the box
- Push notifications (default off; revisit only if retention demands it)
- Subscriptions, energy systems, loot boxes — see FEATURES.md "What we are NOT building"
