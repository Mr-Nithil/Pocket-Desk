part of 'issue_bloc.dart';

@immutable
sealed class IssueEvent {}

class AddIssueEvent extends IssueEvent {
  final String userId;
  final String title;
  final String? description;
  final IssueStatus? status;
  final IssuePriority? priority;
  final String? optionalAssignee;

  AddIssueEvent({
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.optionalAssignee,
  });
}

class LoadIssuesEvent extends IssueEvent {
  final String userId;

  LoadIssuesEvent({required this.userId});
}

class DeleteIssueEvent extends IssueEvent {
  final String id;
  final String userId;

  DeleteIssueEvent({required this.userId, required this.id});
}

class UpdateIssueEvent extends IssueEvent {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final IssueStatus? status;
  final IssuePriority? priority;
  final String? optionalAssignee;

  UpdateIssueEvent({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.optionalAssignee,
  });
}

class ApplyIssueQueryEvent extends IssueEvent {
  final String userId;
  final String query;
  final IssueStatus? status;
  final IssuePriority? priority;

  ApplyIssueQueryEvent({
    required this.userId,
    this.query = '',
    this.status,
    this.priority,
  });
}
