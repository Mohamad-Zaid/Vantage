import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/di/injection.dart';
import '../cubit/support_cubit.dart';
import '../cubit/support_state.dart';

@RoutePage()
class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  late final SupportCubit _supportCubit;

  @override
  void initState() {
    super.initState();
    _supportCubit = sl<SupportCubit>();
  }

  @override
  void dispose() {
    _supportCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.profile_helpAndSupport.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, LocaleKeys.support_faqs_title.tr()),
            const SizedBox(height: 16),
            _FAQSection(cubit: _supportCubit),
            const SizedBox(height: 32),
            _buildSectionTitle(context, LocaleKeys.support_contact_us_title.tr()),
            const SizedBox(height: 16),
            const _ContactUsSection(),
            const SizedBox(height: 32),
            _buildSectionTitle(context, LocaleKeys.support_report_bug_title.tr()),
            const SizedBox(height: 16),
            const _ReportBugSection(),
            const SizedBox(height: 32),
            _buildSectionTitle(context, LocaleKeys.support_legal_about_title.tr()),
            const SizedBox(height: 16),
            const _LegalAboutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class _HelpSupportCard extends StatelessWidget {
  const _HelpSupportCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark
        ? VantageColors.authBgDark2
        : VantageColors.homeAudiencePillLight;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
    );
  }
}

class _SupportExpansionTile extends StatelessWidget {
  const _SupportExpansionTile({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        collapsedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        iconColor: theme.colorScheme.primary,
        collapsedIconColor: theme.colorScheme.onSurfaceVariant,
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        childrenPadding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _FAQSection extends StatelessWidget {
  const _FAQSection({required this.cubit});

  final SupportCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupportCubit, SupportState>(
      bloc: cubit,
      builder: (context, state) {
        return switch (state) {
          SupportInitial() => const SizedBox.shrink(),
          SupportLoading() => const _FAQListShimmer(),
          SupportEmpty() =>
            Center(child: Text(LocaleKeys.support_no_faqs_found.tr())),
          SupportLoaded(:final faqs) => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: faqs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final faq = faqs[index];
                return _HelpSupportCard(
                  child: _SupportExpansionTile(
                    title: faq.question.tr(),
                    body: faq.answer.tr(),
                  ),
                );
              },
            ),
          SupportError() => Center(
              child: Text(LocaleKeys.support_error_loading_faqs.tr()),
            ),
        };
      },
    );
  }
}

class _FAQListShimmer extends StatelessWidget {
  const _FAQListShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final base = isDark ? Colors.grey.shade800 : Colors.grey.shade400;
    final highlight = isDark ? Colors.grey.shade600 : Colors.grey.shade200;
    final cardBg = isDark
        ? VantageColors.authBgDark2
        : VantageColors.homeAudiencePillLight;

    return Column(
      children: List.generate(
        4,
        (i) => Padding(
          padding: EdgeInsets.only(bottom: i == 3 ? 0 : 12),
          child: Shimmer.fromColors(
            baseColor: base,
            highlightColor: highlight,
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactUsSection extends StatelessWidget {
  const _ContactUsSection();

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (_) {
      // Demo: ignore bad/missing URLs.
    }
  }

  @override
  Widget build(BuildContext context) {
    return _HelpSupportCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ActionChip(
              avatar: const Icon(Icons.email, size: 20),
              label: Text(
                LocaleKeys.support_email.tr(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onPressed: () => _launchUrl('mailto:support@vantage.com'),
            ),
            ActionChip(
              avatar: const Icon(Icons.phone, size: 20),
              label: Text(
                LocaleKeys.support_phone.tr(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onPressed: () => _launchUrl('tel:+201000000000'),
            ),
            ActionChip(
              avatar: const Icon(Icons.message, size: 20),
              label: Text(
                LocaleKeys.support_whatsapp.tr(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              onPressed: () => _launchUrl('https://wa.me/201000000000'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportBugSection extends StatelessWidget {
  const _ReportBugSection();

  @override
  Widget build(BuildContext context) {
    return _HelpSupportCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: LocaleKeys.support_report_bug_hint.tr(),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(LocaleKeys.support_bug_reported_success.tr()),
                    ),
                  );
                },
                child: Text(LocaleKeys.support_submit.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegalAboutSection extends StatelessWidget {
  const _LegalAboutSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HelpSupportCard(
          child: _SupportExpansionTile(
            title: LocaleKeys.support_privacy_policy.tr(),
            body: LocaleKeys.support_legal_privacy_body.tr(),
          ),
        ),
        const SizedBox(height: 12),
        _HelpSupportCard(
          child: _SupportExpansionTile(
            title: LocaleKeys.support_terms_of_service.tr(),
            body: LocaleKeys.support_legal_terms_body.tr(),
          ),
        ),
        const SizedBox(height: 12),
        _HelpSupportCard(
          child: _SupportExpansionTile(
            title: LocaleKeys.support_legal_about_expand_title.tr(),
            body: LocaleKeys.support_legal_about_body.tr(),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'Version 1.0.0',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
