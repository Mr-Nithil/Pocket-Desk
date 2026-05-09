import 'package:flutter/material.dart';

class SummaryStatItem {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  SummaryStatItem({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });
}
