import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (status) {
      'approved' => (
          const Color(0xFF10B981),
          Colors.white,
          'admin.status_approved'.tr(),
        ),
      'rejected' => (
          Colors.red.withValues(alpha: 0.15),
          Colors.red,
          'admin.status_rejected'.tr(),
        ),
      _ => (
          const Color(0xFFF59E0B).withValues(alpha: 0.15),
          const Color(0xFFF59E0B),
          'admin.status_pending'.tr(),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
            color: fg,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 2),
      ),
    );
  }
}
