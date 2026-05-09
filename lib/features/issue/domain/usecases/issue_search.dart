import 'package:fpdart/src/either.dart';
import 'package:pocket_desk/core/error/failure.dart';
import 'package:pocket_desk/core/usecases/usecase.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/repository/issue_repository.dart';

class IssueSearch implements UseCase<List<Issue>, IssueSearchParams> {
  final IssueRepository issueRepository;

  IssueSearch({required this.issueRepository});
  @override
  Future<Either<Failure, List<Issue>>> call(IssueSearchParams params) async {
    return await issueRepository.searchIssues(
      userId: params.userId,
      query: params.query,
    );
  }
}

class IssueSearchParams {
  final String userId;
  final String query;

  IssueSearchParams({required this.userId, required this.query});
}
