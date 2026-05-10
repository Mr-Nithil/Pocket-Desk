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

  group('Issue Filter — Hive Integration', () {
    late Directory tempDir;
    late Box<IssueModel> issueBox;
    late IssueRepositoryImpl repository;
    late IssueCreate issueCreate;
    late IssueQuery issueQuery;

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp('issue_filter_');
      Hive.init(tempDir.path);
      Hive.registerAdapter(IssueStatusAdapter());
      Hive.registerAdapter(IssuePriorityAdapter());
      Hive.registerAdapter(IssueModelAdapter());
      issueBox = await Hive.openBox<IssueModel>('test_issues_filter');

      repository = IssueRepositoryImpl(
        issueLocalDatasource: IssueLocalDatasourceImpl(issueBox: issueBox),
        imageStorageService: MockImageStorageService(),
        csvExportService: MockCsvExportService(),
      );

      issueCreate = IssueCreate(issueRepository: repository);
      issueQuery = IssueQuery(issueRepository: repository);

      for (final p in [
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
          status: IssueStatus.resolved,
          priority: IssuePriority.low,
          optionalAssignee: null,
          image: null,
        ),
        IssueCreateParams(
          userId: 'user1',
          title: 'Crash on save',
          description: 'App crashes when saving profile',
          status: IssueStatus.inProgress,
          priority: IssuePriority.medium,
          optionalAssignee: null,
          image: null,
        ),
      ]) {
        expect((await issueCreate(p)).isRight(), true);
      }
    });

    tearDownAll(() async {
      await issueBox.clear();
      await issueBox.close();
      await Hive.deleteBoxFromDisk('test_issues_filter');
      await tempDir.delete(recursive: true);
    });

    Future<List> query({
      String q = '',
      IssueStatus? status,
      IssuePriority? priority,
    }) async {
      final result = await issueQuery(
        IssueQueryParams(
          userId: 'user1',
          query: q,
          status: status,
          priority: priority,
        ),
      );
      return result.getOrElse((_) => []);
    }

    test('filter by status: open', () async {
      final issues = await query(status: IssueStatus.open);
      expect(issues.length, 1);
      expect(issues.first.status, IssueStatus.open);
    });

    test('filter by priority: low', () async {
      final issues = await query(priority: IssuePriority.low);
      expect(issues.length, 1);
      expect(issues.first.priority, IssuePriority.low);
    });

    test('filter by status: resolved AND priority: low', () async {
      final issues = await query(
        status: IssueStatus.resolved,
        priority: IssuePriority.low,
      );
      expect(issues.length, 1);
      expect(issues.first.status, IssueStatus.resolved);
      expect(issues.first.priority, IssuePriority.low);
    });

    test(
      'filter by status: open AND priority: low — should return none',
      () async {
        final issues = await query(
          status: IssueStatus.open,
          priority: IssuePriority.low,
        );
        expect(issues.length, 0);
      },
    );
  });
}
