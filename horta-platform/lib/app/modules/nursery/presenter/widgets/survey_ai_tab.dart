import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/nursery_datasource.dart';
import '../../domain/entities/survey.dart';
import '../../domain/entities/survey_response.dart';

/// Mirrors React's SurveyAI.tsx:
/// - Country filter dropdown
/// - Recalculate button
/// - Skeleton loading state
/// - Markdown-rendered AI summary
/// - Token-save cache via Go backend (handled server-side)
class SurveyAiTab extends StatefulWidget {
  final Survey survey;
  final List<SurveyResponse> responses;

  const SurveyAiTab({super.key, required this.survey, required this.responses});

  @override
  State<SurveyAiTab> createState() => _SurveyAiTabState();
}

class _SurveyAiTabState extends State<SurveyAiTab> {
  String _countryFilter = 'Global';
  String? _summary;
  bool _loading = false;

  List<String> get _countries =>
      ['Global', ...widget.responses.map((r) => r.country).toSet()];

  @override
  void initState() {
    super.initState();
    if (widget.responses.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchSummary());
    }
  }

  Future<void> _fetchSummary({bool force = false}) async {
    if (widget.responses.isEmpty) return;
    setState(() => _loading = true);
    try {
      final summary = await GetIt.I<NurseryDatasource>().fetchSurveySummary(
        surveyId: widget.survey.id,
        lang: context.locale.languageCode,
        countryFilter: _countryFilter,
      );
      setState(() => _summary = summary);
    } catch (_) {
      setState(() => _summary = 'Failed to generate insights.');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.responses.isEmpty) {
      return Center(
        child: Text('survey.no_responses'.tr(),
            style: const TextStyle(color: Color(0xFF64748B))),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Controls row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.auto_awesome,
                      color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('AI PRESENTATION',
                      style: TextStyle(
                          color: Color(0xFF818CF8),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3)),
                ),
                // Country filter
                DropdownButton<String>(
                  value: _countryFilter,
                  dropdownColor: const Color(0xFF0F0F1A),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                  underline: const SizedBox(),
                  borderRadius: BorderRadius.circular(12),
                  items: _countries
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c == 'Global' ? 'Global Insights' : c),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _countryFilter = v);
                    _fetchSummary();
                  },
                ),
                const SizedBox(width: 8),
                // Recalculate
                OutlinedButton.icon(
                  onPressed: _loading ? null : () => _fetchSummary(force: true),
                  icon: _loading
                      ? const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white60))
                      : const Icon(Icons.refresh, size: 14),
                  label: Text('survey.recalculate'.tr(),
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white60,
                    side:
                        BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Summary card
          _loading
              ? _SkeletonLoader()
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A14),
                    borderRadius: BorderRadius.circular(24),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.06)),
                  ),
                  child: Stack(children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Opacity(
                        opacity: 0.04,
                        child: const Icon(Icons.auto_awesome,
                            size: 120, color: Colors.white),
                      ),
                    ),
                    MarkdownBody(
                      data: _summary ?? '_No insights generated yet._',
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 14,
                            height: 1.7),
                        h1: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900),
                        h2: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900),
                        h3: const TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                        strong: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        code: const TextStyle(
                            color: Color(0xFF818CF8),
                            fontFamily: 'monospace',
                            fontSize: 12),
                      ),
                    ),
                  ]),
                ),
        ],
      ),
    );
  }
}

class _SkeletonLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _skeletonBar(0.7, 20),
        const SizedBox(height: 16),
        _skeletonBar(1.0, 12),
        const SizedBox(height: 8),
        _skeletonBar(1.0, 12),
        const SizedBox(height: 8),
        _skeletonBar(0.85, 12),
        const SizedBox(height: 20),
        _skeletonBar(1.0, 80),
      ],
    );
  }

  Widget _skeletonBar(double widthFactor, double height) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
