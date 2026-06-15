import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';

class NurseryEmptyState extends StatelessWidget {
  const NurseryEmptyState({super.key, required this.onSeed});

  final VoidCallback onSeed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_florist, size: 80, color: Color(0xFF10B981)),
          const SizedBox(height: 20),
          Text(
            'nursery.empty_state'.tr(),
            style: TextStyle(
              color: HortaTheme.pageText(context),
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'nursery.empty_subtitle'.tr(),
            style: const TextStyle(color: HortaTheme.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: onSeed,
            icon: const Icon(Icons.add, size: 18),
            label: Text(
              'nursery.sow_seeds'.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                fontSize: 12,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
