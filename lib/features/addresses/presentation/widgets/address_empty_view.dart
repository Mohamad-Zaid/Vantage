import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/features/addresses/presentation/cubit/addresses_cubit.dart';

class AddressEmptyView extends StatelessWidget {
  const AddressEmptyView({super.key, required this.mutedColor});

  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<AddressesCubit>().refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.4,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Text(
                LocaleKeys.address_empty.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: mutedColor,
                  fontSize: 15,
                  height: 1.35,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
