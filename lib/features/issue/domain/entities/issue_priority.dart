import 'package:flutter/material.dart';
import 'package:pocket_desk/config/theme/color_palette.dart';

enum IssuePriority {
  low,
  medium,
  high;

  String get uiName => name[0].toUpperCase() + name.substring(1);

  Color get color {
    switch (this) {
      case IssuePriority.low:
        return ColorPalette.priorityLow;

      case IssuePriority.medium:
        return ColorPalette.priorityMedium;

      case IssuePriority.high:
        return ColorPalette.priorityHigh;
    }
  }
}
