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

  group('IssueSearch Hive Integration', () {
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
      'should return issues matching search query in title or description',
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
            status: IssueStatus.open,
            priority: IssuePriority.low,
            optionalAssignee: null,
          ),
          IssueCreateParams(
            userId: 'user1',
            title: 'Crash on save',
            description: 'App crashes when saving profile',
            status: IssueStatus.open,
            priority: IssuePriority.medium,
            optionalAssignee: null,
          ),
        ];
        for (final params in issuesToCreate) {
          final result = await issueCreate(params);
          expect(result.isRight(), true);
        }

        final searchResult1 = await repository.searchIssues(
          userId: 'user1',
          query: 'login',
        );
        expect(searchResult1.isRight(), true);
        searchResult1.fold((_) => fail('Should not fail'), (issues) {
          expect(issues.length, 1);
          expect(issues.first.title, contains('login'));
        });

        final searchResult2 = await repository.searchIssues(
          userId: 'user1',
          query: 'dashboard',
        );
        expect(searchResult2.isRight(), true);
        searchResult2.fold((_) => fail('Should not fail'), (issues) {
          expect(issues.length, 1);
          expect(issues.first.description, contains('dashboard'));
        });

        final searchResult3 = await repository.searchIssues(
          userId: 'user1',
          query: 'nonexistent',
        );
        expect(searchResult3.isRight(), true);
        searchResult3.fold((_) => fail('Should not fail'), (issues) {
          expect(issues.length, 0);
        });

        final searchResult4 = await repository.searchIssues(
          userId: 'user1',
          query: 'LOGIN',
        );
        expect(searchResult4.isRight(), true);
        searchResult4.fold((_) => fail('Should not fail'), (issues) {
          expect(issues.length, 1);
          expect(issues.first.title, contains('login'));
        });
      },
    );
  });
}
