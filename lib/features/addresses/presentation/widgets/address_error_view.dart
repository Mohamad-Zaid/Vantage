import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/features/addresses/presentation/cubit/addresses_cubit.dart';

class AddressErrorView extends StatelessWidget {
  const AddressErrorView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<AddressesCubit>().refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.35,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
              ),
              child: Text(
                '${LocaleKeys.common_error.tr()}\n$message',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
