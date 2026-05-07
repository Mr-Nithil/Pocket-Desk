// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IssueStatusAdapter extends TypeAdapter<IssueStatus> {
  @override
  final int typeId = 0;

  @override
  IssueStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IssueStatus.open;
      case 1:
        return IssueStatus.inProgress;
      case 2:
        return IssueStatus.resolved;
      case 3:
        return IssueStatus.closed;
      default:
        return IssueStatus.open;
    }
  }

  @override
  void write(BinaryWriter writer, IssueStatus obj) {
    switch (obj) {
      case IssueStatus.open:
        writer.writeByte(0);
        break;
      case IssueStatus.inProgress:
        writer.writeByte(1);
        break;
      case IssueStatus.resolved:
        writer.writeByte(2);
        break;
      case IssueStatus.closed:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
