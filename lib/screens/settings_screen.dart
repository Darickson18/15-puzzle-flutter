import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_settings.dart';
import '../models/difficulty.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<SettingsProvider>();
    final s = p.settings;
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _Title('Dificultad'),
              SegmentedButton<Difficulty>(
                segments: [
                  for (final d in Difficulty.values)
                    ButtonSegment(
                        value: d,
                        label: Text('${d.label}\n${d.size}',
                            textAlign: TextAlign.center)),
                ],
                selected: {s.difficulty},
                onSelectionChanged: (v) =>
                    p.update(s.copyWith(difficulty: v.first)),
              ),
              const _Title('Tema'),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Claro'),
                      icon: Icon(Icons.light_mode)),
                  ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Oscuro'),
                      icon: Icon(Icons.dark_mode)),
                  ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('Auto'),
                      icon: Icon(Icons.brightness_auto)),
                ],
                selected: {s.themeMode},
                onSelectionChanged: (v) =>
                    p.update(s.copyWith(themeMode: v.first)),
              ),
              const _Title('Estilo de fichas'),
              SegmentedButton<TileStyle>(
                segments: [
                  for (final t in TileStyle.values)
                    ButtonSegment(value: t, label: Text(t.label)),
                ],
                selected: {s.tileStyle},
                onSelectionChanged: (v) =>
                    p.update(s.copyWith(tileStyle: v.first)),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Sonido'),
                value: s.soundOn,
                onChanged: (v) => p.update(s.copyWith(soundOn: v)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      );
}
