import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pocket_desk/features/issue/data/models/issue_model.dart';

abstract interface class CsvExportService {
  Future<File> exportIssuesToCsv(List<IssueModel> issues);
}

class CsvExportServiceImpl implements CsvExportService {
  static const _headers = [
    'ID',
    'Title',
    'Description',
    'Status',
    'Priority',
    'Assignee',
    'Created At',
    'Updated At',
  ];

  @override
  Future<File> exportIssuesToCsv(List<IssueModel> issues) async {
    final buffer = StringBuffer();

    buffer.writeln(_headers.map(_escapeCsvField).join(','));

    for (final issue in issues) {
      final row = [
        issue.id,
        issue.title,
        issue.description ?? '',
        issue.status.name,
        issue.priority.name,
        issue.optionalAssignee ?? '',
        issue.createdAt.toIso8601String(),
        issue.updatedAt?.toIso8601String() ?? '',
      ].map(_escapeCsvField).join(',');

      buffer.writeln(row);
    }

    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/issues_export_$timestamp.csv');

    await file.writeAsString(buffer.toString());
    return file;
  }

  String _escapeCsvField(String field) {
    final needsQuoting =
        field.contains(',') ||
        field.contains('"') ||
        field.contains('\n') ||
        field.contains('\r');

    if (needsQuoting) {
      final escaped = field.replaceAll('"', '""');
      return '"$escaped"';
    }
    return field;
  }
}
