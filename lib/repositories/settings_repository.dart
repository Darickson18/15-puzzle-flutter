import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';
import '../models/difficulty.dart';

abstract class SettingsRepository {
  Future<AppSettings> load();
  Future<void> save(AppSettings settings);
}

class InMemorySettingsRepository implements SettingsRepository {
  AppSettings _s = const AppSettings();
  @override
  Future<AppSettings> load() async => _s;
  @override
  Future<void> save(AppSettings settings) async => _s = settings;
}

class PrefsSettingsRepository implements SettingsRepository {
  PrefsSettingsRepository(this._prefs);
  final SharedPreferences _prefs;

  static T _enum<T>(List<T> values, int? i, T fallback) =>
      (i != null && i >= 0 && i < values.length) ? values[i] : fallback;

  @override
  Future<AppSettings> load() async => AppSettings(
        themeMode:
            _enum(ThemeMode.values, _prefs.getInt('theme'), ThemeMode.system),
        difficulty: _enum(
            Difficulty.values, _prefs.getInt('difficulty'), Difficulty.medium),
        tileStyle:
            _enum(TileStyle.values, _prefs.getInt('tileStyle'), TileStyle.numbers),
        soundOn: _prefs.getBool('sound') ?? true,
      );

  @override
  Future<void> save(AppSettings s) async {
    await _prefs.setInt('theme', s.themeMode.index);
    await _prefs.setInt('difficulty', s.difficulty.index);
    await _prefs.setInt('tileStyle', s.tileStyle.index);
    await _prefs.setBool('sound', s.soundOn);
  }
}
