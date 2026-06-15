import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/survey.dart';
import '../../domain/entities/survey_response.dart';

/// Mirrors React's SurveyTable.tsx:
/// Scrollable data table with Country, answers per question, Date, Export CSV button.
class SurveyTableTab extends StatelessWidget {
  final Survey survey;
  final List<SurveyResponse> responses;

  const SurveyTableTab(
      {super.key, required this.survey, required this.responses});

  Future<void> _exportCSV(BuildContext context, String lang) async {
    try {
      // Build CSV content
      final headers = [
        'Country',
        ...survey.questions.map((q) => q.label.get(lang).replaceAll(',', ';')),
        'Date'
      ];

      final buffer = StringBuffer();
      buffer.writeln(headers.join(','));

      for (final res in responses) {
        final row = [
          res.country.replaceAll(',', ';'),
          ...survey.questions.map((q) {
            final ans = res.answers[q.id];
            return (ans?.toString() ?? '').replaceAll(',', ';');
          }),
          res.createdAt != null
              ? DateFormat('yyyy-MM-dd HH:mm').format(res.createdAt!)
              : ''
        ];
        buffer.writeln(row.join(','));
      }

      final csvString = buffer.toString();
      final uri = Uri.dataFromString(
        csvString,
        mimeType: 'text/csv',
        encoding: utf8,
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('survey.export_error'.tr())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = context.locale.languageCode;

    if (responses.isEmpty) {
      return Center(
        child: Text('survey.no_responses'.tr(),
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: '${'nursery.total_responses'.tr().toUpperCase()}: ',
                      style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2)),
                  TextSpan(
                      text: '${responses.length}',
                      style: const TextStyle(
                          color: Color(0xFF818CF8),
                          fontSize: 10,
                          fontWeight: FontWeight.w900)),
                ]),
              ),
              OutlinedButton.icon(
                onPressed: () => _exportCSV(context, currentLang),
                icon: const Icon(Icons.download, size: 14),
                label: Text('survey.export_csv'.tr(),
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white60,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                        Colors.white.withValues(alpha: 0.03)),
                    dataRowColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.hovered)) {
                        return Colors.white.withValues(alpha: 0.03);
                      }
                      return Colors.transparent;
                    }),
                    border: TableBorder(
                      horizontalInside: BorderSide(
                          color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    columns: [
                      _col('garden.country'.tr().toUpperCase()),
                      ...survey.questions.map(
                          (q) => _col(q.label.get(currentLang), isWide: true)),
                      _col('garden.date'.tr().toUpperCase(), align: true),
                    ],
                    rows: responses.map((res) {
                      return DataRow(cells: [
                        DataCell(Text(res.country,
                            style: const TextStyle(
                                color: Color(0xFFCBD5E1),
                                fontWeight: FontWeight.w700,
                                fontSize: 13))),
                        ...survey.questions.map((q) {
                          final ans = res.answers[q.id];
                          return DataCell(
                            ans != null
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.06),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      ans.toString(),
                                      style: const TextStyle(
                                          color: Color(0xFFCBD5E1),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                : const Text('–',
                                    style: TextStyle(color: Color(0xFF475569))),
                          );
                        }),
                        DataCell(Text(
                          res.createdAt != null
                              ? DateFormat('yyyy.MM.dd HH:mm')
                                  .format(res.createdAt!)
                              : '–',
                          style: const TextStyle(
                              color: Color(0xFF475569),
                              fontSize: 10,
                              fontFamily: 'monospace'),
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataColumn _col(String label, {bool isWide = false, bool align = false}) {
    return DataColumn(
      label: Text(label,
          style: TextStyle(
              color: align ? const Color(0xFF64748B) : const Color(0xFFCBD5E1),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2)),
    );
  }
}
