import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme.dart';

class AboutHeroHeader extends StatelessWidget {
  const AboutHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () => context.go('/nursery'),
          icon: const Icon(Icons.arrow_back,
              size: 16, color: Color(0xFF10B981)),
          label: Text(
            'common.back'.tr().toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF10B981),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
        ),
        const SizedBox(height: 24),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${'app.title'.tr().toUpperCase()}\n',
                style: TextStyle(
                  color: HortaTheme.pageText(context),
                  fontSize: 72,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -4,
                  height: 0.9,
                ),
              ),
              TextSpan(
                text: 'ECOSYSTEM',
                style: TextStyle(
                  color: HortaTheme.pageText(context).withValues(alpha: 0.2),
                  fontSize: 72,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -4,
                  height: 0.9,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'about.hero_subtitle'.tr(),
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
