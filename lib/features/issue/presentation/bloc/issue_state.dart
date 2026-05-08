part of 'issue_bloc.dart';

@immutable
sealed class IssueState {}

final class IssueInitial extends IssueState {}

final class IssueLoading extends IssueState {}

final class IssueLoaded extends IssueState {
  final List<Issue> issues;

  IssueLoaded(this.issues);
}

final class IssueFailure extends IssueState {
  final String message;

  IssueFailure(this.message);
}
