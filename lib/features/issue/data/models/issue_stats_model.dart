import 'package:pocket_desk/features/issue/domain/entities/issue_stats.dart';

class IssueStatsModel extends IssueStats {
  IssueStatsModel({
    required super.issueCount,
    required super.openCount,
    required super.inProgressCount,
    required super.resolvedCount,
  });
}
