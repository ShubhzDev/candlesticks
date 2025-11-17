import 'package:flutter/material.dart';
import '../models/drawing.dart';

class DrawingPainter extends CustomPainter {
  final List<Drawing> drawings;

  DrawingPainter(this.drawings);

  @override
  void paint(Canvas canvas, Size size) {
    for (var drawing in drawings) {
      // Highlight selected drawings
      Paint paint = Paint()
        ..color = drawing.isSelected ? Colors.blue : drawing.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = drawing.isSelected
            ? drawing.strokeWidth + 2.0
            : drawing.strokeWidth;

      for (int i = 0; i < drawing.points.length - 1; i++) {
        if (drawing.points[i] != null && drawing.points[i + 1] != null) {
          canvas.drawLine(drawing.points[i]!, drawing.points[i + 1]!, paint);
        }
      }

      // Draw selection handles at endpoints for selected drawings
      if (drawing.isSelected) {
        Paint handlePaint = Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill;

        for (var point in drawing.points) {
          if (point != null) {
            canvas.drawCircle(point, 6.0, handlePaint);
            canvas.drawCircle(
              point,
              4.0,
              Paint()
                ..color = Colors.white
                ..style = PaintingStyle.fill,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return drawings != oldDelegate.drawings;
  }
}

