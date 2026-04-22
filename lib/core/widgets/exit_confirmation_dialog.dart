import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';

Future<bool> showExitConfirmationDialog(BuildContext context) async {
  final shouldExit = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(LocaleKeys.common_exitAppTitle.tr()),
        content: Text(LocaleKeys.common_exitAppMessage.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(LocaleKeys.common_cancel.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(LocaleKeys.common_exit.tr()),
          ),
        ],
      );
    },
  );

  return shouldExit ?? false;
}
