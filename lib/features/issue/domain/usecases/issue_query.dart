import 'package:fpdart/fpdart.dart';
import 'package:pocket_desk/core/error/failure.dart';
import 'package:pocket_desk/core/usecases/usecase.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_query_params.dart';
import 'package:pocket_desk/features/issue/domain/repository/issue_repository.dart';

class IssueQuery implements UseCase<List<Issue>, IssueQueryParams> {
  final IssueRepository issueRepository;

  IssueQuery({required this.issueRepository});

  @override
  Future<Either<Failure, List<Issue>>> call(IssueQueryParams params) async {
    return await issueRepository.queryIssues(params: params);
  }
}
