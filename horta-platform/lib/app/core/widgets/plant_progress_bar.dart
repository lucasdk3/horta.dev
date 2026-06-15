import 'package:flutter/material.dart';
import '../theme.dart';

class PlantProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0

  const PlantProgressBar({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: HortaTheme.darkSurface,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF047857), // Emerald-700
                HortaTheme.primaryEmerald, // Emerald-500
              ],
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
      ),
    );
  }
}
