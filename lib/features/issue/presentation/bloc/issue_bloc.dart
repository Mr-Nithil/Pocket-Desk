import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_create.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_fetch_all.dart';

part 'issue_event.dart';
part 'issue_state.dart';

class IssueBloc extends Bloc<IssueEvent, IssueState> {
  final IssueCreate _issueCreate;
  final IssueFetchAll _issueFetchAll;
  IssueBloc({
    required IssueCreate issueCreate,
    required IssueFetchAll issueFetchAll,
  }) : _issueCreate = issueCreate,
       _issueFetchAll = issueFetchAll,
       super(IssueInitial()) {
    on<AddIssueEvent>(_onAddIssue);
    on<LoadIssuesEvent>(_onLoadIssues);
  }

  void _onAddIssue(AddIssueEvent event, Emitter<IssueState> emit) async {
    emit(IssueLoading());
    final res = await _issueCreate(
      IssueCreateParams(
        userId: event.userId,
        title: event.title,
        description: event.description,
        status: event.status,
        priority: event.priority,
        optionalAssignee: event.optionalAssignee,
      ),
    );
    res.fold(
      (l) => emit(IssueFailure(l.message)),
      (r) => emit(IssueCreated(r)),
    );
  }

  void _onLoadIssues(LoadIssuesEvent event, Emitter<IssueState> emit) async {
    emit(IssueLoading());

    final res = await _issueFetchAll(IssueFetchAllParams(userId: event.userId));

    res.fold((l) => emit(IssueFailure(l.message)), (r) => emit(IssueLoaded(r)));
  }
}
