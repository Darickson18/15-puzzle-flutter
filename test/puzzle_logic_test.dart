import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle15/logic/puzzle_logic.dart';
import 'package:puzzle15/models/difficulty.dart';

void _permutations(List<int> items, int k, void Function(List<int>) visit) {
  if (k == items.length) {
    visit(List.of(items));
    return;
  }
  for (var i = k; i < items.length; i++) {
    final t = items[k]; items[k] = items[i]; items[i] = t;
    _permutations(items, k + 1, visit);
    final u = items[k]; items[k] = items[i]; items[i] = u;
  }
}

void main() {
  test('2x3: exactamente la mitad de las 720 permutaciones es resoluble', () {
    final l = PuzzleLogic(rows: 2, cols: 3);
    var solvable = 0, total = 0;
    _permutations([1, 2, 3, 4, 5, 0], 0, (p) {
      l.tiles = p;
      total++;
      if (l.isSolvable()) solvable++;
    });
    expect(total, 720);
    expect(solvable, 360);
  });

  for (final d in Difficulty.values) {
    test('${d.label} ${d.size}: mover fichas conserva la resolubilidad', () {
      final l = PuzzleLogic.fromDifficulty(d);
      expect(l.isSolved(), isTrue);
      final rnd = math.Random(1);
      for (var i = 0; i < 500; i++) {
        while (!l.moveTile(rnd.nextInt(l.tiles.length))) {}
        expect(l.isSolvable(), isTrue);
      }
    });

    test('${d.label}: shuffleBoard es resoluble y no queda armado', () {
      final l = PuzzleLogic.fromDifficulty(d);
      for (var i = 0; i < 100; i++) {
        l.shuffleBoard();
        expect(l.isSolvable(), isTrue);
        expect(l.isSolved(), isFalse);
        expect(l.moves, 0);
      }
    });
  }
}
