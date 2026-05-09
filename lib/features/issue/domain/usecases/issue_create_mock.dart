import 'package:fpdart/src/either.dart';
import 'package:pocket_desk/core/error/failure.dart';
import 'package:pocket_desk/core/usecases/usecase.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/repository/issue_repository.dart';

class IssueCreateMock implements UseCase<List<Issue>, IssueCreateMockParams> {
  final IssueRepository issueRepository;

  IssueCreateMock({required this.issueRepository});
  @override
  Future<Either<Failure, List<Issue>>> call(
    IssueCreateMockParams params,
  ) async {
    return await issueRepository.createMockIssues(userId: params.userId);
  }
}

class IssueCreateMockParams {
  final String userId;

  IssueCreateMockParams({required this.userId});
}
