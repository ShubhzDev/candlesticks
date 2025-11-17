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
        Paint handleOuterPaint = Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill;

        Paint handleInnerPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

        Paint handleBorderPaint = Paint()
          ..color = Colors.blue.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

        // Draw handles only at actual endpoints (not null separators)
        for (var point in drawing.points) {
          if (point != null && point != drawing.points.last) {
            // Draw outer glow/border for better visibility
            canvas.drawCircle(point, 10.0, handleBorderPaint);
            // Draw outer circle
            canvas.drawCircle(point, 8.0, handleOuterPaint);
            // Draw inner circle
            canvas.drawCircle(point, 5.0, handleInnerPaint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    // Always repaint since Drawing instances are recreated on each update
    // This ensures smooth real-time updates during dragging
    return true;
  }
}

