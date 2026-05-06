import 'package:fpdart/fpdart.dart';
import 'package:pocket_desk/core/error/failure.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';

abstract interface class IssueRepository {
  Future<Either<Failure, List<Issue>>> getIssues({required String userId});
  Future<Either<Failure, Issue>> addIssue({
    required String userId,
    required String title,
    String? description,
    IssueStatus? status,
    IssuePriority? priority,
    String? optionalAssignee,
  });
  Future<Either<Failure, void>> deleteIssue({required String id});
  Future<Either<Failure, Issue>> updateIssues({
    required String id,
    required String title,
    String? description,
    IssueStatus? status,
    IssuePriority? priority,
    String? optionalAssignee,
  });
}
