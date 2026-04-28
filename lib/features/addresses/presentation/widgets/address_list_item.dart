import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/features/addresses/domain/entities/address_entity.dart';

class AddressListItem extends StatelessWidget {
  const AddressListItem({
    super.key,
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
      borderRadius: BorderRadius.circular(AppSpacing.sm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onEdit,
        child: SizedBox(
          height: AppSpacing.denseListRowHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.inset17,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(child: _AddressPreviewText(address: address, color: bodyColor)),
                _EditButton(onPressed: onEdit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddressPreviewText extends StatelessWidget {
  const _AddressPreviewText({required this.address, required this.color});

  final AddressEntity address;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        address.singleLinePreview,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: color,
          height: 1.2,
        ),
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: VantageColors.authPrimaryPurple,
      ),
      child: Text(
        LocaleKeys.address_edit.tr(),
        style: GoogleFonts.gabarito(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}
