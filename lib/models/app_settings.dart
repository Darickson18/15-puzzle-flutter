import 'package:flutter/material.dart';
import 'difficulty.dart';

enum TileStyle {
  numbers('Números'),
  colorful('Colores'),
  minimal('Minimalista');

  const TileStyle(this.label);
  final String label;
}

class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.difficulty = Difficulty.medium,
    this.tileStyle = TileStyle.numbers,
    this.soundOn = true,
  });
  final ThemeMode themeMode;
  final Difficulty difficulty;
  final TileStyle tileStyle;
  final bool soundOn;

  AppSettings copyWith({
    ThemeMode? themeMode,
    Difficulty? difficulty,
    TileStyle? tileStyle,
    bool? soundOn,
  }) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        difficulty: difficulty ?? this.difficulty,
        tileStyle: tileStyle ?? this.tileStyle,
        soundOn: soundOn ?? this.soundOn,
      );
}
