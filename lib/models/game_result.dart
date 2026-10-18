import 'difficulty.dart';

/// Resultado de una partida ganada. El motor (Parte 1) lo produce,
/// el almacenamiento (Parte 2) lo guarda.
class GameResult {
  const GameResult({
    required this.difficulty,
    required this.time,
    required this.moves,
    required this.date,
  });
  final Difficulty difficulty;
  final Duration time;
  final int moves;
  final DateTime date;
}

/// Mejor registro por dificultad.
class HighScore {
  const HighScore({
    required this.bestTime,
    required this.bestMoves,
    required this.date,
  });
  final Duration bestTime;
  final int bestMoves;
  final DateTime date; // fecha del mejor tiempo

  Map<String, dynamic> toJson() => {
        'ms': bestTime.inMilliseconds,
        'moves': bestMoves,
        'date': date.toIso8601String(),
      };

  factory HighScore.fromJson(Map<String, dynamic> j) => HighScore(
        bestTime: Duration(milliseconds: j['ms'] as int),
        bestMoves: j['moves'] as int,
        date: DateTime.parse(j['date'] as String),
      );
}
