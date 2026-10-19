<<<<<<< HEAD
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../logic/puzzle_logic.dart';
import '../models/difficulty.dart';
import '../models/game_result.dart'; 

class PuzzleBoardScreen extends StatefulWidget {
  final Difficulty difficulty;
  final bool isColorfulMode;

  /// Se llama al ganar. Debe guardar el resultado y devolver true si es récord.
  final Future<bool> Function(GameResult result)? onWin;

  const PuzzleBoardScreen({
    super.key, 
    required this.difficulty, 
    this.isColorfulMode = false, // Clásico por defecto
    this.onWin,
  });

  @override
  State<PuzzleBoardScreen> createState() => _PuzzleBoardScreenState();
}

class _PuzzleBoardScreenState extends State<PuzzleBoardScreen> {
  late PuzzleLogic logic;
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    logic = PuzzleLogic.fromDifficulty(widget.difficulty);
    logic.shuffleBoard();
    _secondsElapsed = 0;
    _isPlaying = false;
    _timer?.cancel();
  }

  void _startTimer() {
    if (_isPlaying) return;
    _isPlaying = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _stopTimer() {
    _isPlaying = false;
    _timer?.cancel();
  }

  void _handleTileTap(int currentIndex) {
    if (logic.tiles[currentIndex] == 0) return;

    setState(() {
      bool moved = logic.moveTile(currentIndex);
      if (moved) {
        _startTimer();
        
        if (logic.isSolved()) {
          _stopTimer();
          _handleWin();
        }
      }
    });
  }

  Future<void> _handleWin() async {
    _stopTimer();
    // Guarda el resultado (si la pantalla recibió onWin) y averigua si es récord.
    final isRecord = await widget.onWin?.call(GameResult(
          difficulty: widget.difficulty,
          time: Duration(seconds: _secondsElapsed),
          moves: logic.moves,
          date: DateTime.now(),
        )) ??
        false;
    if (mounted) _showVictoryDialog(isRecord);
  }

  void _showVictoryDialog(bool isRecord) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Victoria',
      pageBuilder: (context, anim1, anim2) {
        return AlertDialog(
          title: const Text("¡Ganaste!", textAlign: TextAlign.center),
          content: Text(
            "Tiempo: $_secondsElapsed seg\n"
            "Movimientos: ${logic.moves}\n"
            "Dificultad: ${widget.difficulty.label}"
            "${isRecord ? '\n¡Nuevo récord!' : ''}",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                final nav = Navigator.of(context);
                nav.pop(); // Cierra diálogo
                nav.pop(); // Vuelve al menú
              },
              child: const Text("Salir al Menú"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _initGame());
              },
              child: const Text("Reiniciar"),
            ),
          ],
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(anim1),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Método para obtener colores variados si está en modo colorido
  Color _getTileColor(int tileValue) {
    if (!widget.isColorfulMode) return Theme.of(context).primaryColor;
    List<Color> palette = Colors.primaries;
    return palette[tileValue % palette.length];
  }
=======
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
>>>>>>> a50cdae274e39b28f1e1a3eb784a7f56113a720d

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(
        title: const Text('15-Puzzle Flutter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _initGame()),
            tooltip: 'Reiniciar partida',
          )
        ],
      ),
      body: Column(
        children: [
          // Marcadores en tiempo real
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard("Movimientos", "${logic.moves}"),
                _buildStatCard("Tiempo", "${_secondsElapsed}s"),
              ],
            ),
          ),
          
          // Tablero Animado y Responsivo
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Cálculo responsivo del tamaño del tablero
                final double tileSize = math.min(
                  constraints.maxWidth * 0.9 / logic.cols,
                  constraints.maxHeight * 0.9 / logic.rows,
                );

                return Center(
                  child: SizedBox(
                    width: tileSize * logic.cols,
                    height: tileSize * logic.rows,
                    child: Stack(
                      // Generamos los widgets basándonos en los valores (1 hasta N)
                      children: List.generate(logic.rows * logic.cols - 1, (index) {
                        int tileValue = index + 1; // El valor de la pieza (1, 2, 3...)
                        int currentIndex = logic.tiles.indexOf(tileValue); // Su posición actual en el arreglo
                        
                        // Calculamos fila y columna actual para animar hacia allí
                        int row = currentIndex ~/ logic.cols;
                        int col = currentIndex % logic.cols;

                        return AnimatedPositioned(
                          key: ValueKey(tileValue), // Clave única vital para que Flutter anime el movimiento
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutQuad,
                          top: row * tileSize,
                          left: col * tileSize,
                          width: tileSize,
                          height: tileSize,
                          child: GestureDetector(
                            onTap: () => _handleTileTap(currentIndex),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _getTileColor(tileValue),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(2, 2),
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '$tileValue',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para mejorar el diseño de los contadores
  Widget _buildStatCard(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
=======
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
>>>>>>> a50cdae274e39b28f1e1a3eb784a7f56113a720d
