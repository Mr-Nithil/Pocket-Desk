import 'package:fpdart/src/either.dart';
import 'package:pocket_desk/core/error/failure.dart';
import 'package:pocket_desk/core/usecases/usecase.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/repository/issue_repository.dart';

class IssueFetchAll implements UseCase<List<Issue>, IssueFetchAllParams> {
  final IssueRepository issueRepository;

  IssueFetchAll({required this.issueRepository});
  @override
  Future<Either<Failure, List<Issue>>> call(IssueFetchAllParams params) async {
    return await issueRepository.getIssues(userId: params.userId);
  }
}

class IssueFetchAllParams {
  final String userId;

  IssueFetchAllParams({required this.userId});
}
