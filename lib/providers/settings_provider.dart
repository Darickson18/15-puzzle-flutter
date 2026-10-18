import 'package:flutter/foundation.dart';
import '../models/app_settings.dart';
import '../repositories/settings_repository.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._repo);
  final SettingsRepository _repo;
  AppSettings _settings = const AppSettings();
  AppSettings get settings => _settings;

  Future<void> load() async {
    _settings = await _repo.load();
    notifyListeners();
  }

  Future<void> update(AppSettings s) async {
    _settings = s;
    notifyListeners();
    await _repo.save(s);
  }
}
