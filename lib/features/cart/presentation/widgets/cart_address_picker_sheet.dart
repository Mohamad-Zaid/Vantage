import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/filter_option_tile.dart';
import 'package:vantage/core/widgets/filter_sheet_header.dart';
import 'package:vantage/features/addresses/domain/entities/address_entity.dart';
import 'package:vantage/router/app_router.dart';

void showCartAddressPickerSheet(
  BuildContext context, {
  required List<AddressEntity> addresses,
  required String? currentlySelectedId,
  required void Function(String addressId) onPick,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final isDark = Theme.of(ctx).brightness == Brightness.dark;
      final sheetBg = isDark ? VantageColors.authBgDark1 : Colors.white;
      final scheme = Theme.of(ctx).colorScheme;
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(ctx).bottom,
        ),
        child: Container(
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilterSheetHeader(
                    title: LocaleKeys.cart_shippingAddress.tr(),
                    showClear: false,
                    onClose: () => Navigator.of(ctx).pop(),
                  ),
                  const SizedBox(height: 24),
                  for (var i = 0; i < addresses.length; i++) ...[
                    if (i > 0) const SizedBox(height: 16),
                    FilterOptionTile(
                      label: addresses[i].singleLinePreview,
                      selected: currentlySelectedId == addresses[i].id,
                      maxLines: 2,
                      onTap: () {
                        onPick(addresses[i].id);
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  _AddAddressRow(
                    onTap: () {
                      Navigator.of(ctx).pop();
                      context.router.push(AddressFormRoute());
                    },
                    isDark: isDark,
                    primary: scheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _AddAddressRow extends StatelessWidget {
  const _AddAddressRow({
    required this.onTap,
    required this.isDark,
    required this.primary,
  });

  final VoidCallback onTap;
  final bool isDark;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark
          ? VantageColors.authBgDark2
          : VantageColors.homeAudiencePillLight,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.add_circle_outline_rounded, color: primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    LocaleKeys.address_addNew.tr(),
                    style: GoogleFonts.nunitoSans(
                      color: primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
