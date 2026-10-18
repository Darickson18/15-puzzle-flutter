/// Contrato compartido con la Parte 1 (motor del juego).
enum Difficulty {
  easy(2, 3, 'Fácil'),
  medium(4, 4, 'Medio'),
  hard(5, 5, 'Difícil');

  const Difficulty(this.rows, this.cols, this.label);
  final int rows;
  final int cols;
  final String label;
  String get size => '${rows}x$cols';
}
