import 'package:hive/hive.dart';

part 'issue_priority.g.dart';

@HiveType(typeId: 1)
enum IssuePriority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high;

  String get uiName => name[0].toUpperCase() + name.substring(1);
}
