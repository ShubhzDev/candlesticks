import 'package:flutter/material.dart';
import '../models/drawing.dart';
import 'dart:math' as math;

class DrawingController extends ChangeNotifier {
  final List<Drawing> _drawings = [];
  Drawing? _currentDrawing;
  bool _isDrawingMode = false;
  Offset? _startPoint;
  int _drawingCounter = 0;
  Drawing? _selectedDrawing;
  Offset? _dragOffset;

  List<Drawing> get drawings => List.unmodifiable(_drawings);
  bool get isDrawingMode => _isDrawingMode;
  Drawing? get selectedDrawing => _selectedDrawing;

  void toggleDrawingMode() {
    _isDrawingMode = !_isDrawingMode;
    if (_isDrawingMode) {
      // Deselect when entering drawing mode
      deselectAll();
    }
    notifyListeners();
  }

  void startDrawing(Offset point) {
    if (_isDrawingMode) {
      // Drawing mode: create a new line
      _startPoint = point;
      _drawingCounter++;
      _currentDrawing = Drawing(
        name: 'Line $_drawingCounter',
        points: [point, point, null], // Start, end (same initially), separator
        color: Colors.black,
        strokeWidth: 2.0,
      );
      notifyListeners();
    } else {
      // Selection/Move mode: check if tapping on a line
      Drawing? tappedDrawing = _findDrawingNearPoint(point);
      if (tappedDrawing != null) {
        if (_selectedDrawing == tappedDrawing) {
          // Start dragging the selected line
          _dragOffset = point;
        } else {
          // Select this line
          selectDrawing(tappedDrawing);
        }
      } else {
        // Deselect if tapping on empty space
        deselectAll();
      }
      notifyListeners();
    }
  }

  void updateDrawing(Offset point) {
    if (_isDrawingMode && _currentDrawing != null && _startPoint != null) {
      // Update the line preview: keep start point, update end point
      _currentDrawing = Drawing(
        name: _currentDrawing!.name,
        points: [_startPoint!, point, null],
        color: Colors.black,
        strokeWidth: 2.0,
      );
      notifyListeners();
    } else if (!_isDrawingMode && _selectedDrawing != null && _dragOffset != null) {
      // Move the selected line
      Offset delta = point - _dragOffset!;
      _dragOffset = point;
      moveSelectedDrawing(delta);
    }
  }

  void endDrawing() {
    if (_isDrawingMode && _currentDrawing != null) {
      _drawings.add(_currentDrawing!);
      _currentDrawing = null;
      _startPoint = null;
      notifyListeners();
    } else if (!_isDrawingMode) {
      _dragOffset = null;
    }
  }

  void selectDrawing(Drawing drawing) {
    // Deselect all first
    _drawings.replaceRange(
      0,
      _drawings.length,
      _drawings.map((d) => d.copyWith(isSelected: false)).toList(),
    );

    // Select the target drawing
    int index = _drawings.indexWhere((d) => d == drawing);
    if (index != -1) {
      _drawings[index] = _drawings[index].copyWith(isSelected: true);
      _selectedDrawing = _drawings[index];
    }
    notifyListeners();
  }

  void deselectAll() {
    _drawings.replaceRange(
      0,
      _drawings.length,
      _drawings.map((d) => d.copyWith(isSelected: false)).toList(),
    );
    _selectedDrawing = null;
    _dragOffset = null;
    notifyListeners();
  }

  void deleteSelectedDrawing() {
    if (_selectedDrawing != null) {
      _drawings.removeWhere((drawing) => drawing == _selectedDrawing);
      _selectedDrawing = null;
      notifyListeners();
    }
  }

  void moveSelectedDrawing(Offset delta) {
    if (_selectedDrawing == null) return;

    int index = _drawings.indexWhere((d) => d == _selectedDrawing);
    if (index != -1) {
      List<Offset?> newPoints = _drawings[index].points.map((p) {
        if (p != null) {
          return p + delta;
        }
        return null;
      }).toList();

      _drawings[index] = _drawings[index].copyWith(points: newPoints);
      _selectedDrawing = _drawings[index];
      notifyListeners();
    }
  }

  Drawing? _findDrawingNearPoint(Offset point, {double threshold = 20.0}) {
    for (var drawing in _drawings.reversed) {
      for (int i = 0; i < drawing.points.length - 1; i++) {
        if (drawing.points[i] != null && drawing.points[i + 1] != null) {
          double distance = _distanceToLineSegment(
            point,
            drawing.points[i]!,
            drawing.points[i + 1]!,
          );
          if (distance < threshold) {
            return drawing;
          }
        }
      }
    }
    return null;
  }

  double _distanceToLineSegment(Offset point, Offset lineStart, Offset lineEnd) {
    double dx = lineEnd.dx - lineStart.dx;
    double dy = lineEnd.dy - lineStart.dy;

    if (dx == 0 && dy == 0) {
      // Line segment is a point
      return math.sqrt(
        math.pow(point.dx - lineStart.dx, 2) + math.pow(point.dy - lineStart.dy, 2)
      );
    }

    double t = ((point.dx - lineStart.dx) * dx + (point.dy - lineStart.dy) * dy) /
        (dx * dx + dy * dy);

    t = math.max(0, math.min(1, t));

    double nearestX = lineStart.dx + t * dx;
    double nearestY = lineStart.dy + t * dy;

    return math.sqrt(
      math.pow(point.dx - nearestX, 2) + math.pow(point.dy - nearestY, 2)
    );
  }

  void removeDrawing(String name) {
    _drawings.removeWhere((drawing) => drawing.name == name);
    if (_selectedDrawing?.name == name) {
      _selectedDrawing = null;
    }
    notifyListeners();
  }

  List<Drawing> getAllDrawings() {
    if (_currentDrawing != null && _currentDrawing!.points.isNotEmpty) {
      return [..._drawings, _currentDrawing!];
    }
    return _drawings;
  }
}

