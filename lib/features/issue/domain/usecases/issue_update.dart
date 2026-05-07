import 'package:fpdart/src/either.dart';
import 'package:pocket_desk/core/error/failure.dart';
import 'package:pocket_desk/core/usecases/usecase.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/domain/repository/issue_repository.dart';

class IssueUpdate implements UseCase<Issue, IssueUpdateParams> {
  final IssueRepository issueRepository;

  IssueUpdate({required this.issueRepository});
  @override
  Future<Either<Failure, Issue>> call(IssueUpdateParams params) async {
    return await issueRepository.updateIssues(
      id: params.id,
      userId: params.userId,
      title: params.title,
      description: params.description,
      status: params.status,
      priority: params.priority,
      optionalAssignee: params.optionalAssignee,
    );
  }
}

class IssueUpdateParams {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final IssueStatus? status;
  final IssuePriority? priority;
  final String? optionalAssignee;

  IssueUpdateParams({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.optionalAssignee,
  });
}
