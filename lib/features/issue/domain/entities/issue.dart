import 'package:hive/hive.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';

part 'issue.g.dart';

@HiveType(typeId: 2)
class Issue {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final IssueStatus status;
  @HiveField(5)
  final IssuePriority priority;
  @HiveField(6)
  final DateTime createdAt;
  @HiveField(7)
  final DateTime? updatedAt;
  @HiveField(8)
  final String? optionalAssignee;
  Issue({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    required this.optionalAssignee,
  });
}
