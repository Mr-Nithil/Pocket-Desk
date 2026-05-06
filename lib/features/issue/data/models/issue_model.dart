import 'dart:convert';

import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';

class IssueModel extends Issue {
  IssueModel({
    required super.id,
    required super.userId,
    required super.title,
    super.description,
    required super.status,
    required super.priority,
    required super.createdAt,
    super.updatedAt,
    super.optionalAssignee,
  });

  IssueModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    IssueStatus? status,
    IssuePriority? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? optionalAssignee,
  }) {
    return IssueModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      optionalAssignee: optionalAssignee ?? this.optionalAssignee,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'status': status.name,
      'priority': priority.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'optionalAssignee': optionalAssignee,
    };
  }

  factory IssueModel.fromMap(Map<String, dynamic> map) {
    return IssueModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      description: map['description'] != null
          ? map['description'] as String
          : null,
      status: IssueStatus.values.byName(map['status'] as String),
      priority: IssuePriority.values.byName(map['priority'] as String),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
      optionalAssignee: map['optionalAssignee'] != null
          ? map['optionalAssignee'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory IssueModel.fromJson(String source) =>
      IssueModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Issue(id: $id,userId: $userId ,title: $title, description: $description, status: $status, priority: $priority, createdAt: $createdAt, updatedAt: $updatedAt, optionalAssignee: $optionalAssignee)';
  }

  @override
  bool operator ==(covariant IssueModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.description == description &&
        other.status == status &&
        other.priority == priority &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.optionalAssignee == optionalAssignee;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        status.hashCode ^
        priority.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        optionalAssignee.hashCode;
  }
}
