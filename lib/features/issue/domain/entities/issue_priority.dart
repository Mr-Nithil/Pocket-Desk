enum IssuePriority {
  low,
  medium,
  high;

  String get uiName => name[0].toUpperCase() + name.substring(1);
}
