import 'dart:math';
import 'package:flutter/material.dart';

class GlowPainter extends CustomPainter {
  final double intensity; // 0.0 to 1.0
  final Color color;
  final double animationValue;

  GlowPainter({
    required this.intensity,
    required this.color,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = min(size.width, size.height) * 0.3;
    
    // Outer glow (soft)
    final outerPaint = Paint()
      ..color = color.withValues(alpha: 0.1 * intensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    
    // Inner pulse
    final pulseRadius = baseRadius * (1.0 + (0.1 * sin(animationValue * 2 * pi)));
    final pulsePaint = Paint()
      ..color = color.withValues(alpha: 0.3 * intensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    // Core light
    final corePaint = Paint()
      ..color = color.withValues(alpha: 0.6 * intensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawCircle(center, baseRadius * 1.5, outerPaint);
    canvas.drawCircle(center, pulseRadius, pulsePaint);
    canvas.drawCircle(center, baseRadius * 0.6, corePaint);
  }

  @override
  bool shouldRepaint(covariant GlowPainter oldDelegate) {
    return oldDelegate.intensity != intensity || 
           oldDelegate.color != color || 
           oldDelegate.animationValue != animationValue;
  }
}
