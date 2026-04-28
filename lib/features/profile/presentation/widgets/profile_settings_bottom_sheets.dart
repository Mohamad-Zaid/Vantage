import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:vantage/core/cubits/app_settings_cubit.dart';
import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/filter_option_tile.dart';
import 'package:vantage/core/widgets/filter_sheet_header.dart';

void showProfileThemeSheet(BuildContext context, AppSettingsCubit cubit) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final isDark = Theme.of(sheetContext).brightness == Brightness.dark;
      final sheetBg = isDark ? VantageColors.authBgDark1 : Colors.white;
      final current = cubit.themeMode;
      return Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilterSheetHeader(
                  title: LocaleKeys.settings_theme.tr(),
                  showClear: false,
                  onClose: () => Navigator.of(sheetContext).pop(),
                ),
                const SizedBox(height: AppSpacing.xl),
                FilterOptionTile(
                  label: LocaleKeys.settings_themeSystem.tr(),
                  selected: current == ThemeMode.system,
                  onTap: () {
                    cubit.setThemeMode(ThemeMode.system);
                    Navigator.of(sheetContext).pop();
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                FilterOptionTile(
                  label: LocaleKeys.settings_themeLight.tr(),
                  selected: current == ThemeMode.light,
                  onTap: () {
                    cubit.setThemeMode(ThemeMode.light);
                    Navigator.of(sheetContext).pop();
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                FilterOptionTile(
                  label: LocaleKeys.settings_themeDark.tr(),
                  selected: current == ThemeMode.dark,
                  onTap: () {
                    cubit.setThemeMode(ThemeMode.dark);
                    Navigator.of(sheetContext).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void showProfileLanguageSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final isDark = Theme.of(sheetContext).brightness == Brightness.dark;
      final sheetBg = isDark ? VantageColors.authBgDark1 : Colors.white;
      final loc = sheetContext.locale;
      return Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilterSheetHeader(
                  title: LocaleKeys.settings_translation.tr(),
                  showClear: false,
                  onClose: () => Navigator.of(sheetContext).pop(),
                ),
                const SizedBox(height: AppSpacing.xl),
                FilterOptionTile(
                  label: 'English',
                  selected: loc.languageCode == 'en',
                  onTap: () {
                    sheetContext.setLocale(const Locale('en'));
                    Navigator.of(sheetContext).pop();
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                FilterOptionTile(
                  label: 'العربية',
                  selected: loc.languageCode == 'ar',
                  onTap: () {
                    sheetContext.setLocale(const Locale('ar'));
                    Navigator.of(sheetContext).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
