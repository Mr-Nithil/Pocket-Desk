import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pocket_desk/core/entities/user.dart';
import 'package:pocket_desk/features/auth/domain/usecases/user_login.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLogin _userLogin;
  AuthBloc({required UserLogin userLogin})
    : _userLogin = userLogin,
      super(AuthInitial()) {
    on<AuthLogin>(_onAuthLogin);
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
}
