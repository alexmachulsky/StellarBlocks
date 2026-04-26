import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:stellar_blocks/game/controller/game_controller.dart';
import 'package:stellar_blocks/game/logic/seeded_rng.dart';
import 'package:stellar_blocks/game/scenes/stellar_game.dart';
import 'package:stellar_blocks/ui/design_tokens.dart';

class StellarBlocksApp extends StatelessWidget {
  const StellarBlocksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StellarBlocks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.starGold,
          secondary: AppColors.nebulaPurple,
          surface: AppColors.surface,
        ),
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController _controller;
  late final StellarGame _game;

  @override
  void initState() {
    super.initState();
    _controller = GameController(
      rng: SeededRng(DateTime.now().millisecondsSinceEpoch),
    );
    _game = StellarGame(controller: _controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          GameWidget(game: _game),
          SafeArea(
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => _ScoreOverlay(
                score: _controller.score,
                isGameOver: _controller.isGameOver,
                canUndo: _controller.canUndo,
                onUndo: _controller.undo,
                onNewGame: _controller.newGame,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreOverlay extends StatelessWidget {
  final int score;
  final bool isGameOver;
  final bool canUndo;
  final VoidCallback onUndo;
  final VoidCallback onNewGame;

  const _ScoreOverlay({
    required this.score,
    required this.isGameOver,
    required this.canUndo,
    required this.onUndo,
    required this.onNewGame,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$score', style: AppTextStyles.heading),
          Row(
            children: [
              if (canUndo)
                IconButton(
                  icon: const Icon(Icons.undo, color: Colors.white),
                  onPressed: onUndo,
                ),
              if (isGameOver)
                TextButton(
                  onPressed: onNewGame,
                  child: const Text(
                    'New Game',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
