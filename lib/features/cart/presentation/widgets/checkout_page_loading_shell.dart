import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/widgets/vantage_circle_back_button.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';

class CheckoutPageLoadingShell extends StatelessWidget {
  const CheckoutPageLoadingShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.sm,
                0,
              ),
              child: Row(
                children: [
                  VantageCircleBackButton(
                    onPressed: () => context.router.maybePop(),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Center(child: VantageLoadingIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
