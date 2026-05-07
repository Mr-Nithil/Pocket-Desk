import 'package:fpdart/src/either.dart';
import 'package:pocket_desk/core/error/exception.dart';
import 'package:pocket_desk/core/error/failure.dart';
import 'package:pocket_desk/features/issue/data/datasources/issue_local_datasource.dart';
import 'package:pocket_desk/features/issue/data/mappers/issue_mapper.dart';
import 'package:pocket_desk/features/issue/data/models/issue_model.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/domain/repository/issue_repository.dart';
import 'package:uuid/uuid.dart';

class IssueRepositoryImpl implements IssueRepository {
  final IssueLocalDatasource issueLocalDatasource;

  IssueRepositoryImpl({required this.issueLocalDatasource});
  @override
  Future<Either<Failure, Issue>> addIssue({
    required String userId,
    required String title,
    required String? description,
    required IssueStatus? status,
    required IssuePriority? priority,
    required String? optionalAssignee,
  }) async {
    try {
      final issue = IssueModel(
        id: Uuid().v4(),
        userId: userId,
        title: title,
        description: description ?? "",
        status: status!.toData(),
        priority: priority!.toData(),
        optionalAssignee: optionalAssignee ?? "",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final createdIssue = await issueLocalDatasource.addIssue(issue);

      return right(createdIssue.toEntity());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteIssue({
    required String id,
    required String userId,
  }) async {
    try {
      await issueLocalDatasource.deleteIssue(id, userId);

      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Issue>>> getIssues({
    required String userId,
  }) async {
    try {
      final issues = issueLocalDatasource.getIssues(userId);

      return right(issues.map((issue) => issue.toEntity()).toList());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Issue>> updateIssues({
    required String id,
    required String userId,
    required String title,
    required String? description,
    required IssueStatus? status,
    required IssuePriority? priority,
    required String? optionalAssignee,
  }) async {
    try {
      final existingIssue = issueLocalDatasource
          .getIssues(userId)
          .firstWhere((issue) => issue.id == id);

      final updatedIssue = existingIssue.copyWith(
        title: title,
        description: description,
        status: status!.toData(),
        priority: priority!.toData(),
        optionalAssignee: optionalAssignee,
        updatedAt: DateTime.now(),
      );

      final result = await issueLocalDatasource.updateIssue(
        updatedIssue,
        userId,
      );

      return right(result.toEntity());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
