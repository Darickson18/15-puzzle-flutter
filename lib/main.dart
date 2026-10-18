import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'providers/scores_provider.dart';
import 'providers/settings_provider.dart';
import 'repositories/score_repository.dart';
import 'repositories/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final settings = SettingsProvider(PrefsSettingsRepository(prefs));
  final scores = ScoresProvider(PrefsScoreRepository(prefs));
  await Future.wait([settings.load(), scores.load()]); // evita parpadeo de tema

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: settings),
      ChangeNotifierProvider.value(value: scores),
    ],
    child: const PuzzleApp(),
  ));
}
