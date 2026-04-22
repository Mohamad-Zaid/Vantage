import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/widgets/filter_sheet_header.dart';

typedef PriceRange = ({double? min, double? max});

Future<PriceRange?> showPriceBottomSheet(
    BuildContext context, PriceRange current) async {
  final result = await showModalBottomSheet<({PriceRange? range, bool cleared})>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _PriceBottomSheet(current: current),
  );
  if (result == null) return current;
  if (result.cleared) return (min: null, max: null);
  return result.range;
}

class _PriceBottomSheet extends StatefulWidget {
  const _PriceBottomSheet({required this.current});

  final PriceRange current;

  @override
  State<_PriceBottomSheet> createState() => _PriceBottomSheetState();
}

class _PriceBottomSheetState extends State<_PriceBottomSheet> {
  late final TextEditingController _minCtrl;
  late final TextEditingController _maxCtrl;

  @override
  void initState() {
    super.initState();
    _minCtrl = TextEditingController(
      text: widget.current.min?.toStringAsFixed(0) ?? '',
    );
    _maxCtrl = TextEditingController(
      text: widget.current.max?.toStringAsFixed(0) ?? '',
    );
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final min = double.tryParse(_minCtrl.text.trim());
    final max = double.tryParse(_maxCtrl.text.trim());
    Navigator.pop(
      context,
      (range: (min: min, max: max) as PriceRange?, cleared: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scheme = theme.colorScheme;
    final primary = scheme.primary;
    final onPrimary = scheme.onPrimary;
    final sheetBg = isDark ? VantageColors.authBgDark1 : Colors.white;
    final titleColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    final fieldBg =
        isDark ? VantageColors.authBgDark2 : VantageColors.homeAudiencePillLight;
    final hintColor = isDark
        ? Colors.white.withValues(alpha: 0.5)
        : VantageColors.homeCategoryLabelLight.withValues(alpha: 0.5);

    final fieldDecoration = InputDecoration(
      filled: true,
      fillColor: fieldBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: BorderSide(color: primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 34, vertical: 16),
    );

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
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
              children: [
                FilterSheetHeader(
                  title: 'Price',
                  onClear: () => Navigator.pop(
                      context,
                      (
                        range: (min: null, max: null) as PriceRange?,
                        cleared: true
                      )),
                  onClose: () => Navigator.pop(context, null),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  child: TextField(
                    controller: _minCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*')),
                    ],
                    cursorColor: primary,
                    style: GoogleFonts.nunitoSans(
                      color: titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: fieldDecoration.copyWith(
                      hintText: 'Min',
                      hintStyle: GoogleFonts.nunitoSans(
                        color: hintColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 56,
                  child: TextField(
                    controller: _maxCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*')),
                    ],
                    cursorColor: primary,
                    style: GoogleFonts.nunitoSans(
                      color: titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: fieldDecoration.copyWith(
                      hintText: 'Max',
                      hintStyle: GoogleFonts.nunitoSans(
                        color: hintColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Text(
                      'Apply',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
