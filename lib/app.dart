import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/settings_provider.dart';
import 'screens/game_screen.dart';
import 'screens/instructions_screen.dart';
import 'screens/main_menu_screen.dart';
import 'screens/scores_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';

class PuzzleApp extends StatelessWidget {
  const PuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context
        .select<SettingsProvider, ThemeMode>((p) => p.settings.themeMode);
    ThemeData theme(Brightness b) => ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: b));
    return MaterialApp(
      title: '15-Puzzle',
      debugShowCheckedModeBanner: false,
      theme: theme(Brightness.light),
      darkTheme: theme(Brightness.dark),
      themeMode: mode,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/menu': (_) => const MainMenuScreen(),
        '/game': (_) => const GameScreen(),
        '/scores': (_) => const ScoresScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/instructions': (_) => const InstructionsScreen(),
      },
    );
  }
}
