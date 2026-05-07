import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_create.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_fetch_all.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_update.dart';

part 'issue_event.dart';
part 'issue_state.dart';

class IssueBloc extends Bloc<IssueEvent, IssueState> {
  final IssueCreate _issueCreate;
  final IssueFetchAll _issueFetchAll;
  final IssueUpdate _issueUpdate;
  IssueBloc({
    required IssueCreate issueCreate,
    required IssueFetchAll issueFetchAll,
    required IssueUpdate issueUpdate,
  }) : _issueCreate = issueCreate,
       _issueFetchAll = issueFetchAll,
       _issueUpdate = issueUpdate,
       super(IssueInitial()) {
    on<AddIssueEvent>(_onAddIssue);
    on<LoadIssuesEvent>(_onLoadIssues);
    on<UpdateIssueEvent>(_onUpdateIssue);
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

  void _onUpdateIssue(UpdateIssueEvent event, Emitter<IssueState> emit) async {
    emit(IssueLoading());
    final res = await _issueUpdate(
      IssueUpdateParams(
        id: event.id,
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
      (r) => emit(IssueUpdated(r)),
    );
  }
}
