import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/difficulty.dart';
import '../models/game_result.dart';

abstract class ScoreRepository {
  Future<Map<Difficulty, HighScore>> loadAll();

  /// Guarda el resultado si mejora el tiempo o los movimientos.
  /// Devuelve true si se estableció algún récord nuevo.
  Future<bool> submit(GameResult result);

  Future<void> clear();
}

/// Lógica de mezcla de récords, común a todas las implementaciones.
HighScore mergeScore(HighScore? old, GameResult r) {
  if (old == null) {
    return HighScore(bestTime: r.time, bestMoves: r.moves, date: r.date);
  }
  final betterTime = r.time < old.bestTime;
  return HighScore(
    bestTime: betterTime ? r.time : old.bestTime,
    bestMoves: r.moves < old.bestMoves ? r.moves : old.bestMoves,
    date: betterTime ? r.date : old.date,
  );
}

bool isRecord(HighScore? old, GameResult r) =>
    old == null || r.time < old.bestTime || r.moves < old.bestMoves;

class InMemoryScoreRepository implements ScoreRepository {
  final Map<Difficulty, HighScore> _data = {};
  @override
  Future<Map<Difficulty, HighScore>> loadAll() async => Map.of(_data);
  @override
  Future<bool> submit(GameResult r) async {
    final old = _data[r.difficulty];
    final rec = isRecord(old, r);
    if (rec) _data[r.difficulty] = mergeScore(old, r);
    return rec;
  }

  @override
  Future<void> clear() async => _data.clear();
}

class PrefsScoreRepository implements ScoreRepository {
  PrefsScoreRepository(this._prefs);
  final SharedPreferences _prefs;
  static const _key = 'high_scores';

  @override
  Future<Map<Difficulty, HighScore>> loadAll() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return {
        for (final d in Difficulty.values)
          if (map[d.name] != null)
            d: HighScore.fromJson(map[d.name] as Map<String, dynamic>)
      };
    } catch (_) {
      return {}; // datos corruptos: se ignoran
    }
  }

  @override
  Future<bool> submit(GameResult r) async {
    final all = await loadAll();
    final old = all[r.difficulty];
    if (!isRecord(old, r)) return false;
    all[r.difficulty] = mergeScore(old, r);
    await _prefs.setString(
      _key,
      jsonEncode({for (final e in all.entries) e.key.name: e.value.toJson()}),
    );
    return true;
  }

  @override
  Future<void> clear() => _prefs.remove(_key);
}
