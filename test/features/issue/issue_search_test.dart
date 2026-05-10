import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:pocket_desk/features/issue/data/datasources/issue_local_datasource.dart';
import 'package:pocket_desk/features/issue/data/models/issue_model.dart';
import 'package:pocket_desk/features/issue/data/models/issue_priority.dart'
    hide IssuePriority;
import 'package:pocket_desk/features/issue/data/models/issue_status.dart'
    hide IssueStatus;
import 'package:pocket_desk/features/issue/data/repository/issue_repository_impl.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_query_params.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_create.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_query.dart';

import '../../helpers/mock_services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Issue Search — Hive Integration', () {
    late Directory tempDir;
    late Box<IssueModel> issueBox;
    late IssueRepositoryImpl repository;
    late IssueCreate issueCreate;
    late IssueQuery issueQuery;
    String? firstIssueId;

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp('issue_search_');
      Hive.init(tempDir.path);
      Hive.registerAdapter(IssueStatusAdapter());
      Hive.registerAdapter(IssuePriorityAdapter());
      Hive.registerAdapter(IssueModelAdapter());
      issueBox = await Hive.openBox<IssueModel>('test_issues_search');

      repository = IssueRepositoryImpl(
        issueLocalDatasource: IssueLocalDatasourceImpl(issueBox: issueBox),
        imageStorageService: MockImageStorageService(),
        csvExportService: MockCsvExportService(),
      );

      issueCreate = IssueCreate(issueRepository: repository);
      issueQuery = IssueQuery(issueRepository: repository);

      final seeds = [
        IssueCreateParams(
          userId: 'user1',
          title: 'Fix login bug',
          description: 'Login fails on iOS',
          status: IssueStatus.open,
          priority: IssuePriority.high,
          optionalAssignee: null,
          image: null,
        ),
        IssueCreateParams(
          userId: 'user1',
          title: 'UI polish',
          description: 'Improve dashboard colors',
          status: IssueStatus.open,
          priority: IssuePriority.low,
          optionalAssignee: null,
          image: null,
        ),
        IssueCreateParams(
          userId: 'user1',
          title: 'Crash on save',
          description: 'App crashes when saving profile',
          status: IssueStatus.open,
          priority: IssuePriority.medium,
          optionalAssignee: null,
          image: null,
        ),
      ];

      for (int i = 0; i < seeds.length; i++) {
        final result = await issueCreate(seeds[i]);
        expect(result.isRight(), true);
        if (i == 0) result.fold((_) {}, (issue) => firstIssueId = issue.id);
      }
    });

    tearDownAll(() async {
      await issueBox.clear();
      await issueBox.close();
      await Hive.deleteBoxFromDisk('test_issues_search');
      await tempDir.delete(recursive: true);
    });

    Future<List> search(String q) async {
      final result = await issueQuery(
        IssueQueryParams(
          userId: 'user1',
          query: q,
          status: null,
          priority: null,
        ),
      );
      return result.getOrElse((_) => []);
    }

    test('match by title keyword', () async {
      final issues = await search('login');
      expect(issues.length, 1);
      expect(issues.first.title.toLowerCase(), contains('login'));
    });

    test('match by description keyword', () async {
      final issues = await search('dashboard');
      expect(issues.length, 1);
      expect(issues.first.description?.toLowerCase(), contains('dashboard'));
    });

    test('no match returns empty list', () async {
      final issues = await search('nonexistent');
      expect(issues.length, 0);
    });

    test('search is case-insensitive', () async {
      final issues = await search('LOGIN');
      expect(issues.length, 1);
      expect(issues.first.title.toLowerCase(), contains('login'));
    });

    test('match by issue ID', () async {
      expect(firstIssueId, isNotNull);
      final issues = await search(firstIssueId!);
      expect(issues.length, 1);
      expect(issues.first.id, firstIssueId);
    });
  });
}
