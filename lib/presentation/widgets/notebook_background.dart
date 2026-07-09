import 'package:flutter/material.dart';

class NotebookBackground extends StatelessWidget {
  const NotebookBackground({
    super.key,
    this.child,
    this.baseColor = const Color(0xFFf8e3c6),
    this.lineColor = Colors.black,
    this.lineOpacity = 0.18,
    this.lineSpacing = 30,
    this.lineThickness = 1,
    this.topMargin = 24,
  });

  final Widget? child;
  final Color baseColor;
  final Color lineColor;
  final double lineOpacity;
  final double lineSpacing;
  final double lineThickness;
  final double topMargin;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: baseColor),
      child: CustomPaint(
        painter: _NotebookLinesPainter(
          lineColor: lineColor.withValues(alpha: lineOpacity),
          lineSpacing: lineSpacing,
          lineThickness: lineThickness,
          topMargin: topMargin,
        ),
        child: child,
      ),
    );
  }
}

class _NotebookLinesPainter extends CustomPainter {
  _NotebookLinesPainter({
    required this.lineColor,
    required this.lineSpacing,
    required this.lineThickness,
    required this.topMargin,
  });

  final Color lineColor;
  final double lineSpacing;
  final double lineThickness;
  final double topMargin;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineThickness;

    for (double y = topMargin; y < size.height; y += lineSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NotebookLinesPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.lineSpacing != lineSpacing ||
        oldDelegate.lineThickness != lineThickness ||
        oldDelegate.topMargin != topMargin;
  }
}
