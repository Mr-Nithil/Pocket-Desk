// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_priority.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IssuePriorityAdapter extends TypeAdapter<IssuePriority> {
  @override
  final int typeId = 1;

  @override
  IssuePriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IssuePriority.low;
      case 1:
        return IssuePriority.medium;
      case 2:
        return IssuePriority.high;
      default:
        return IssuePriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, IssuePriority obj) {
    switch (obj) {
      case IssuePriority.low:
        writer.writeByte(0);
        break;
      case IssuePriority.medium:
        writer.writeByte(1);
        break;
      case IssuePriority.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssuePriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
