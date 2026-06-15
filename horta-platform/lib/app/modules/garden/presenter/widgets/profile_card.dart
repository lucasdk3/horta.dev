import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../domain/entities/user_profile.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.profile,
    required this.progressAnim,
  });

  final UserProfile profile;
  final Animation<double> progressAnim;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.2)),
              ),
              child: Icon(_stageIcon(profile.level),
                  color: const Color(0xFF10B981), size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile.displayName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(
                    '${profile.stageName.toUpperCase()}  |  STG ${profile.level}',
                    style: const TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3),
                  ),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text('${profile.level}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900)),
            ),
          ]),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Icon(Icons.water_drop,
                    size: 12, color: Color(0xFF10B981)),
                const SizedBox(width: 4),
                Text('garden.drops'.tr().toUpperCase(),
                    style: const TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3)),
              ]),
              Text('${profile.xp} / ${profile.xpToNextLevel}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 6),
          AnimatedBuilder(
            animation: progressAnim,
            builder: (_, __) => ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: Stack(children: [
                Container(height: 8, color: const Color(0xFF052E16)),
                FractionallySizedBox(
                  widthFactor: progressAnim.value,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  IconData _stageIcon(int level) {
    if (level >= 5) return Icons.forest;
    if (level >= 2) return Icons.eco;
    return Icons.water_drop;
  }
}
