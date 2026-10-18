import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, IconData, String)>[
      ('Jugar', Icons.play_arrow_rounded, '/game'),
      ('Marcadores', Icons.emoji_events_outlined, '/scores'),
      ('Configuración', Icons.settings_outlined, '/settings'),
      ('Instrucciones', Icons.help_outline, '/instructions'),
    ];
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('15-Puzzle',
                      style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 32),
                  for (final (label, icon, route) in items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton.icon(
                          icon: Icon(icon),
                          label: Text(label),
                          onPressed: () => Navigator.pushNamed(context, route),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
