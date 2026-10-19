import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../logic/puzzle_logic.dart';
import '../models/difficulty.dart';
import '../models/game_result.dart';

class PuzzleBoardScreen extends StatefulWidget {
  final Difficulty difficulty;
  final bool isColorfulMode;

  /// Guarda el resultado y devuelve true si es récord.
  final Future<bool> Function(GameResult result)? onWin;

  const PuzzleBoardScreen({
    super.key,
    required this.difficulty,
    this.isColorfulMode = false,
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
  bool _hasWon = false;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    _timer?.cancel();
    logic = PuzzleLogic.fromDifficulty(widget.difficulty);
    logic.shuffleBoard();
    _secondsElapsed = 0;
    _isPlaying = false;
    _hasWon = false;
  }

  void _startTimer() {
    if (_isPlaying || _hasWon) return;

    _isPlaying = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _stopTimer() {
    _isPlaying = false;
    _timer?.cancel();
    _timer = null;
  }

  void _handleTileTap(int currentIndex) {
    if (_hasWon || logic.tiles[currentIndex] == 0) return;

    final moved = logic.moveTile(currentIndex);
    if (!moved) return;

    setState(() {});

    _startTimer();

    if (logic.isSolved()) {
      _hasWon = true;
      _stopTimer();
      _handleWin();
    }
  }

  Future<void> _handleWin() async {
    _stopTimer();

    bool isRecord = false;

    try {
      isRecord = await widget.onWin?.call(
            GameResult(
              difficulty: widget.difficulty,
              time: Duration(seconds: _secondsElapsed),
              moves: logic.moves,
              date: DateTime.now(),
            ),
          ) ??
          false;
    } catch (error, stackTrace) {
      debugPrint('Error al guardar el resultado: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    if (!mounted) return;
    _showVictoryDialog(isRecord);
  }

  void _showVictoryDialog(bool isRecord) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Victoria',
      pageBuilder: (dialogContext, anim1, anim2) {
        return AlertDialog(
          title: const Text(
            '¡Ganaste!',
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Tiempo: $_secondsElapsed seg\n'
            'Movimientos: ${logic.moves}\n'
            'Dificultad: ${widget.difficulty.label}'
            '${isRecord ? '\n¡Nuevo récord!' : ''}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Salir al Menú'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                setState(_initGame);
              },
              child: const Text('Reiniciar'),
            ),
          ],
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(anim1),
          child: FadeTransition(
            opacity: anim1,
            child: child,
          ),
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

  Color _getTileColor(int tileValue) {
    if (!widget.isColorfulMode) {
      return Theme.of(context).primaryColor;
    }

    const palette = Colors.primaries;
    return palette[tileValue % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('15-Puzzle Flutter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reiniciar partida',
            onPressed: () {
              setState(_initGame);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('Movimientos', '${logic.moves}'),
                _buildStatCard('Tiempo', '${_secondsElapsed}s'),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tileSize = math.min(
                  constraints.maxWidth * 0.9 / logic.cols,
                  constraints.maxHeight * 0.9 / logic.rows,
                );

                return Center(
                  child: SizedBox(
                    width: tileSize * logic.cols,
                    height: tileSize * logic.rows,
                    child: Stack(
                      children: List.generate(
                        logic.rows * logic.cols - 1,
                        (index) {
                          final tileValue = index + 1;
                          final currentIndex =
                              logic.tiles.indexOf(tileValue);

                          if (currentIndex < 0) {
                            return const SizedBox.shrink();
                          }

                          final row = currentIndex ~/ logic.cols;
                          final col = currentIndex % logic.cols;

                          return AnimatedPositioned(
                            key: ValueKey(tileValue),
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutQuad,
                            top: row * tileSize,
                            left: col * tileSize,
                            width: tileSize,
                            height: tileSize,
                            child: GestureDetector(
                              onTap: () => _handleTileTap(currentIndex),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _getTileColor(tileValue),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$tileValue',
                                      style: TextStyle(
                                        fontSize: tileSize * 0.35,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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

  Widget _buildStatCard(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
