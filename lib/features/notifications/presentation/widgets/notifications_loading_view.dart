import 'package:flutter/material.dart';

import 'package:vantage/core/widgets/vantage_loading_indicator.dart';

class NotificationsLoadingView extends StatelessWidget {
  const NotificationsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: VantageLoadingIndicator());
  }
}
