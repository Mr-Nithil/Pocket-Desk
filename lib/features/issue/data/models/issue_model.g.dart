// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IssueModelAdapter extends TypeAdapter<IssueModel> {
  @override
  final int typeId = 2;

  @override
  IssueModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IssueModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String?,
      status: fields[4] as IssueStatus,
      priority: fields[5] as IssuePriority,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime?,
      optionalAssignee: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IssueModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.priority)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.optionalAssignee);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IssueModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
