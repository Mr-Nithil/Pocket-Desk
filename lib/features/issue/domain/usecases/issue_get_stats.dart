import 'package:fpdart/src/either.dart';
import 'package:pocket_desk/core/error/failure.dart';
import 'package:pocket_desk/core/usecases/usecase.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_stats.dart';
import 'package:pocket_desk/features/issue/domain/repository/issue_repository.dart';

class IssueGetStats implements UseCase<IssueStats, IssueGetStatsParams> {
  final IssueRepository issueRepository;

  IssueGetStats({required this.issueRepository});
  @override
  Future<Either<Failure, IssueStats>> call(IssueGetStatsParams params) async {
    return await issueRepository.getIssuesStats(userId: params.userId);
  }
}

class IssueGetStatsParams {
  final String userId;

  IssueGetStatsParams({required this.userId});
}
