import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:pocket_desk/core/error/failure.dart';
import 'package:pocket_desk/core/usecases/usecase.dart';
import 'package:pocket_desk/features/issue/domain/repository/issue_repository.dart';

class IssueExportCsv implements UseCase<File, IssueExportCsvParams> {
  final IssueRepository issueRepository;

  IssueExportCsv({required this.issueRepository});

  @override
  Future<Either<Failure, File>> call(IssueExportCsvParams params) {
    return issueRepository.exportIssuesToCsv(userId: params.userId);
  }
}

class IssueExportCsvParams {
  final String userId;

  IssueExportCsvParams({required this.userId});
}
