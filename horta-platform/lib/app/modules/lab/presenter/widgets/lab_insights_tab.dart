import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../cubits/lab_cubit.dart';
import 'insight_card.dart';

class LabInsightsTab extends StatelessWidget {
  const LabInsightsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LabInsightsCubit, LabInsightsState>(
      builder: (context, state) => switch (state) {
        LabInsightsLoading() => const Center(
            child: CircularProgressIndicator(color: Color(0xFF4F46E5))),
        LabInsightsError(:final message) => Center(
            child: Text(message,
                style: const TextStyle(color: Colors.white54))),
        LabInsightsLoaded() => _InsightsList(state: state),
      },
    );
  }
}

class _InsightsList extends StatelessWidget {
  const _InsightsList({required this.state});

  final LabInsightsLoaded state;

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final cubit = context.read<LabInsightsCubit>();

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: state.surveys.length,
      itemBuilder: (_, i) {
        final s = state.surveys[i];
        final id = s['id'] as String? ?? '';
        final titleMap = s['title'] as Map?;
        final title = titleMap?[lang] ?? titleMap?['pt'] ?? id;
        return InsightCard(
          title: title.toString(),
          summary: state.summaries[id],
          isLoading: state.isLoadingId(id),
          onRefresh: () => cubit.fetchSummary(id, lang),
        );
      },
    );
  }
}
