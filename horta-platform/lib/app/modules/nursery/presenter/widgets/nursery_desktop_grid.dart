import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/survey.dart';
import 'survey_card.dart';

class NurseryDesktopGrid extends StatelessWidget {
  const NurseryDesktopGrid({
    super.key,
    required this.surveys,
    required this.accentFor,
    required this.lang,
  });

  final List<Survey> surveys;
  final Color Function(int) accentFor;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    int i = 0;

    if (surveys.isNotEmpty) {
      rows.add(IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 360),
                child: SurveyCard(
                  survey: surveys[0],
                  accent: accentFor(0),
                  isFirst: true,
                  lang: lang,
                  onTap: () => context.go('/survey/${surveys[0].id}'),
                ),
              ),
            ),
            if (surveys.length > 1) ...[
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: SurveyCard(
                  survey: surveys[1],
                  accent: accentFor(1),
                  isFirst: false,
                  lang: lang,
                  onTap: () => context.go('/survey/${surveys[1].id}'),
                ),
              ),
            ],
          ],
        ),
      ));
      i = 2;
    }

    while (i < surveys.length) {
      final chunk = surveys.skip(i).take(3).toList();
      final startIndex = i;
      rows.add(const SizedBox(height: 16));
      rows.add(IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final e in chunk.asMap().entries) ...[
              if (e.key > 0) const SizedBox(width: 16),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 320),
                  child: SurveyCard(
                    survey: e.value,
                    accent: accentFor(startIndex + e.key),
                    isFirst: false,
                    lang: lang,
                    onTap: () => context.go('/survey/${e.value.id}'),
                  ),
                ),
              ),
            ],
          ],
        ),
      ));
      i += 3;
    }

    return Column(children: rows);
  }
}
