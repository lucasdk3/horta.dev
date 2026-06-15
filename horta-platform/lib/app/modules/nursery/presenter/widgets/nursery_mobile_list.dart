import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/survey.dart';
import 'survey_card.dart';

class NurseryMobileList extends StatelessWidget {
  const NurseryMobileList({
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
    return Column(
      children: surveys.asMap().entries.map((e) {
        return Padding(
          padding: EdgeInsets.only(bottom: e.key < surveys.length - 1 ? 16 : 0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 280),
            child: SurveyCard(
              survey: e.value,
              accent: accentFor(e.key),
              isFirst: e.key == 0,
              lang: lang,
              onTap: () => context.go('/survey/${e.value.id}'),
            ),
          ),
        );
      }).toList(),
    );
  }
}
