import '../models/difficulty.dart';

class PuzzleLogic {
  final int rows;
  final int cols;
  List<int> tiles = [];
  int moves = 0;

  // Constructor que acepta la dificultad o dimensiones personalizadas
  PuzzleLogic({required this.rows, required this.cols}) {
    _initializeBoard();
  }

  // Constructor rápido basado en la dificultad
  factory PuzzleLogic.fromDifficulty(Difficulty difficulty) {
    return PuzzleLogic(rows: difficulty.rows, cols: difficulty.cols);
  }

  // Genera el tablero ordenado del 1 al N, con 0 al final (espacio vacío)
  void _initializeBoard() {
    int totalTiles = rows * cols;
    tiles = List.generate(totalTiles - 1, (index) => index + 1);
    tiles.add(0);
  }

  // Desordena el tablero garantizando matemáticamente que sea resoluble
  void shuffleBoard() {
    tiles.shuffle();
    
    // Si la combinación generada no tiene solución, o si por casualidad 
    // quedó armada, la volvemos a desordenar.
    while (!isSolvable() || isSolved()) {
      tiles.shuffle();
    }
    moves = 0;
  }

  // Verifica la paridad de inversiones para garantizar la solubilidad
  bool isSolvable() {
    int inversions = 0;
    List<int> tilesWithoutZero = tiles.where((t) => t != 0).toList();

    // Contar inversiones (cuántas veces un número mayor precede a uno menor)
    for (int i = 0; i < tilesWithoutZero.length - 1; i++) {
      for (int j = i + 1; j < tilesWithoutZero.length; j++) {
        if (tilesWithoutZero[i] > tilesWithoutZero[j]) {
          inversions++;
        }
      }
    }

    int emptyIndex = tiles.indexOf(0);
    int emptyRowFromBottom = rows - (emptyIndex ~/ cols);

    if (cols % 2 != 0) {
      // Para cuadrículas de ancho impar (3x3, 5x5)
      return inversions % 2 == 0;
    } else {
      // Para cuadrículas de ancho par (4x4)
      if (emptyRowFromBottom % 2 != 0) {
        return inversions % 2 == 0;
      } else {
        return inversions % 2 != 0;
      }
    }
  }

  // Ejecuta el movimiento si la pieza tocada es adyacente al espacio vacío (0)
  bool moveTile(int index) {
    int emptyIndex = tiles.indexOf(0);
    
    int tileRow = index ~/ cols;
    int tileCol = index % cols;
    int emptyRow = emptyIndex ~/ cols;
    int emptyCol = emptyIndex % cols;

    bool isAdjacent = (tileRow == emptyRow && (tileCol - emptyCol).abs() == 1) ||
                      (tileCol == emptyCol && (tileRow - emptyRow).abs() == 1);

    if (isAdjacent) {
      tiles[emptyIndex] = tiles[index];
      tiles[index] = 0;
      moves++;
      return true;
    }
    return false;
  }
  
  // Comprueba si el jugador ha ganado
  bool isSolved() {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i + 1) return false;
    }
    return tiles.last == 0;
  }
}