import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';

class IssueQueryParams {
  final String userId;
  final String query;
  final IssueStatus? status;
  final IssuePriority? priority;

  const IssueQueryParams({
    required this.userId,
    this.query = '',
    this.status,
    this.priority,
  });

  IssueQueryParams copyWith({
    String? query,
    IssueStatus? status,
    IssuePriority? priority,
  }) {
    return IssueQueryParams(
      userId: userId,
      query: query ?? this.query,
      status: status ?? this.status,
      priority: priority ?? this.priority,
    );
  }
}
