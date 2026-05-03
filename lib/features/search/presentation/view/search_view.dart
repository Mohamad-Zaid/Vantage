import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/widgets/vantage_circle_back_button.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';
import 'package:vantage/core/presentation/failure_display_ext.dart';
import 'package:vantage/generated/assets.dart';

import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/search_category_list.dart';
import '../widgets/search_empty_view.dart';
import '../widgets/search_filter_chips_bar.dart';
import '../widgets/search_results_grid.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.cubit});

  final SearchCubit cubit;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.cubit.close();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      widget.cubit.search(_controller.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  return _SearchTopBar(
                    controller: _controller,
                    focusNode: _focusNode,
                    onBack: () => context.router.maybePop(),
                  );
                },
              ),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  bloc: widget.cubit,
                  builder: (context, state) {
                    return switch (state) {
                      SearchInitial() => const SingleChildScrollView(
                          child: SearchCategoryList(),
                        ),
                      SearchLoading() => const Center(
                          child: VantageLoadingIndicator(),
                        ),
                      SearchLoaded(:final products) => CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: SearchFilterChipsBar(
                                  filter: widget.cubit.filter,
                                  onFilterChanged: widget.cubit.applyFilter,
                                ),
                              ),
                            ),
                            SearchResultsGrid(products: products),
                          ],
                        ),
                      SearchEmpty() => CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: SearchFilterChipsBar(
                                  filter: widget.cubit.filter,
                                  onFilterChanged: widget.cubit.applyFilter,
                                ),
                              ),
                            ),
                            const SliverFillRemaining(
                              hasScrollBody: false,
                              child: SearchEmptyView(),
                            ),
                          ],
                        ),
                      SearchError(:final failure) => Center(
                          child: Text(
                            failure.displayMessage,
                            style: GoogleFonts.nunitoSans(
                              color: VantageColors.authPrimaryPurple,
                            ),
                          ),
                        ),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchTopBar extends StatelessWidget {
  const _SearchTopBar({
    required this.controller,
    required this.focusNode,
    required this.onBack,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor =
        isDark ? VantageColors.authBgDark2 : VantageColors.homeSearchFieldLight;
    final foreground =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    final hintColor = isDark
        ? foreground.withValues(alpha: 0.6)
        : foreground.withValues(alpha: 0.55);

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide.none,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Row(
        children: [
          VantageCircleBackButton(onPressed: onBack),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                cursorColor: VantageColors.authPrimaryPurple,
                style: GoogleFonts.nunitoSans(
                  color: foreground,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: fillColor,
                  hoverColor: Colors.transparent,
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border,
                  contentPadding: const EdgeInsets.only(left: 4, right: 8),
                  hintText: 'Search',
                  hintStyle: GoogleFonts.nunitoSans(
                    color: hintColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 11),
                    child: SvgPicture.asset(
                      Assets.vectorHomeSearch,
                      width: 16,
                      height: 16,
                      colorFilter:
                          ColorFilter.mode(foreground, BlendMode.srcIn),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 42,
                    minHeight: 40,
                  ),
                  suffixIcon: controller.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            controller.clear();
                            focusNode.requestFocus();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: foreground,
                            ),
                          ),
                        )
                      : null,
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
