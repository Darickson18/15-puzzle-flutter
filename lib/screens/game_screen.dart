import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_settings.dart';
import '../providers/scores_provider.dart';
import '../providers/settings_provider.dart';
import 'puzzle_board_screen.dart';

/// Puente entre la Parte 2 (ajustes/marcadores) y la Parte 1 (tablero).
/// La ruta '/game' sigue apuntando a GameScreen.
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.read<SettingsProvider>().settings;
    return PuzzleBoardScreen(
      difficulty: s.difficulty,
      isColorfulMode: s.tileStyle == TileStyle.colorful,
      onWin: (result) => context.read<ScoresProvider>().submit(result),
    );
  }
}
