import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/auth_service.dart';
import '../../data/nursery_datasource.dart';
import '../../domain/entities/survey.dart';
import '../../domain/entities/survey_response.dart';

/// Mirrors React's SurveyForm.tsx:
/// - Country field
/// - Text / choice / rating question types
/// - Unauthenticated state → "Join the Community"
/// - Already voted state
/// - Submits +50 XP via API
class SurveyFormTab extends StatefulWidget {
  final Survey survey;
  final List<SurveyResponse> responses;
  final VoidCallback onSuccess;

  const SurveyFormTab({
    super.key,
    required this.survey,
    required this.responses,
    required this.onSuccess,
  });

  @override
  State<SurveyFormTab> createState() => _SurveyFormTabState();
}

class _SurveyFormTabState extends State<SurveyFormTab> {
  final _countryController = TextEditingController();
  final Map<String, dynamic> _answers = {};
  bool _submitting = false;

  AuthService get _auth => GetIt.I<AuthService>();
  NurseryDatasource get _datasource => GetIt.I<NurseryDatasource>();

  bool get _alreadyResponded {
    final email = _auth.currentUserEmail;
    if (email == null) return false;
    return widget.responses.any((r) => r.respondentEmail == email);
  }

  Future<void> _submit() async {
    if (_countryController.text.trim().isEmpty) return;
    setState(() => _submitting = true);
    try {
      await _datasource.submitResponse({
        'surveyId': widget.survey.id,
        'country': _countryController.text.trim(),
        'answers': _answers,
      });
      widget.onSuccess();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('survey.xp_earned'.tr()),
          backgroundColor: const Color(0xFF10B981),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('survey.xp_error'.tr()),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_auth.isAuthenticated) return _JoinCommunityState();
    if (_alreadyResponded) return _AlreadyVotedState();

    final currentLang = context.locale.languageCode;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Country field
          _FormSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('garden.country'.tr().toUpperCase(),
                    style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3)),
                const SizedBox(height: 8),
                TextField(
                  controller: _countryController,
                  style: const TextStyle(color: Colors.white),
                  decoration:
                      _inputDecoration('nursery.field_country_hint'.tr()),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Questions
          ...widget.survey.questions.map((q) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _QuestionCard(
                  question: q,
                  lang: currentLang,
                  value: _answers[q.id],
                  onChanged: (v) => setState(() => _answers[q.id] = v),
                ),
              )),

          const SizedBox(height: 24),

          // Footer + submit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('app.login_via_google'.tr(args: ['Google']),
                  style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11,
                      fontStyle: FontStyle.italic)),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.black))
                      : Text('survey.submit'.tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              letterSpacing: 2)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.04),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF10B981)),
      ),
    );

class _FormSection extends StatelessWidget {
  final Widget child;
  const _FormSection({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: child,
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final SurveyQuestion question;
  final String lang;
  final dynamic value;
  final void Function(dynamic) onChanged;

  const _QuestionCard(
      {required this.question,
      required this.lang,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _FormSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
                width: 6,
                height: 20,
                decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(3))),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                question.label.get(lang),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          if (question.type == QuestionType.text)
            TextField(
              onChanged: onChanged,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('...'),
            )
          else if (question.type == QuestionType.choice)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: question.options.map((opt) {
                final selected = value == opt.value;
                return GestureDetector(
                  onTap: () => onChanged(opt.value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF4F46E5).withValues(alpha: 0.15)
                          : Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF4F46E5)
                            : Colors.white.withValues(alpha: 0.1),
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      opt.label.get(lang),
                      style: TextStyle(
                          color: selected
                              ? const Color(0xFF818CF8)
                              : const Color(0xFF94A3B8),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                );
              }).toList(),
            )
          else if (question.type == QuestionType.rating)
            Row(
              children: List.generate(5, (i) {
                final v = (i + 1).toString();
                final selected = value == v;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => onChanged(v),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: 48,
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF4F46E5)
                              : Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: selected
                                  ? const Color(0xFF4F46E5)
                                  : Colors.white.withValues(alpha: 0.1)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                              fontWeight: FontWeight.w900,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}

class _JoinCommunityState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                  shape: BoxShape.circle),
              child:
                  const Icon(Icons.person, color: Color(0xFF818CF8), size: 32),
            ),
            const SizedBox(height: 20),
            Text('survey.join_community'.tr(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(
              'survey.sign_in_required'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => GetIt.I<AuthService>().signInWithGoogle(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999)),
              ),
              child: Text('app.login_with'.tr(args: ['Google']),
                  style: const TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlreadyVotedState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 64),
            const SizedBox(height: 16),
            Text('survey.already_voted'.tr(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text('survey.already_voted_subtitle'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }
}
