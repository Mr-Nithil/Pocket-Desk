import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_query_params.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_stats.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_create.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_create_mock.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_delete.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_fetch_all.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_get_stats.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_query.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_update.dart';

part 'issue_event.dart';
part 'issue_state.dart';

class IssueBloc extends Bloc<IssueEvent, IssueState> {
  final IssueCreate _issueCreate;
  final IssueFetchAll _issueFetchAll;
  final IssueUpdate _issueUpdate;
  final IssueDelete _issueDelete;
  final IssueGetStats _issueGetStats;
  final IssueQuery _issueQuery;
  final IssueCreateMock _issueCreateMock;

  String _query = '';
  IssueStatus? _status;
  IssuePriority? _priority;

  IssueBloc({
    required IssueCreate issueCreate,
    required IssueFetchAll issueFetchAll,
    required IssueUpdate issueUpdate,
    required IssueDelete issueDelete,
    required IssueGetStats issueGetStats,
    required IssueQuery issueQuery,
    required IssueCreateMock issueCreateMock,
  }) : _issueCreate = issueCreate,
       _issueFetchAll = issueFetchAll,
       _issueUpdate = issueUpdate,
       _issueDelete = issueDelete,
       _issueGetStats = issueGetStats,
       _issueQuery = issueQuery,
       _issueCreateMock = issueCreateMock,
       super(IssueInitial()) {
    on<AddIssueEvent>(_onAddIssue);
    on<LoadIssuesEvent>(_onLoadIssues);
    on<UpdateIssueEvent>(_onUpdateIssue);
    on<DeleteIssueEvent>(_onDeleteIssue);
    on<ApplyIssueQueryEvent>(_onApplyIssueQuery);
    on<CreateMockIssuesEvent>(_onCreateMockIssues);
  }

  Future<void> _emitLoadedIssues({
    required String userId,
    required Emitter<IssueState> emit,
  }) async {
    final issuesRes = await _issueFetchAll(IssueFetchAllParams(userId: userId));

    final statsRes = await _issueGetStats(IssueGetStatsParams(userId: userId));

    issuesRes.fold((l) => emit(IssueFailure(l.message)), (issues) {
      statsRes.fold((l) => emit(IssueFailure(l.message)), (stats) {
        emit(IssueLoaded(issues: issues, stats: stats));
      });
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
        image: event.image,
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
        image: event.image,
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

  Future<void> _onApplyIssueQuery(
    ApplyIssueQueryEvent event,
    Emitter<IssueState> emit,
  ) async {
    _query = event.query;
    _status = event.status;
    _priority = event.priority;

    final res = await _issueQuery(
      IssueQueryParams(
        userId: event.userId,
        query: _query,
        status: _status,
        priority: _priority,
      ),
    );

    final statsRes = await _issueGetStats(
      IssueGetStatsParams(userId: event.userId),
    );

    res.fold((l) => emit(IssueFailure(l.message)), (issues) {
      statsRes.fold((l) => emit(IssueFailure(l.message)), (stats) {
        emit(IssueLoaded(issues: issues, stats: stats));
      });
    });
  }

  Future<void> _onCreateMockIssues(
    CreateMockIssuesEvent event,
    Emitter<IssueState> emit,
  ) async {
    final res = await _issueCreateMock(
      IssueCreateMockParams(userId: event.userId),
    );

    final statsRes = await _issueGetStats(
      IssueGetStatsParams(userId: event.userId),
    );

    res.fold((l) => emit(IssueFailure(l.message)), (issues) {
      statsRes.fold((l) => emit(IssueFailure(l.message)), (stats) {
        emit(IssueLoaded(issues: issues, stats: stats));
      });
    });
  }
}
