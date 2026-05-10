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
import 'package:pocket_desk/features/issue/domain/usecases/issue_export_csv.dart';

import '../../helpers/mock_services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('IssueExportCsv — Hive Integration', () {
    late Directory tempDir;
    late Box<IssueModel> issueBox;
    late IssueRepositoryImpl repository;
    late IssueCreate issueCreate;
    late IssueExportCsv issueExportCsv;

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp('issue_export_');
      Hive.init(tempDir.path);
      Hive.registerAdapter(IssueStatusAdapter());
      Hive.registerAdapter(IssuePriorityAdapter());
      Hive.registerAdapter(IssueModelAdapter());
      issueBox = await Hive.openBox<IssueModel>('test_issues_export');

      repository = IssueRepositoryImpl(
        issueLocalDatasource: IssueLocalDatasourceImpl(issueBox: issueBox),
        imageStorageService: MockImageStorageService(),
        csvExportService: MockCsvExportService(),
      );

      issueCreate = IssueCreate(issueRepository: repository);
      issueExportCsv = IssueExportCsv(issueRepository: repository);

      for (final p in [
        IssueCreateParams(
          userId: 'user1',
          title: 'Fix login bug',
          description: 'Login fails on iOS',
          status: IssueStatus.open,
          priority: IssuePriority.high,
          optionalAssignee: 'alice',
          image: null,
        ),
        IssueCreateParams(
          userId: 'user1',
          title: 'UI polish',
          description: 'Improve dashboard',
          status: IssueStatus.resolved,
          priority: IssuePriority.low,
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
      await Hive.deleteBoxFromDisk('test_issues_export');
      await tempDir.delete(recursive: true);
    });

    test('should return a File', () async {
      final result = await issueExportCsv(
        IssueExportCsvParams(userId: 'user1'),
      );
      expect(result.isRight(), true);
      result.fold((_) => fail('Should not fail'), (file) {
        expect(file, isA<File>());
        expect(file.existsSync(), true);
      });
    });

    test('exported file should contain CSV header row', () async {
      final result = await issueExportCsv(
        IssueExportCsvParams(userId: 'user1'),
      );
      result.fold((_) => fail('Should not fail'), (file) {
        final lines = file.readAsLinesSync();
        expect(lines.first, contains('ID'));
        expect(lines.first, contains('Title'));
        expect(lines.first, contains('Status'));
        expect(lines.first, contains('Priority'));
      });
    });

    test('exported file should have a row per issue', () async {
      final result = await issueExportCsv(
        IssueExportCsvParams(userId: 'user1'),
      );
      result.fold((_) => fail('Should not fail'), (file) {
        final lines = file
            .readAsLinesSync()
            .where((l) => l.isNotEmpty)
            .toList();
        expect(lines.length, 3);
      });
    });

    test('exported file should contain issue data', () async {
      final result = await issueExportCsv(
        IssueExportCsvParams(userId: 'user1'),
      );
      result.fold((_) => fail('Should not fail'), (file) {
        final content = file.readAsStringSync();
        expect(content, contains('Fix login bug'));
        expect(content, contains('UI polish'));
        expect(content, contains('high'));
        expect(content, contains('alice'));
      });
    });

    test('should return failure for unknown userId', () async {
      final result = await issueExportCsv(
        IssueExportCsvParams(userId: 'ghost'),
      );
      result.fold((_) => fail('Should not fail'), (file) {
        final lines = file
            .readAsLinesSync()
            .where((l) => l.isNotEmpty)
            .toList();
        expect(lines.length, 1);
      });
    });
  });
}
