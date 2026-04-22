import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/generated/assets.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../domain/entities/home_audience.dart';
import '../cubit/home_audience_cubit.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    super.key,
    required this.authCubit,
    required this.audienceCubit,
    required this.onProfileTap,
    required this.onCartTap,
  });

  final AuthCubit authCubit;
  final HomeAudienceCubit audienceCubit;
  final VoidCallback onProfileTap;
  final VoidCallback onCartTap;

  static const double _avatarSize = 40;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pillBg = isDark
        ? VantageColors.authBgDark2
        : VantageColors.homeAudiencePillLight;
    final pillTextColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    final chevronColor = pillTextColor;
    final menuBg = isDark
        ? const Color(0xFF252032)
        : Colors.white;
    final menuBorder = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : VantageColors.homeCategoryLabelLight.withValues(alpha: 0.12);

    return BlocBuilder<AuthCubit, AuthState>(
      bloc: authCubit,
      builder: (context, authState) {
        final user = authState is AuthAuthenticated ? authState.user : null;
        final photoUrl = user?.photoUrl;

        return BlocBuilder<HomeAudienceCubit, HomeAudience>(
          bloc: audienceCubit,
          builder: (context, audience) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: _avatarSize,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: onProfileTap,
                      child: CircleAvatar(
                        radius: _avatarSize / 2,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                            ? CachedNetworkImageProvider(photoUrl)
                            : null,
                        child: photoUrl == null || photoUrl.isEmpty
                            ? Icon(
                                Icons.person,
                                size: 22,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                      ),
                      child: PopupMenuButton<HomeAudience>(
                        // Small Y: larger values place the under-menu on top of search.
                        offset: const Offset(0, 6),
                        enableFeedback: false,
                        position: PopupMenuPosition.under,
                        elevation: 12,
                        shadowColor: Colors.black.withValues(alpha: 0.45),
                        surfaceTintColor: Colors.transparent,
                        color: menuBg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: menuBorder),
                        ),
                        constraints: const BoxConstraints(minWidth: 148),
                        popUpAnimationStyle: const AnimationStyle(
                          curve: Curves.easeOutCubic,
                          duration: Duration(milliseconds: 200),
                        ),
                        onSelected: audienceCubit.select,
                        itemBuilder: (context) => [
                          for (final a in HomeAudience.values)
                            PopupMenuItem<HomeAudience>(
                              value: a,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              child: SizedBox(
                                width: 112,
                                child: Text(
                                  a.localeKey.tr(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunitoSans(
                                    color: isDark
                                        ? Colors.white
                                        : VantageColors.homeCategoryLabelLight,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                        ],
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: ShapeDecoration(
                            color: pillBg,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                audience.localeKey.tr(),
                                style: GoogleFonts.gabarito(
                                  color: pillTextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              SvgPicture.asset(
                                Assets.vectorArrowDown,
                                width: 16,
                                height: 16,
                                colorFilter: ColorFilter.mode(
                                  chevronColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: _avatarSize,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: onCartTap,
                      child: Container(
                        width: _avatarSize,
                        height: _avatarSize,
                        decoration: ShapeDecoration(
                          color: VantageColors.authPrimaryPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            Assets.vectorHomeCart,
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

extension on HomeAudience {
  String get localeKey => switch (this) {
        HomeAudience.men => LocaleKeys.home_audienceMen,
        HomeAudience.women => LocaleKeys.home_audienceWomen,
        HomeAudience.boy => LocaleKeys.home_audienceBoy,
        HomeAudience.girl => LocaleKeys.home_audienceGirl,
      };
}
