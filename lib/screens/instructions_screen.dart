import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('Objetivo', 'Ordena las fichas de menor a mayor, dejando el espacio vacío al final.'),
      ('Cómo mover', 'Toca una ficha adyacente al espacio vacío para deslizarla.'),
      ('Dificultad', 'Fácil 2x3, Medio 4x4 y Difícil 5x5. Cámbiala en Configuración.'),
      ('Marcadores', 'Se guarda tu mejor tiempo y tu menor número de movimientos por nivel.'),
      ('Consejo', 'Resuelve primero la fila superior, luego la siguiente, y deja las últimas filas para el final.'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Instrucciones')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (var i = 0; i < steps.length; i++)
                Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${i + 1}')),
                    title: Text(steps[i].$1),
                    subtitle: Text(steps[i].$2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
