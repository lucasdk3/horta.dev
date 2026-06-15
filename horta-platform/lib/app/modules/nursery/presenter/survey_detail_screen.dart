import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/theme.dart';
import '../data/nursery_datasource.dart';
import '../domain/entities/survey.dart';
import '../domain/entities/survey_response.dart';
import 'widgets/survey_form_tab.dart';
import 'widgets/survey_table_tab.dart';
import 'widgets/survey_ai_tab.dart';
import 'widgets/survey_chat_tab.dart';
import 'widgets/survey_tab.dart';

/// SurveyDetail screen with 4 tabs:
/// 1. Respond (SurveyForm)
/// 2. Data (SurveyTable)
/// 3. Presentation (SurveyAI)
/// 4. Chat (SurveyChat)
/// Mirrors React's SurveyDetail in App.tsx.
class SurveyDetailScreen extends StatefulWidget {
  final String surveyId;
  const SurveyDetailScreen({super.key, required this.surveyId});

  @override
  State<SurveyDetailScreen> createState() => _SurveyDetailScreenState();
}

class _SurveyDetailScreenState extends State<SurveyDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Survey? _survey;
  List<SurveyResponse> _responses = [];
  bool _loading = true;

  final _datasource = GetIt.I<NurseryDatasource>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final surveyData = await _datasource.fetchSurveyById(widget.surveyId);
      Survey survey = Survey.fromJson(surveyData);

      List<SurveyResponse> responses = [];
      try {
        final responsesData =
            await _datasource.fetchSurveyResponses(widget.surveyId);
        responses = responsesData.map(SurveyResponse.fromJson).toList();
      } catch (_) {
        // Responses endpoint may not be available yet; show survey without them.
      }

      setState(() {
        _survey = survey;
        _responses = responses;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: Text('LOADING…',
              style: TextStyle(
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 4)),
        ),
      );
    }

    if (_survey == null) {
      return const Scaffold(
        body: Center(
            child: Text('Survey not found',
                style: TextStyle(color: Colors.white54))),
      );
    }

    final survey = _survey!;
    final currentLang = context.locale.languageCode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('← ${'app.home'.tr().toUpperCase()}',
                        style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3)),
                    const SizedBox(height: 4),
                    Text(
                      survey.title.get(currentLang),
                      style: TextStyle(
                          color: HortaTheme.pageText(context),
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '${_responses.length}',
                          style: const TextStyle(
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.w900,
                              fontSize: 14),
                        ),
                        TextSpan(
                          text: '  ${'nursery.total_responses'.tr()}',
                          style: const TextStyle(
                              color: Color(0xFF64748B), fontSize: 14),
                        ),
                      ]),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: 'https://horta.dev/s/${survey.id}'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Link copied!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: HortaTheme.pageText(context),
                    side:
                        BorderSide(color: HortaTheme.containerBorder(context)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('survey.share'.tr()),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Tab Bar ──
            Container(
              decoration: BoxDecoration(
                color: HortaTheme.darkCardBg(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: HortaTheme.darkCardBorder(context)),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicator: BoxDecoration(
                  color: HortaTheme.primaryEmerald,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: HortaTheme.pageText(context),
                unselectedLabelColor: HortaTheme.textSecondary,
                tabs: [
                  SurveyTab(
                      number: '1',
                      label: 'survey.respond'.tr(),
                      sub: 'survey.respond_sub'.tr(),
                      icon: Icons.water_drop),
                  SurveyTab(
                      number: '2',
                      label: 'survey.data'.tr(),
                      sub: 'survey.data_sub'.tr(),
                      icon: Icons.spa),
                  SurveyTab(
                      number: '3',
                      label: 'survey.presentation'.tr(),
                      sub: 'survey.presentation_sub'.tr(),
                      icon: Icons.local_florist),
                  SurveyTab(
                      number: '4',
                      label: 'survey.chat'.tr(),
                      sub: 'survey.chat_sub'.tr(),
                      icon: Icons.chat_bubble),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Tab Views ──
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: HortaTheme.darkCardBg(context),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: HortaTheme.darkCardBorder(context)),
                ),
                clipBehavior: Clip.antiAlias,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SurveyFormTab(
                      survey: survey,
                      responses: _responses,
                      onSuccess: _loadData,
                    ),
                    SurveyTableTab(survey: survey, responses: _responses),
                    SurveyAiTab(survey: survey, responses: _responses),
                    SurveyChatTab(survey: survey, responses: _responses),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

