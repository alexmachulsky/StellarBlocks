import 'package:flutter/material.dart';
import 'package:stellar_blocks/ui/design_tokens.dart';

/// Root application widget for StellarBlocks.
///
/// Configures the Material theme with cosmic design tokens and sets up routing.
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
      home: const _HomeStub(),
    );
  }
}

/// Temporary home screen stub for Phase 0.
///
/// This will be replaced with the actual game screen in later phases.
class _HomeStub extends StatelessWidget {
  const _HomeStub();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'StellarBlocks',
          style: AppTextStyles.heading,
        ),
      ),
    );
  }
}
