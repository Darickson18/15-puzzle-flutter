import 'package:flutter/foundation.dart';
import '../models/difficulty.dart';
import '../models/game_result.dart';
import '../repositories/score_repository.dart';

class ScoresProvider extends ChangeNotifier {
  ScoresProvider(this._repo);
  final ScoreRepository _repo;
  Map<Difficulty, HighScore> _scores = {};
  Map<Difficulty, HighScore> get scores => _scores;

  Future<void> load() async {
    _scores = await _repo.loadAll();
    notifyListeners();
  }

  /// La Parte 1 llama a esto al ganar. Devuelve true si hay récord nuevo.
  Future<bool> submit(GameResult r) async {
    final rec = await _repo.submit(r);
    if (rec) await load();
    return rec;
  }

  Future<void> clear() async {
    await _repo.clear();
    await load();
  }
}
