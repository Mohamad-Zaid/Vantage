import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_circle_back_button.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';
import 'package:vantage/features/addresses/domain/entities/address_entity.dart';
import 'package:vantage/features/addresses/presentation/cubit/addresses_cubit.dart';
import 'package:vantage/features/addresses/presentation/cubit/addresses_state.dart';
import 'package:vantage/router/app_router.dart';

@RoutePage()
class AddressListPage extends StatelessWidget {
  const AddressListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    final cardBg =
        isDark ? VantageColors.authBgDark2 : VantageColors.homeAudiencePillLight;
    final bodyColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    final mutedBody = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : VantageColors.homeCategoryLabelLight.withValues(alpha: 0.55);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Row(
                children: [
                  VantageCircleBackButton(
                    onPressed: () => context.router.maybePop(),
                  ),
                  Expanded(
                    child: Text(
                      LocaleKeys.address_title.tr(),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.gabarito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<AddressesCubit, AddressesState>(
                builder: (context, state) {
                  return switch (state) {
                    AddressesInitial() ||
                    AddressesLoading() =>
                      const Center(child: VantageLoadingIndicator()),
                    AddressesError(:final message) => RefreshIndicator(
                        onRefresh: () =>
                            context.read<AddressesCubit>().refresh(),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.35,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Text(
                                  '${LocaleKeys.common_error.tr()}\n$message',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: titleColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    AddressesLoaded(:final addresses) when addresses.isEmpty =>
                      RefreshIndicator(
                        onRefresh: () =>
                            context.read<AddressesCubit>().refresh(),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.4,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                child: Text(
                                  LocaleKeys.address_empty.tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: mutedBody,
                                    fontSize: 15,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    AddressesLoaded(:final addresses) => RefreshIndicator(
                        onRefresh: () =>
                            context.read<AddressesCubit>().refresh(),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                          itemCount: addresses.length,
                          itemBuilder: (context, index) {
                          final a = addresses[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index < addresses.length - 1 ? 12 : 0,
                            ),
                            child: Dismissible(
                              key: ValueKey<String>('address_${a.id}'),
                              direction: DismissDirection.startToEnd,
                              confirmDismiss: (direction) async {
                                final ok = await context
                                    .read<AddressesCubit>()
                                    .deleteAddress(a.id);
                                if (!context.mounted) return false;
                                if (!ok) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        LocaleKeys.address_deleteFailed.tr(),
                                      ),
                                    ),
                                  );
                                }
                                return ok;
                              },
                              background: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                  color: VantageColors.error
                                      .withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.delete_outline_rounded,
                                  color: Theme.of(context).colorScheme.onError,
                                ),
                              ),
                              child: _AddressCard(
                                address: a,
                                cardBg: cardBg,
                                bodyColor: bodyColor,
                                onEdit: () => context.router.push(
                                  AddressFormRoute(addressId: a.id),
                                ),
                              ),
                            ),
                          );
                          },
                        ),
                      ),
                    AddressesNeedSignIn() => Center(
                        child: Text(
                          LocaleKeys.address_empty.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: mutedBody),
                        ),
                      ),
                  };
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.router.push(AddressFormRoute()),
                  style: FilledButton.styleFrom(
                    backgroundColor: VantageColors.authPrimaryPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: Text(
                    LocaleKeys.address_addNew.tr(),
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.cardBg,
    required this.bodyColor,
    required this.onEdit,
  });

  final AddressEntity address;
  final Color cardBg;
  final Color bodyColor;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onEdit,
        child: SizedBox(
          height: 72,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      address.singleLinePreview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: bodyColor,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onEdit,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: VantageColors.authPrimaryPurple,
                  ),
                  child: Text(
                    LocaleKeys.address_edit.tr(),
                    style: GoogleFonts.gabarito(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
