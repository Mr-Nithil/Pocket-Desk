import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_create.dart';

part 'issue_event.dart';
part 'issue_state.dart';

class IssueBloc extends Bloc<IssueEvent, IssueState> {
  final IssueCreate _issueCreate;
  IssueBloc({required IssueCreate issueCreate})
    : _issueCreate = issueCreate,
      super(IssueInitial()) {
    on<AddIssueEvent>(_onAddIssue);
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
}
