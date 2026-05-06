import 'package:fpdart/src/either.dart';
import 'package:pocket_desk/core/error/failure.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/domain/repository/issue_repository.dart';

class IssueRepositoryImpl implements IssueRepository {
  @override
  Future<Either<Failure, Issue>> addIssue({
    required String userId,
    required String title,
    String? description,
    IssueStatus? status,
    IssuePriority? priority,
    String? optionalAssignee,
  }) {
    // TODO: implement addIssue
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteIssue({required String id}) {
    // TODO: implement deleteIssue
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Issue>>> getIssues({required String userId}) {
    // TODO: implement getIssues
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Issue>> updateIssues({
    required String id,
    required String title,
    String? description,
    IssueStatus? status,
    IssuePriority? priority,
    String? optionalAssignee,
  }) {
    // TODO: implement updateIssues
    throw UnimplementedError();
  }
}
