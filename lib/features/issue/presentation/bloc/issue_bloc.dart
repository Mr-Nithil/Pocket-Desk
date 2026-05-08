import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_create.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_delete.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_fetch_all.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_update.dart';

part 'issue_event.dart';
part 'issue_state.dart';

class IssueBloc extends Bloc<IssueEvent, IssueState> {
  final IssueCreate _issueCreate;
  final IssueFetchAll _issueFetchAll;
  final IssueUpdate _issueUpdate;
  final IssueDelete _issueDelete;

  IssueBloc({
    required IssueCreate issueCreate,
    required IssueFetchAll issueFetchAll,
    required IssueUpdate issueUpdate,
    required IssueDelete issueDelete,
  }) : _issueCreate = issueCreate,
       _issueFetchAll = issueFetchAll,
       _issueUpdate = issueUpdate,
       _issueDelete = issueDelete,
       super(IssueInitial()) {
    on<AddIssueEvent>(_onAddIssue);
    on<LoadIssuesEvent>(_onLoadIssues);
    on<UpdateIssueEvent>(_onUpdateIssue);
    on<DeleteIssueEvent>(_onDeleteIssue);
  }

  Future<void> _emitLoadedIssues({
    required String userId,
    required Emitter<IssueState> emit,
  }) async {
    final res = await _issueFetchAll(IssueFetchAllParams(userId: userId));

    res.fold((l) => emit(IssueFailure(l.message)), (r) {
      print('Loaded issue count: ${r.length}');
      emit(IssueLoaded(r));
    });
  }

  Future<void> _onAddIssue(
    AddIssueEvent event,
    Emitter<IssueState> emit,
  ) async {
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

    await res.fold((l) async => emit(IssueFailure(l.message)), (r) async {
      await _emitLoadedIssues(userId: event.userId, emit: emit);
    });
  }

  Future<void> _onLoadIssues(
    LoadIssuesEvent event,
    Emitter<IssueState> emit,
  ) async {
    emit(IssueLoading());

    await _emitLoadedIssues(userId: event.userId, emit: emit);
  }

  Future<void> _onUpdateIssue(
    UpdateIssueEvent event,
    Emitter<IssueState> emit,
  ) async {
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

    await res.fold((l) async => emit(IssueFailure(l.message)), (r) async {
      await _emitLoadedIssues(userId: event.userId, emit: emit);
    });
  }

  Future<void> _onDeleteIssue(
    DeleteIssueEvent event,
    Emitter<IssueState> emit,
  ) async {
    emit(IssueLoading());

    final res = await _issueDelete(
      IssueDeleteParams(id: event.id, userId: event.userId),
    );

    await res.fold((l) async => emit(IssueFailure(l.message)), (r) async {
      await _emitLoadedIssues(userId: event.userId, emit: emit);
    });
  }
}
