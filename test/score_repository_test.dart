import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:puzzle15/models/difficulty.dart';
import 'package:puzzle15/models/game_result.dart';
import 'package:puzzle15/repositories/score_repository.dart';

GameResult r(int secs, int moves) => GameResult(
    difficulty: Difficulty.medium,
    time: Duration(seconds: secs),
    moves: moves,
    date: DateTime(2026, 10, 16));

void main() {
  test('guarda récords, ignora peores y permite borrar', () async {
    SharedPreferences.setMockInitialValues({});
    final repo = PrefsScoreRepository(await SharedPreferences.getInstance());

    expect(await repo.submit(r(100, 80)), isTrue);
    expect(await repo.submit(r(120, 90)), isFalse); // peor en ambos
    expect(await repo.submit(r(90, 95)), isTrue); // mejor tiempo
    expect(await repo.submit(r(130, 70)), isTrue); // menos movimientos

    final hs = (await repo.loadAll())[Difficulty.medium]!;
    expect(hs.bestTime, const Duration(seconds: 90));
    expect(hs.bestMoves, 70);

    await repo.clear();
    expect(await repo.loadAll(), isEmpty);
  });
}
