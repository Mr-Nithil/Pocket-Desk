import 'package:flutter/material.dart';
import 'package:pocket_desk/config/theme/color_palette.dart';

enum IssueStatus {
  open,
  inProgress,
  resolved,
  closed;

  String get uiName {
    if (this == IssueStatus.inProgress) return 'In Progress';
    return name[0].toUpperCase() + name.substring(1);
  }

  Color get color {
    switch (this) {
      case IssueStatus.open:
        return ColorPalette.statusOpen;

      case IssueStatus.inProgress:
        return ColorPalette.statusInProgress;

      case IssueStatus.resolved:
        return ColorPalette.statusResolved;

      case IssueStatus.closed:
        return ColorPalette.statusClosed;
    }
  }
}
