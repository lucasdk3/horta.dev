import 'package:flutter/material.dart';

class ActionBtn extends StatelessWidget {
  const ActionBtn({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    this.ghost = false,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool ghost;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: ghost ? Colors.transparent : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: ghost
                ? Colors.white.withValues(alpha: 0.08)
                : color.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(icon, size: 16, color: ghost ? Colors.white30 : color),
      ),
    );
  }
}
