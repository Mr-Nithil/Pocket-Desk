import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pocket_desk/core/entities/user.dart';
import 'package:pocket_desk/core/usecases/usecase.dart';
import 'package:pocket_desk/features/auth/domain/usecases/user_login.dart';
import 'package:pocket_desk/features/auth/domain/usecases/user_logout.dart';
import 'package:pocket_desk/features/auth/domain/usecases/user_status_check.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLogin _userLogin;
  final UserStatusCheck _userStatusCheck;
  final UserLogout _userLogout;
  AuthBloc({
    required UserLogin userLogin,
    required UserStatusCheck userStatusCheck,
    required UserLogout userLogout,
  }) : _userLogin = userLogin,
       _userStatusCheck = userStatusCheck,
       _userLogout = userLogout,
       super(AuthInitial()) {
    on<AuthLogin>(_onAuthLogin);
    on<AuthCheckState>(_onAuthCheckState);
    on<AuthLogOut>(_onAuthLogout);
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );

    res.fold(
      (l) => emit(AuthError(l.message)),
      (r) => emit(AuthAuthenticated(r)),
    );
  }

  void _onAuthCheckState(AuthCheckState event, Emitter<AuthState> emit) async {
    final res = await _userStatusCheck(NoParams());

    res.fold(
      (l) => emit(AuthUnauthenticated()),
      (r) => emit(AuthAuthenticated(r)),
    );
  }

  void _onAuthLogout(AuthLogOut event, Emitter<AuthState> emit) async {
    final res = await _userLogout(NoParams());

    res.fold(
      (l) => emit(AuthError(l.message)),
      (r) => emit(AuthUnauthenticated()),
    );
  }
}
