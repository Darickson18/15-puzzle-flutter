import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/difficulty.dart';
import '../providers/scores_provider.dart';
import '../utils/format.dart';

class ScoresScreen extends StatelessWidget {
  const ScoresScreen({super.key});

  Future<void> _confirmClear(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Borrar historial'),
        content: const Text('Se eliminarán todos los récords. ¿Continuar?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Borrar')),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await context.read<ScoresProvider>().clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scores = context.watch<ScoresProvider>().scores;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marcadores'),
        actions: [
          IconButton(
            tooltip: 'Borrar historial',
            icon: const Icon(Icons.delete_outline),
            onPressed: scores.isEmpty ? null : () => _confirmClear(context),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final d in Difficulty.values)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${d.label} (${d.size})',
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          if (scores[d] == null)
                            const Text('Sin registros')
                          else ...[
                            _Row(Icons.timer_outlined, 'Mejor tiempo',
                                formatDuration(scores[d]!.bestTime)),
                            _Row(Icons.touch_app_outlined, 'Menos movimientos',
                                '${scores[d]!.bestMoves}'),
                            _Row(Icons.calendar_today_outlined, 'Fecha',
                                formatDate(scores[d]!.date)),
                          ],
                        ]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.icon, this.label, this.value);
  final IconData icon;
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
      );
}
