import 'package:pocket_desk/features/issue/data/models/issue_model.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';

import 'package:pocket_desk/features/issue/data/models/issue_status.dart'
    as data;
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart'
    as domain;
import 'package:pocket_desk/features/issue/data/models/issue_priority.dart'
    as data;
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart'
    as domain;

extension IssueModelMapper on IssueModel {
  Issue toEntity() {
    return Issue(
      id: id,
      userId: userId,
      title: title,
      description: description,
      status: status.toDomain(),
      priority: priority.toDomain(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      optionalAssignee: optionalAssignee,
    );
  }
}

extension IssueEntityMapper on Issue {
  IssueModel toModel() {
    return IssueModel(
      id: id,
      userId: userId,
      title: title,
      description: description,
      status: status.toData(),
      priority: priority.toData(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      optionalAssignee: optionalAssignee,
    );
  }
}

// Enum mappers
extension IssueStatusDataMapper on data.IssueStatus {
  domain.IssueStatus toDomain() {
    switch (this) {
      case data.IssueStatus.open:
        return domain.IssueStatus.open;
      case data.IssueStatus.inProgress:
        return domain.IssueStatus.inProgress;
      case data.IssueStatus.resolved:
        return domain.IssueStatus.resolved;
      case data.IssueStatus.closed:
        return domain.IssueStatus.closed;
    }
  }
}

extension IssueStatusDomainMapper on domain.IssueStatus {
  data.IssueStatus toData() {
    switch (this) {
      case domain.IssueStatus.open:
        return data.IssueStatus.open;
      case domain.IssueStatus.inProgress:
        return data.IssueStatus.inProgress;
      case domain.IssueStatus.resolved:
        return data.IssueStatus.resolved;
      case domain.IssueStatus.closed:
        return data.IssueStatus.closed;
    }
  }
}

extension IssuePriorityDataMapper on data.IssuePriority {
  domain.IssuePriority toDomain() {
    switch (this) {
      case data.IssuePriority.low:
        return domain.IssuePriority.low;
      case data.IssuePriority.medium:
        return domain.IssuePriority.medium;
      case data.IssuePriority.high:
        return domain.IssuePriority.high;
    }
  }
}

extension IssuePriorityDomainMapper on domain.IssuePriority {
  data.IssuePriority toData() {
    switch (this) {
      case domain.IssuePriority.low:
        return data.IssuePriority.low;
      case domain.IssuePriority.medium:
        return data.IssuePriority.medium;
      case domain.IssuePriority.high:
        return data.IssuePriority.high;
    }
  }
}
