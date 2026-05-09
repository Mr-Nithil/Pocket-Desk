import 'package:fpdart/src/either.dart';
import 'package:pocket_desk/core/error/failure.dart';
import 'package:pocket_desk/core/usecases/usecase.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/domain/repository/issue_repository.dart';

class IssueFilter implements UseCase<List<Issue>, IssueFilterParams> {
  final IssueRepository issueRepository;

  IssueFilter({required this.issueRepository});
  @override
  Future<Either<Failure, List<Issue>>> call(IssueFilterParams params) async {
    return await issueRepository.filterIssues(
      userId: params.userId,
      status: params.status,
      priority: params.priority,
    );
  }
}

class IssueFilterParams {
  final String userId;
  final IssueStatus? status;
  final IssuePriority? priority;

  IssueFilterParams({required this.userId, this.status, this.priority});
}
