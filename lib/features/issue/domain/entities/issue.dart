import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';

class Issue {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final IssueStatus status;
  final IssuePriority priority;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? optionalAssignee;
  Issue({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.updatedAt,
    this.optionalAssignee,
  });

  @override
  String toString() {
    return 'Issue(id: $id, userId: $userId, title: $title, description: $description, status: $status, priority: $priority, createdAt: $createdAt, updatedAt: $updatedAt, optionalAssignee: $optionalAssignee)';
  }
}
