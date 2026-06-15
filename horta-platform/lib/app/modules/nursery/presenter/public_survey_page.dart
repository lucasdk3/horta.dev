import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/theme/app_theme.dart';
import '../data/nursery_datasource.dart';
import '../domain/entities/survey.dart';
import '../domain/entities/survey_response.dart';
import 'widgets/survey_form_tab.dart';
import 'widgets/public_top_bar.dart';

class PublicSurveyPage extends StatefulWidget {
  const PublicSurveyPage({super.key, required this.surveyId});
  final String surveyId;

  @override
  State<PublicSurveyPage> createState() => _PublicSurveyPageState();
}

class _PublicSurveyPageState extends State<PublicSurveyPage> {
  Survey? _survey;
  List<SurveyResponse> _responses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final datasource = GetIt.I<NurseryDatasource>();
    try {
      final results = await Future.wait([
        datasource.fetchSurveyById(widget.surveyId),
        datasource.fetchSurveyResponses(widget.surveyId),
      ]);
      if (!mounted) return;
      setState(() {
        _survey = Survey.fromJson(results[0] as Map<String, dynamic>);
        _responses = (results[1] as List<Map<String, dynamic>>)
            .map(SurveyResponse.fromJson)
            .toList();
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HortaTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            PublicTopBar(
              surveyTitle: _survey?.title.get(context.locale.languageCode),
            ),
            if (_loading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                      color: HortaTheme.primaryEmerald),
                ),
              )
            else if (_survey == null)
              Expanded(
                child: Center(
                  child: Text(
                    'survey.not_found'.tr(),
                    style: const TextStyle(color: Colors.white54),
                  ),
                ),
              )
            else
              Expanded(
                child: SurveyFormTab(
                  survey: _survey!,
                  responses: _responses,
                  onSuccess: _load,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
