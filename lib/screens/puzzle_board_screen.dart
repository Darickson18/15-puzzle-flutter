import 'package:flutter/material.dart';
import '../models/difficulty.dart';
import '../models/game_result.dart';

/// STUB TEMPORAL (lo escribe la Parte 2 para que el proyecto compile y corra).
/// El compañero de la Parte 1 REEMPLAZA este archivo con el tablero real.
/// La firma (nombre de la clase y parámetros) debe mantenerse igual.
class PuzzleBoardScreen extends StatelessWidget {
  const PuzzleBoardScreen({
    super.key,
    required this.difficulty,
    this.isColorfulMode = false,
    this.onWin,
  });

  final Difficulty difficulty;
  final bool isColorfulMode;

  /// Guarda el resultado y devuelve true si es récord.
  final Future<bool> Function(GameResult result)? onWin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tablero ${difficulty.label} (${difficulty.size})')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Aquí irá el tablero (Parte 1)'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                final rec = await onWin?.call(GameResult(
                  difficulty: difficulty,
                  time: const Duration(seconds: 75),
                  moves: 60,
                  date: DateTime.now(),
                ));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(rec == true ? 'Récord guardado' : 'Sin récord nuevo')));
              },
              child: const Text('Simular victoria (solo prueba)'),
            ),
          ],
        ),
      ),
    );
  }
}
