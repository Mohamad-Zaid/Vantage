import 'dart:async';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_circle_back_button.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';
import 'package:vantage/core/widgets/vantage_primary_button.dart';
import 'package:vantage/di/injection.dart';
import 'package:vantage/features/profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:vantage/features/profile/presentation/cubit/edit_profile_state.dart';
import 'package:vantage/features/profile/presentation/widgets/profile_avatar.dart';

@RoutePage()
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _imagePicker = ImagePicker();
  late final EditProfileCubit _cubit;
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    _cubit = EditProfileCubit(sl(), sl());
    unawaited(_cubit.load());
  }

  @override
  void dispose() {
    _cubit.close();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (pickedImage == null || !mounted) return;
    final bytes = await pickedImage.readAsBytes();
    if (!mounted) return;
    _cubit.setNewPhotoBytes(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditProfileCubit>.value(
      value: _cubit,
      child: BlocListener<EditProfileCubit, EditProfileState>(
        listenWhen: (p, c) =>
            c is EditProfileNoSession ||
            c is EditProfileSaveSuccess ||
            (c is EditProfileReady && c.saveErrorLocaleKey != null),
        listener: (context, state) {
          if (state is EditProfileNoSession) {
            if (context.mounted) context.router.maybePop();
            return;
          }
          if (state is EditProfileSaveSuccess) {
            if (context.mounted) context.router.maybePop();
            return;
          }
          if (state is EditProfileReady) {
            final saveErrorLocaleKey = state.saveErrorLocaleKey;
            if (saveErrorLocaleKey != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(saveErrorLocaleKey.tr())),
              );
              _cubit.clearSaveError();
            }
          }
        },
        child: BlocListener<EditProfileCubit, EditProfileState>(
          listenWhen: (p, c) => c is EditProfileReady && p is EditProfileLoading,
          listener: (context, state) {
            if (state is! EditProfileReady || _seeded) return;
            final currentUser = state.user;
            _nameCtrl.text =
                (currentUser.displayName?.trim().isNotEmpty ?? false)
                    ? currentUser.displayName!.trim()
                    : (currentUser.email.isNotEmpty
                        ? currentUser.email.split('@').first
                        : '');
            _phoneCtrl.text = currentUser.phone?.trim() ?? '';
            _seeded = true;
          },
          child: BlocBuilder<EditProfileCubit, EditProfileState>(
            builder: (context, state) {
              if (state is EditProfileLoading) {
                return const Scaffold(
                  body: Center(child: VantageLoadingIndicator()),
                );
              }
              if (state is EditProfileNoSession) {
                return const SizedBox.shrink();
              }
              if (state is EditProfileSaveSuccess) {
                return const Scaffold(
                  body: Center(child: VantageLoadingIndicator()),
                );
              }
              if (state is! EditProfileReady) {
                return const SizedBox.shrink();
              }
              return _EditProfileScaffold(
                formKey: _formKey,
                nameCtrl: _nameCtrl,
                phoneCtrl: _phoneCtrl,
                state: state,
                onPickPhoto: _pickPhoto,
                onSave: () {
                  if (!_formKey.currentState!.validate()) return;
                  unawaited(
                    _cubit.save(
                      _nameCtrl.text.trim(),
                      _phoneCtrl.text.trim(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EditProfileScaffold extends StatelessWidget {
  const _EditProfileScaffold({
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.state,
    required this.onPickPhoto,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final EditProfileReady state;
  final VoidCallback onPickPhoto;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleC =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    final subC = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : VantageColors.profileTextSecondaryLight;
    final fieldFill =
        isDark ? VantageColors.authBgDark2 : VantageColors.homeAudiencePillLight;
    final currentUser = state.user;
    final saving = state.saving;

    InputDecoration dec(String label, {String? hint}) {
      return InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: fieldFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: VantageColors.authPrimaryPurple,
            width: 1.2,
          ),
        ),
        labelStyle: GoogleFonts.nunitoSans(
          color: subC,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.nunitoSans(
          color: subC,
          fontSize: 16,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: [
                    VantageCircleBackButton(
                      onPressed: () => context.router.maybePop(),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Text(
                LocaleKeys.profile_editProfileTitle.tr(),
                style: GoogleFonts.gabarito(
                  color: titleC,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.inset28),
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: saving ? null : onPickPhoto,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ClipOval(
                            child: SizedBox(
                              width: ProfileAvatar.diameter,
                              height: ProfileAvatar.diameter,
                              child: state.newPhotoBytes != null
                                  ? Image.memory(
                                      Uint8List.fromList(state.newPhotoBytes!),
                                      fit: BoxFit.cover,
                                    )
                                  : (currentUser.photoUrl != null &&
                                          currentUser.photoUrl!.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: currentUser.photoUrl!,
                                          fit: BoxFit.cover,
                                        )
                                      : ColoredBox(
                                          color: isDark
                                              ? VantageColors.authBgDark2
                                              : VantageColors
                                                  .homeAudiencePillLight,
                                          child: Icon(
                                            Icons.person,
                                            size: 40,
                                            color: isDark
                                                ? Colors.white54
                                                : VantageColors
                                                    .homeCategoryLabelLight,
                                          ),
                                        )),
                            ),
                          ),
                          if (!saving)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                  color: VantageColors.authPrimaryPurple,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: saving ? null : onPickPhoto,
                      child: Text(
                        LocaleKeys.profile_changePhoto.tr(),
                        style: GoogleFonts.nunitoSans(
                          color: VantageColors.authPrimaryPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                LocaleKeys.profile_emailReadonly.tr(),
                style: GoogleFonts.nunitoSans(
                  color: subC,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                currentUser.email,
                style: GoogleFonts.nunitoSans(
                  color: titleC,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.inset20),
              TextFormField(
                controller: nameCtrl,
                enabled: !saving,
                style: GoogleFonts.nunitoSans(
                  color: titleC,
                  fontSize: 16,
                ),
                decoration: dec(LocaleKeys.profile_fullName.tr()),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return LocaleKeys.profile_fullNameRequired.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: phoneCtrl,
                enabled: !saving,
                keyboardType: TextInputType.phone,
                style: GoogleFonts.nunitoSans(
                  color: titleC,
                  fontSize: 16,
                ),
                decoration: dec(
                  LocaleKeys.profile_phoneOptional.tr(),
                  hint: LocaleKeys.profile_phoneOptional.tr(),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              VantagePrimaryButton(
                label: LocaleKeys.profile_saveProfile.tr(),
                isLoading: saving,
                onPressed: saving ? null : onSave,
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
