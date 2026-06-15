import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/theme/app_theme.dart';
import 'cubits/nursery_cubit.dart';
import 'widgets/tag_filter_bar.dart';
import 'widgets/nursery_empty_state.dart';
import 'widgets/nursery_hero_row.dart';
import 'widgets/nursery_desktop_grid.dart';
import 'widgets/nursery_mobile_list.dart';

class NurseryScreen extends StatelessWidget {
  const NurseryScreen({super.key});

  Color _accent(int i) => HortaTheme.primaryEmerald;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<NurseryCubit>()..load(),
      child: BlocBuilder<NurseryCubit, NurseryState>(
        builder: (context, state) {
          final cubit = context.read<NurseryCubit>();
          final isDesktop = MediaQuery.of(context).size.width > 900;
          final lang = context.locale.languageCode;

          return RefreshIndicator(
            onRefresh: cubit.load,
            color: const Color(0xFF10B981),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NurseryHeroRow(isDesktop: isDesktop),
                        const SizedBox(height: 32),
                        if (state is NurseryLoaded) ...[
                          TagFilterBar(
                            tags: state.allTags,
                            selected: state.selectedTag,
                            onSelect: cubit.selectTag,
                          ),
                          const SizedBox(height: 32),
                        ],
                      ],
                    ),
                  ),
                ),
                switch (state) {
                  NurseryLoading() => const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF10B981)),
                      ),
                    ),
                  NurseryError(:final message) => SliverFillRemaining(
                      child: Center(
                        child: Text(message,
                            style: const TextStyle(
                                color: HortaTheme.textSecondary)),
                      ),
                    ),
                  NurseryLoaded() when state.filtered.isEmpty =>
                    SliverFillRemaining(
                      child: NurseryEmptyState(onSeed: cubit.load),
                    ),
                  NurseryLoaded() => SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                        child: isDesktop
                            ? NurseryDesktopGrid(
                                surveys: state.filtered,
                                accentFor: _accent,
                                lang: lang,
                              )
                            : NurseryMobileList(
                                surveys: state.filtered,
                                accentFor: _accent,
                                lang: lang,
                              ),
                      ),
                    ),
                },
              ],
            ),
          );
        },
      ),
    );
  }
}
