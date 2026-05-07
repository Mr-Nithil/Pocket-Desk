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
