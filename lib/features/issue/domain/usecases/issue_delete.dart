import 'package:fpdart/src/either.dart';
import 'package:pocket_desk/core/error/failure.dart';
import 'package:pocket_desk/core/usecases/usecase.dart';
import 'package:pocket_desk/features/issue/domain/repository/issue_repository.dart';

class IssueDelete implements UseCase<void, IssueDeleteParams> {
  final IssueRepository issueRepository;

  IssueDelete({required this.issueRepository});
  @override
  Future<Either<Failure, void>> call(IssueDeleteParams params) async {
    return issueRepository.deleteIssue(id: params.id, userId: params.userId);
  }
}

class IssueDeleteParams {
  final String id;
  final String userId;

  IssueDeleteParams({required this.id, required this.userId});
}
