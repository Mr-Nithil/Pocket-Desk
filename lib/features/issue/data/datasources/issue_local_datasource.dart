import 'package:hive/hive.dart';
import 'package:pocket_desk/core/error/exception.dart';
import 'package:pocket_desk/features/issue/data/models/issue_model.dart';

abstract interface class IssueLocalDatasource {
  List<IssueModel> getIssues(String userId);
  Future<IssueModel> addIssue(IssueModel issue);
  Future<void> deleteIssue(String id, String userId);
  Future<IssueModel> updateIssue(IssueModel issue, String userId);
}

class IssueLocalDatasourceImpl implements IssueLocalDatasource {
  final Box<IssueModel> issueBox;

  IssueLocalDatasourceImpl({required this.issueBox});

  @override
  Future<IssueModel> addIssue(IssueModel issue) async {
    try {
      await issueBox.put(issue.id, issue);
      return issue;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteIssue(String id, String userId) async {
    try {
      final issue = issueBox.get(id);

      if (issue == null) {
        throw ServerException("Issue not found!");
      }

      if (issue.userId != userId) {
        throw ServerException("Unauthorized to delete!");
      }

      await issueBox.delete(id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  List<IssueModel> getIssues(String userId) {
    try {
      final issues = issueBox.values
          .where((issue) => issue.userId == userId)
          .toList();

      return issues;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<IssueModel> updateIssue(IssueModel issue, String userId) async {
    try {
      if (issue.userId != userId) {
        throw ServerException("Unauthorized to update!");
      }
      final key = issueBox.keys.firstWhere(
        (k) => issueBox.get(k)?.id == issue.id,
        orElse: () => throw Exception('Issue not found'),
      );

      await issueBox.put(key, issue);

      return issue;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
