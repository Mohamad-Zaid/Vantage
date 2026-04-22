import 'package:flutter/material.dart';

import '../cubits/app_settings_cubit.dart';

class AppSettingsScope extends InheritedWidget {
  const AppSettingsScope({
    super.key,
    required this.cubit,
    required super.child,
  });

  final AppSettingsCubit cubit;

  static AppSettingsCubit of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'AppSettingsScope not found. Wrap app with AppSettingsScope.');
    return scope!.cubit;
  }

  @override
  bool updateShouldNotify(AppSettingsScope oldWidget) => cubit != oldWidget.cubit;
}
