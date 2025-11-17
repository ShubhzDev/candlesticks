import 'package:flutter/material.dart';

class Drawing {
  final String name;
  final List<Offset?> points;
  final Color color;
  final double strokeWidth;
  final bool isSelected;

  Drawing({
    required this.name,
    required this.points,
    this.color = Colors.black,
    this.strokeWidth = 3.0,
    this.isSelected = false,
  });

  Drawing copyWith({
    String? name,
    List<Offset?>? points,
    Color? color,
    double? strokeWidth,
    bool? isSelected,
  }) {
    return Drawing(
      name: name ?? this.name,
      points: points ?? this.points,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  bool operator ==(other) {
    if (other is Drawing) {
      return other.name == this.name;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => name.hashCode;
}

