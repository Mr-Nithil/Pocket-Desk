import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
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
import 'package:pocket_desk/features/issue/domain/usecases/issue_fetch_all.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('IssueCreate Hive Integration', () {
    late Directory tempDir;
    late Box<IssueModel> issueBox;
    late IssueLocalDatasourceImpl localDatasource;
    late IssueRepositoryImpl repository;
    late IssueCreate issueCreate;
    late IssueFetchAll issueFetchAll;

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
      issueFetchAll = IssueFetchAll(issueRepository: repository);
    });

    tearDownAll(() async {
      await issueBox.clear();
      await issueBox.close();
      await tempDir.delete(recursive: true);
    });

    test('should write issue to Hive box', () async {
      final params = IssueCreateParams(
        userId: 'user1',
        title: 'Test Issue',
        description: 'desc',
        status: IssueStatus.open,
        priority: IssuePriority.medium,
        optionalAssignee: null,
      );
      final result = await issueCreate(params);
      expect(result.isRight(), true);
      final issues = issueBox.values.toList();
      expect(issues.length, 1);
      expect(issues.first.title, 'Test Issue');
      expect(issues.first.userId, 'user1');
    });

    test('should fetch issues from Hive box', () async {
      final params = IssueFetchAllParams(userId: "user1");
      final result = await issueFetchAll(params);
      expect(result.isRight(), true);
      result.fold((_) => fail('Should not fail'), (issues) {
        print('Fetched issues: $issues');
        expect(issues.length, 1);
        expect(issues.first.title, 'Test Issue');
        expect(issues.first.userId, 'user1');
      });
    });
  });
}
