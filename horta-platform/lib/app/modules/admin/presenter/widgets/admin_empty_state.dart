import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AdminEmptyState extends StatelessWidget {
  const AdminEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
            ),
            child: const Icon(Icons.article_outlined,
                size: 36, color: Color(0xFF334155)),
          ),
          const SizedBox(height: 16),
          Text(
            'admin.no_requests'.tr(),
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }
}
