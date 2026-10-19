
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:puzzle15/app.dart';
import 'package:puzzle15/providers/scores_provider.dart';
import 'package:puzzle15/providers/settings_provider.dart';
import 'package:puzzle15/repositories/score_repository.dart';
import 'package:puzzle15/repositories/settings_repository.dart';

void main() {
  testWidgets('arranca, pasa el splash y muestra el menú', (tester) async {
    final settings = SettingsProvider(InMemorySettingsRepository());
    final scores = ScoresProvider(InMemoryScoreRepository());
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settings),
        ChangeNotifierProvider.value(value: scores),
      ],
      child: const PuzzleApp(),
    ));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('Jugar'), findsOneWidget);
  });
}
