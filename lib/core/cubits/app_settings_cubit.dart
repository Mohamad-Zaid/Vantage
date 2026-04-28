import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeKey = 'app_theme_mode';

final class AppSettingsCubit {
  AppSettingsCubit({SharedPreferences? prefs})
      : _prefs = prefs,
        _themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);

  SharedPreferences? _prefs;
  final ValueNotifier<ThemeMode> _themeMode;

  ThemeMode get themeMode => _themeMode.value;
  ValueNotifier<ThemeMode> get themeModeNotifier => _themeMode;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    final index = _prefs!.getInt(_themeKey);
    if (index != null && index >= 0 && index < ThemeMode.values.length) {
      _themeMode.value = ThemeMode.values[index];
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;
    await _prefs?.setInt(_themeKey, mode.index);
  }
}
