import 'package:flutter/material.dart';

/// SVG-equivalent Logo using CustomPainter — matches Logo.tsx style
/// (emerald leaf silhouette with slash mark like a sprout)
class HortaLogo extends StatelessWidget {
  final double size;

  const HortaLogo({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LogoPainter(),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final emerald = const Color(0xFF10B981);

    // Background circle
    final bgPaint = Paint()..color = emerald.withValues(alpha: 0.15);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      bgPaint,
    );

    // Leaf/sprout shape
    final leafPaint = Paint()
      ..color = emerald
      ..style = PaintingStyle.fill;

    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.28;

    // Left leaf
    path.moveTo(cx, cy + r);
    path.cubicTo(
        cx - r * 1.5, cy, cx - r * 1.5, cy - r * 1.5, cx, cy - r * 0.3);

    // Right leaf
    path.moveTo(cx, cy + r);
    path.cubicTo(
        cx + r * 1.5, cy, cx + r * 1.5, cy - r * 1.5, cx, cy - r * 0.3);

    canvas.drawPath(path, leafPaint);

    // Stem
    final stemPaint = Paint()
      ..color = emerald
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(cx, cy + r),
      Offset(cx, cy - r * 0.3),
      stemPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
