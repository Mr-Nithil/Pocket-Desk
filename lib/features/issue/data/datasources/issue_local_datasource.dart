import 'package:pocket_desk/features/issue/data/models/issue_model.dart';

abstract interface class IssueLocalDatasource {
  List<IssueModel> getIssues(String userId);
  Future<IssueModel> addIssue(IssueModel issue);
  Future<void> deleteIssue(String id);
  Future<IssueModel> updateIssue(IssueModel issue);
}

class IssueLocalDatasourceImpl implements IssueLocalDatasource {
  @override
  Future<IssueModel> addIssue(IssueModel issue) {
    // TODO: implement addIssue
    throw UnimplementedError();
  }

  @override
  Future<void> deleteIssue(String id) {
    // TODO: implement deleteIssue
    throw UnimplementedError();
  }

  @override
  List<IssueModel> getIssues(String userId) {
    // TODO: implement getIssues
    throw UnimplementedError();
  }

  @override
  Future<IssueModel> updateIssue(IssueModel issue) {
    // TODO: implement updateIssue
    throw UnimplementedError();
  }
}
