import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/horta_logo.dart';

class PublicTopBar extends StatelessWidget {
  const PublicTopBar({super.key, this.surveyTitle});

  final String? surveyTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          const HortaLogo(size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              surveyTitle ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.go('/login'),
            style: TextButton.styleFrom(
              foregroundColor: HortaTheme.primaryEmerald,
            ),
            child: Text(
              'survey.login_cta'.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
