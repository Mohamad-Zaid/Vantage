import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';
import 'package:vantage/features/addresses/domain/entities/address_entity.dart';
import 'package:vantage/features/addresses/presentation/cubit/addresses_cubit.dart';
import 'package:vantage/features/addresses/presentation/cubit/addresses_state.dart';
import 'package:vantage/features/addresses/presentation/widgets/address_dismiss_background.dart';
import 'package:vantage/features/addresses/presentation/widgets/address_empty_view.dart';
import 'package:vantage/features/addresses/presentation/widgets/address_error_view.dart';
import 'package:vantage/features/addresses/presentation/widgets/address_list_item.dart';
import 'package:vantage/router/app_router.dart';

class AddressListContent extends StatelessWidget {
  const AddressListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : VantageColors.homeCategoryLabelLight.withValues(alpha: 0.55);
    return BlocBuilder<AddressesCubit, AddressesState>(
      builder: (context, state) => switch (state) {
        AddressesInitial() || AddressesLoading() =>
          const Center(child: VantageLoadingIndicator()),
        AddressesError(:final message) => AddressErrorView(message: message),
        AddressesLoaded(:final addresses) when addresses.isEmpty =>
          AddressEmptyView(mutedColor: mutedColor),
        AddressesLoaded(:final addresses) =>
          _AddressLoadedList(addresses: addresses),
        AddressesNeedSignIn() => AddressEmptyView(mutedColor: mutedColor),
      },
    );
  }
}

class _AddressLoadedList extends StatelessWidget {
  const _AddressLoadedList({required this.addresses});

  final List<AddressEntity> addresses;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<AddressesCubit>().refresh(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
        ),
        itemCount: addresses.length,
        itemBuilder: (context, index) => _AddressListTile(
          address: addresses[index],
          isLast: index == addresses.length - 1,
        ),
      ),
    );
  }
}

class _AddressListTile extends StatelessWidget {
  const _AddressListTile({required this.address, required this.isLast});

  final AddressEntity address;
  final bool isLast;

  Future<bool?> _confirmDelete(BuildContext context) async {
    final ok = await context.read<AddressesCubit>().deleteAddress(address.id);
    if (!context.mounted) return false;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.address_deleteFailed.tr())),
      );
    }
    return ok;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg =
        isDark ? VantageColors.authBgDark2 : VantageColors.homeAudiencePillLight;
    final bodyColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
      child: Dismissible(
        key: ValueKey<String>('address_${address.id}'),
        direction: DismissDirection.startToEnd,
        confirmDismiss: (_) => _confirmDelete(context),
        background: const AddressDismissBackground(),
        child: AddressListItem(
          address: address,
          cardBg: cardBg,
          bodyColor: bodyColor,
          onEdit: () =>
              context.router.push(AddressFormRoute(addressId: address.id)),
        ),
      ),
    );
  }
}
