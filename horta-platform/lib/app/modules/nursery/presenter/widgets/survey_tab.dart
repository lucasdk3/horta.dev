import 'package:flutter/material.dart';

class SurveyTab extends StatelessWidget {
  const SurveyTab({
    super.key,
    required this.number,
    required this.label,
    required this.sub,
    required this.icon,
  });

  final String number;
  final String label;
  final String sub;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$number. $label',
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1),
              ),
              Text(
                sub,
                style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: Colors.white38),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
