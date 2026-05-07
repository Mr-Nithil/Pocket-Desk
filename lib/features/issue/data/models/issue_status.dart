import 'package:hive/hive.dart';

part 'issue_status.g.dart';

@HiveType(typeId: 0)
enum IssueStatus {
  @HiveField(0)
  open,
  @HiveField(1)
  inProgress,
  @HiveField(2)
  resolved,
  @HiveField(3)
  closed;

  String get uiName {
    if (this == IssueStatus.inProgress) return 'In Progress';
    return name[0].toUpperCase() + name.substring(1);
  }
}
