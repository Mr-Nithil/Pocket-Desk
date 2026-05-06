part of 'issue_bloc.dart';

sealed class IssueState extends Equatable {
  const IssueState();
  
  @override
  List<Object> get props => [];
}

final class IssueInitial extends IssueState {}
