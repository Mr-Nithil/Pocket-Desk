import 'dart:io';
import 'package:pocket_desk/core/services/csv_export_service.dart';
import 'package:pocket_desk/core/services/image_storage_service.dart';
import 'package:pocket_desk/features/issue/data/models/issue_model.dart';

class MockImageStorageService implements ImageStorageService {
  @override
  Future<String> saveImage(String sourcePath) async => sourcePath;

  @override
  Future<void> deleteImage(String path) async {}
}

class MockCsvExportService implements CsvExportService {
  @override
  Future<File> exportIssuesToCsv(List<IssueModel> issues) async {
    final buffer = StringBuffer();
    buffer.writeln(
      'ID,Title,Description,Status,Priority,Assignee,Created At,Updated At',
    );
    for (final issue in issues) {
      buffer.writeln(
        [
          issue.id,
          issue.title,
          issue.description ?? '',
          issue.status.name,
          issue.priority.name,
          issue.optionalAssignee ?? '',
          issue.createdAt.toIso8601String(),
          issue.updatedAt?.toIso8601String() ?? '',
        ].join(','),
      );
    }
    final file = File(
      '${Directory.systemTemp.path}/test_export_${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    await file.writeAsString(buffer.toString());
    return file;
  }
}
