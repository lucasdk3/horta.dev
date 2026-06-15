import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';
import 'pill_button.dart';
import 'request_survey_modal.dart';

class NurseryHeroRow extends StatelessWidget {
  const NurseryHeroRow({super.key, required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final titleSize = isDesktop ? 88.0 : 42.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${'app.title'.tr().toUpperCase()}\n',
                      style: TextStyle(
                        color: HortaTheme.pageText(context),
                        fontSize: titleSize,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -4,
                        height: 0.9,
                      ),
                    ),
                    TextSpan(
                      text: 'nursery.subtitle'.tr().toUpperCase(),
                      style: TextStyle(
                        color: HortaTheme.pageText(context).withValues(alpha: 0.2),
                        fontSize: titleSize,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        letterSpacing: -4,
                        height: 0.9,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'nursery.description'.tr(),
                        style: const TextStyle(
                          color: HortaTheme.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    PillButton(
                      label: 'nursery.plant_idea'.tr(),
                      icon: Icons.add,
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => const RequestSurveyModal(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedPillButton(
                      label: 'nursery.garden_care'.tr(),
                      icon: Icons.shield_outlined,
                      onTap: () {},
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'nursery.description'.tr(),
                      style: const TextStyle(
                        color: HortaTheme.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        PillButton(
                          label: 'nursery.plant_idea'.tr(),
                          icon: Icons.add,
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) => const RequestSurveyModal(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedPillButton(
                          label: 'nursery.garden_care'.tr(),
                          icon: Icons.shield_outlined,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
