import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_circle_back_button.dart';
import 'package:vantage/features/addresses/domain/entities/address_entity.dart';
import 'package:vantage/features/addresses/presentation/cubit/addresses_cubit.dart';
import 'package:vantage/features/addresses/presentation/cubit/addresses_state.dart';

@RoutePage()
class AddressFormPage extends StatefulWidget {
  const AddressFormPage({super.key, this.addressId});

  // Firestore document id when editing an existing address.
  final String? addressId;

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

final class _AddressFormPageState extends State<AddressFormPage> {
  final _street = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _zip = TextEditingController();
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _trySeedFromCubit();
    });
  }

  void _trySeedFromCubit() {
    final id = widget.addressId;
    if (id == null || _seeded) return;
    final addressesState = context.read<AddressesCubit>().state;
    if (addressesState is! AddressesLoaded) return;
    for (final address in addressesState.addresses) {
      if (address.id == id) {
        _seedFrom(address);
        return;
      }
    }
  }

  @override
  void dispose() {
    _street.dispose();
    _city.dispose();
    _state.dispose();
    _zip.dispose();
    super.dispose();
  }

  void _seedFrom(AddressEntity a) {
    if (_seeded) return;
    _seeded = true;
    _street.text = a.street;
    _city.text = a.city;
    _state.text = a.state;
    _zip.text = a.zipCode;
  }

  Future<void> _onSave(BuildContext context) async {
    final street = _street.text.trim();
    final city = _city.text.trim();
    final stateText = _state.text.trim();
    final zip = _zip.text.trim();
    if (street.isEmpty || city.isEmpty || stateText.isEmpty || zip.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.address_fillAllFields.tr())),
      );
      return;
    }

    final id = widget.addressId ?? '';
    final entity = AddressEntity(
      id: id,
      street: street,
      city: city,
      state: stateText,
      zipCode: zip,
    );

    final ok = await context.read<AddressesCubit>().upsert(entity);
    if (!context.mounted) return;
    if (ok) {
      context.router.maybePop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.address_saveError.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    final fieldFill =
        isDark ? VantageColors.authBgDark2 : VantageColors.homeAudiencePillLight;
    final hintColor = isDark
        ? Colors.white.withValues(alpha: 0.5)
        : VantageColors.profileTextSecondaryLight;
    final textColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;

    final titleKey = widget.addressId != null
        ? LocaleKeys.address_editTitle
        : LocaleKeys.address_addTitle;

    return BlocListener<AddressesCubit, AddressesState>(
      listenWhen: (p, c) => c is AddressesLoaded && widget.addressId != null,
      listener: (context, state) => _trySeedFromCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.sm,
                  AppSpacing.screenHorizontal,
                  0,
                ),
                child: Row(
                  children: [
                    VantageCircleBackButton(
                      onPressed: () => context.router.maybePop(),
                    ),
                    Expanded(
                      child: Text(
                        titleKey.tr(),
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
                    const SizedBox(width: AppSpacing.toolbarIconSlot),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _LabeledField(
                        controller: _street,
                        hintText: LocaleKeys.address_street.tr(),
                        fieldFill: fieldFill,
                        hintColor: hintColor,
                        textColor: textColor,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _LabeledField(
                        controller: _city,
                        hintText: LocaleKeys.address_city.tr(),
                        fieldFill: fieldFill,
                        hintColor: hintColor,
                        textColor: textColor,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _LabeledField(
                              controller: _state,
                              hintText: LocaleKeys.address_state.tr(),
                              fieldFill: fieldFill,
                              hintColor: hintColor,
                              textColor: textColor,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _LabeledField(
                              controller: _zip,
                              hintText: LocaleKeys.address_zip.tr(),
                              fieldFill: fieldFill,
                              hintColor: hintColor,
                              textColor: textColor,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.sm,
                  AppSpacing.screenHorizontal,
                  AppSpacing.lg,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _onSave(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: VantageColors.authPrimaryPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    child: Text(
                      LocaleKeys.address_save.tr(),
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
      ),
    );
  }
}

final class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.controller,
    required this.hintText,
    required this.fieldFill,
    required this.hintColor,
    required this.textColor,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final Color fieldFill;
  final Color hintColor;
  final Color textColor;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: fieldFill,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.inset18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          borderSide: BorderSide.none,
        ),
        hintStyle: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: hintColor,
        ),
      ),
      style: GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
    );
  }
}
