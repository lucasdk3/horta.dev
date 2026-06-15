import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';

class AdminPageHeader extends StatelessWidget {
  const AdminPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('app.admin'.tr().toUpperCase(),
            style: const TextStyle(
                color: Color(0xFF10B981),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 4)),
        const SizedBox(height: 4),
        Text('admin.requests_title'.tr(),
            style: TextStyle(
                color: HortaTheme.pageText(context),
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.5)),
        const SizedBox(height: 4),
        Text('admin.requests_subtitle'.tr(),
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
      ],
    );
  }
}
