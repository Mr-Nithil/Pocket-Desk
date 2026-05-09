import 'package:fpdart/src/either.dart';
import 'package:pocket_desk/core/error/exception.dart';
import 'package:pocket_desk/core/error/failure.dart';
import 'package:pocket_desk/features/issue/data/datasources/issue_local_datasource.dart';
import 'package:pocket_desk/features/issue/data/mappers/issue_mapper.dart';
import 'package:pocket_desk/features/issue/data/models/issue_model.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_query_params.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_stats.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/domain/repository/issue_repository.dart';

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
      final allIssues = issueLocalDatasource.getIssues(userId);
      int maxCode = 100;
      for (final issue in allIssues) {
        final match = RegExp(r'^IS-(\d+)').firstMatch(issue.id);
        if (match != null) {
          final codeNum = int.tryParse(match.group(1) ?? '0') ?? 0;
          if (codeNum > maxCode) maxCode = codeNum;
        }
      }
      final nextCode = maxCode + 1;
      final issueId = 'IS-$nextCode';

      final issue = IssueModel(
        id: issueId,
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

  @override
  Future<Either<Failure, List<Issue>>> queryIssues({
    required IssueQueryParams params,
  }) async {
    try {
      final issues = issueLocalDatasource.getIssues(params.userId);

      final q = params.query.toLowerCase().trim();

      final resultIssues = issues.where((issue) {
        final matchesSearch =
            q.isEmpty ||
            issue.title.toLowerCase().contains(q) ||
            (issue.description?.toLowerCase().contains(q) ?? false) ||
            issue.id.toLowerCase().contains(q);

        final matchesStatus =
            params.status == null || issue.status == params.status!.toData();

        final matchesPriority =
            params.priority == null ||
            issue.priority == params.priority!.toData();

        return matchesSearch && matchesStatus && matchesPriority;
      }).toList();

      return right(resultIssues.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, IssueStats>> getIssuesStats({
    required String userId,
  }) async {
    try {
      final issues = issueLocalDatasource.getIssues(userId);

      final openIssues = issues.where((issue) {
        final statusMatch = issue.status.toDomain() == IssueStatus.open;
        return statusMatch;
      }).toList();

      final inProgressIssues = issues.where((issue) {
        final statusMatch = issue.status.toDomain() == IssueStatus.inProgress;
        return statusMatch;
      }).toList();

      final resolvedIssues = issues.where((issue) {
        final statusMatch = issue.status.toDomain() == IssueStatus.resolved;
        return statusMatch;
      }).toList();

      return right(
        IssueStats(
          issueCount: issues.length,
          openCount: openIssues.length,
          inProgressCount: inProgressIssues.length,
          resolvedCount: resolvedIssues.length,
        ),
      );
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Issue>>> createMockIssues({
    required String userId,
  }) async {
    try {
      final mockIssues = [
        IssueModel(
          id: '001',
          userId: userId,
          title: "Implement Dark Mode Theme Support",
          description:
              "The application currently only supports a light theme. We need to implement a full Dark Mode toggle that adheres to system settings and provides a consistent UI across all components.\n\nRequirements:\n• Create a new ThemeExtension for custom colors.\n• Ensure all hardcoded hex values are replaced with dynamic theme references.\n• Implement a smooth transition animation when switching modes.\n• Audit the accessibility of text contrast in dark view.",
          createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        IssueModel(
          id: '002',
          userId: userId,
          title: "Refactor API Connectivity Layer",
          description:
              "The current implementation uses multiple Dio instances. We need a centralized singleton approach to handle interceptors, token refreshes, and error logging more efficiently.\n\nRequirements:\n• Implement a global error interceptor for 401 and 500 status codes.\n• Add logic to automatically refresh JWT tokens before expiration.\n• Integrate the Sentry SDK for real-time error tracking.\n• Cache GET requests locally using a Hive box for offline support.",
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        IssueModel(
          id: '003',
          userId: userId,
          title: "User Profile Revamp & Image Upload",
          description:
              "Users are requesting more customization for their profiles. We need to overhaul the profile editing screen to include a bio section and an avatar uploader.\n\nRequirements:\n• Integrate the image_picker package for gallery and camera access.\n• Add a cropping tool to ensure avatars are 1:1 aspect ratio.\n• Implement a character counter for the 'Bio' text field (max 250 chars).\n• Create a persistent storage path for local image caching.",
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];

      for (IssueModel issue in mockIssues) {
        await issueLocalDatasource.addIssue(issue);
      }

      final issues = issueLocalDatasource.getIssues(userId);

      return right(issues.map((issue) => issue.toEntity()).toList());
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
