import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/auth_service.dart';
import '../../data/nursery_datasource.dart';

/// Mirrors React's RequestSurveyModal.tsx:
/// Title, Category, Description fields → POST to survey_requests.
class RequestSurveyModal extends StatefulWidget {
  const RequestSurveyModal({super.key});

  @override
  State<RequestSurveyModal> createState() => _RequestSurveyModalState();
}

class _RequestSurveyModalState extends State<RequestSurveyModal> {
  final _titleCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty || _descCtrl.text.trim().isEmpty) return;
    if (!GetIt.I<AuthService>().isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('nursery.login_required'.tr())),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await GetIt.I<NurseryDatasource>().createSurveyRequest({
        'title': _titleCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'suggestedCategory': _categoryCtrl.text.trim(),
        'status': 'pending',
      });
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('nursery.request_success'.tr()),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('nursery.request_error'.tr())),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF050510),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('nursery.request_title'.tr(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text("nursery.request_subtitle".tr(),
                  style:
                      const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
              const SizedBox(height: 24),
              _Field(
                label: 'nursery.field_title'.tr().toUpperCase(),
                controller: _titleCtrl,
                hint: 'nursery.field_title_hint'.tr(),
              ),
              const SizedBox(height: 16),
              _Field(
                label: 'nursery.field_category'.tr().toUpperCase(),
                controller: _categoryCtrl,
                hint: 'nursery.field_category_hint'.tr(),
              ),
              const SizedBox(height: 16),
              _Field(
                label: 'nursery.field_desc'.tr().toUpperCase(),
                controller: _descCtrl,
                hint: "nursery.field_desc_hint".tr(),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _submit,
                  icon: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.send, size: 18),
                  label: Text('nursery.send_request'.tr().toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, letterSpacing: 2)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _categoryCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const _Field({
    required this.label,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 2)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.04),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4F46E5)),
            ),
          ),
        ),
      ],
    );
  }
}
