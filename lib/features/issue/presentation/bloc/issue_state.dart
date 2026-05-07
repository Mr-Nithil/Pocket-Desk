part of 'issue_bloc.dart';

@immutable
sealed class IssueState {}

final class IssueInitial extends IssueState {}

final class IssueLoading extends IssueState {}

class IssueCreated extends IssueState {
  final Issue issue;

  IssueCreated(this.issue);
}

class IssueUpdated extends IssueState {
  final Issue issue;

  IssueUpdated(this.issue);
}

class IssueLoaded extends IssueState {
  final List<Issue> issues;

  IssueLoaded(this.issues);
}

class IssueFailure extends IssueState {
  final String message;

  IssueFailure(this.message);
}
