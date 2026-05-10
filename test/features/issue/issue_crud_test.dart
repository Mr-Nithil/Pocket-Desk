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
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_create.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_delete.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_fetch_all.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_update.dart';

import '../../helpers/mock_services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Issue CRUD — Hive Integration', () {
    late Directory tempDir;
    late Box<IssueModel> issueBox;
    late IssueRepositoryImpl repository;
    late IssueCreate issueCreate;
    late IssueFetchAll issueFetchAll;
    late IssueUpdate issueUpdate;
    late IssueDelete issueDelete;

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp('issue_crud_');
      Hive.init(tempDir.path);
      Hive.registerAdapter(IssueStatusAdapter());
      Hive.registerAdapter(IssuePriorityAdapter());
      Hive.registerAdapter(IssueModelAdapter());
      issueBox = await Hive.openBox<IssueModel>('test_issues_crud');

      repository = IssueRepositoryImpl(
        issueLocalDatasource: IssueLocalDatasourceImpl(issueBox: issueBox),
        imageStorageService: MockImageStorageService(),
        csvExportService: MockCsvExportService(),
      );

      issueCreate = IssueCreate(issueRepository: repository);
      issueFetchAll = IssueFetchAll(issueRepository: repository);
      issueUpdate = IssueUpdate(issueRepository: repository);
      issueDelete = IssueDelete(issueRepository: repository);
    });

    tearDownAll(() async {
      await issueBox.clear();
      await issueBox.close();
      await Hive.deleteBoxFromDisk('test_issues_crud');
      await tempDir.delete(recursive: true);
    });

    test('should write issue to Hive box', () async {
      final result = await issueCreate(
        IssueCreateParams(
          userId: 'user1',
          title: 'Test Issue',
          description: 'desc',
          status: IssueStatus.open,
          priority: IssuePriority.medium,
          optionalAssignee: null,
          image: null,
        ),
      );
      expect(result.isRight(), true);
      expect(issueBox.values.length, 1);
      expect(issueBox.values.first.title, 'Test Issue');
    });

    test('should fetch issues from Hive box', () async {
      final result = await issueFetchAll(IssueFetchAllParams(userId: 'user1'));
      expect(result.isRight(), true);
      result.fold((_) => fail('Should not fail'), (issues) {
        expect(issues.length, 1);
        expect(issues.first.title, 'Test Issue');
      });
    });

    test('should update existing issue in Hive box', () async {
      final fetchResult = await issueFetchAll(
        IssueFetchAllParams(userId: 'user1'),
      );
      final oldIssue = fetchResult.getOrElse((_) => []).first;

      final updateResult = await issueUpdate(
        IssueUpdateParams(
          id: oldIssue.id,
          userId: oldIssue.userId,
          title: 'Updated Title',
          description: 'Updated description',
          status: oldIssue.status,
          priority: IssuePriority.high,
          optionalAssignee: 'assignee2',
          image: null,
        ),
      );
      expect(updateResult.isRight(), true);

      final verifyResult = await issueFetchAll(
        IssueFetchAllParams(userId: 'user1'),
      );
      verifyResult.fold((_) => fail('Should not fail'), (issues) {
        expect(issues.first.title, 'Updated Title');
        expect(issues.first.priority, IssuePriority.high);
        expect(issues.first.optionalAssignee, 'assignee2');
      });
    });

    test('should delete issue from Hive box', () async {
      final fetchResult = await issueFetchAll(
        IssueFetchAllParams(userId: 'user1'),
      );
      final issue = fetchResult.getOrElse((_) => []).first;

      await issueDelete(IssueDeleteParams(id: issue.id, userId: issue.userId));

      final verifyResult = await issueFetchAll(
        IssueFetchAllParams(userId: 'user1'),
      );
      verifyResult.fold((_) => fail('Should not fail'), (issues) {
        expect(issues.length, 0);
      });
    });
  });
}
