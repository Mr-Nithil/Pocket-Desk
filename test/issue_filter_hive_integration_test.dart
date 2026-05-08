import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:pocket_desk/features/issue/data/models/issue_model.dart';
import 'package:pocket_desk/features/issue/data/datasources/issue_local_datasource.dart';
import 'package:pocket_desk/features/issue/data/models/issue_priority.dart'
    hide IssuePriority;
import 'package:pocket_desk/features/issue/data/models/issue_status.dart'
    hide IssueStatus;
import 'package:pocket_desk/features/issue/data/repository/issue_repository_impl.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_create.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('IssueFilter Hive Integration', () {
    late Directory tempDir;
    late Box<IssueModel> issueBox;
    late IssueLocalDatasourceImpl localDatasource;
    late IssueRepositoryImpl repository;
    late IssueCreate issueCreate;

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp();
      Hive.init(tempDir.path);
      Hive.registerAdapter(IssueStatusAdapter());
      Hive.registerAdapter(IssuePriorityAdapter());
      Hive.registerAdapter(IssueModelAdapter());
      issueBox = await Hive.openBox<IssueModel>('test_issues');
      localDatasource = IssueLocalDatasourceImpl(issueBox: issueBox);
      repository = IssueRepositoryImpl(issueLocalDatasource: localDatasource);
      issueCreate = IssueCreate(issueRepository: repository);
    });

    tearDownAll(() async {
      await issueBox.clear();
      await issueBox.close();
      await tempDir.delete(recursive: true);
    });

    test(
      'should return issues matching filter by status and priority',
      () async {
        final issuesToCreate = [
          IssueCreateParams(
            userId: 'user1',
            title: 'Fix login bug',
            description: 'Login fails on iOS',
            status: IssueStatus.open,
            priority: IssuePriority.high,
            optionalAssignee: null,
          ),
          IssueCreateParams(
            userId: 'user1',
            title: 'UI polish',
            description: 'Improve dashboard colors',
            status: IssueStatus.resolved,
            priority: IssuePriority.low,
            optionalAssignee: null,
          ),
          IssueCreateParams(
            userId: 'user1',
            title: 'Crash on save',
            description: 'App crashes when saving profile',
            status: IssueStatus.inProgress,
            priority: IssuePriority.medium,
            optionalAssignee: null,
          ),
        ];
        for (final params in issuesToCreate) {
          final result = await issueCreate(params);
          expect(result.isRight(), true);
        }

        // Filter by status: open
        final filterResult1 = await repository.filterIssues(
          userId: 'user1',
          status: IssueStatus.open,
          priority: null,
        );
        expect(filterResult1.isRight(), true);
        filterResult1.fold((_) => fail('Should not fail'), (issues) {
          expect(issues.length, 1);
          expect(issues.first.status, IssueStatus.open);
        });

        // Filter by priority: low
        final filterResult2 = await repository.filterIssues(
          userId: 'user1',
          status: null,
          priority: IssuePriority.low,
        );
        expect(filterResult2.isRight(), true);
        filterResult2.fold((_) => fail('Should not fail'), (issues) {
          expect(issues.length, 1);
          expect(issues.first.priority, IssuePriority.low);
        });

        // Filter by status: resolved and priority: low
        final filterResult3 = await repository.filterIssues(
          userId: 'user1',
          status: IssueStatus.resolved,
          priority: IssuePriority.low,
        );
        expect(filterResult3.isRight(), true);
        filterResult3.fold((_) => fail('Should not fail'), (issues) {
          expect(issues.length, 1);
          expect(issues.first.status, IssueStatus.resolved);
          expect(issues.first.priority, IssuePriority.low);
        });

        // Filter by status: open and priority: low (should be none)
        final filterResult4 = await repository.filterIssues(
          userId: 'user1',
          status: IssueStatus.open,
          priority: IssuePriority.low,
        );
        expect(filterResult4.isRight(), true);
        filterResult4.fold((_) => fail('Should not fail'), (issues) {
          expect(issues.length, 0);
        });
      },
    );
  });
}
