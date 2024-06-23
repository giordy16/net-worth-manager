import 'package:flutter/material.dart';

class ChartUtils {
  static final pieColors = [
    Colors.lightBlueAccent,
    Colors.indigo,
    Colors.purple,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
  ];

  static getSliceColor(int index) {
    if (index < pieColors.length) return pieColors[index];
    return getSliceColor(index - pieColors.length);
  }
}
