import 'package:get_it/get_it.dart';
import 'package:pocket_desk/features/auth/data/datasources/mock_auth_datasource.dart';
import 'package:pocket_desk/features/auth/data/repository/auth_repository_impl.dart';
import 'package:pocket_desk/features/auth/domain/repository/auth_repository.dart';
import 'package:pocket_desk/features/auth/domain/usecases/user_login.dart';
import 'package:pocket_desk/features/auth/domain/usecases/user_logout.dart';
import 'package:pocket_desk/features/auth/domain/usecases/user_status_check.dart';
import 'package:pocket_desk/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  serviceLocator.registerLazySingleton<SharedPreferences>(() => prefs);

  _initAuth();
}

void _initAuth() {
  serviceLocator.registerFactory<MockAuthDatasource>(
    () => MockAuthDataSourceImpl(sharedPreferences: serviceLocator()),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(mockAuthDatasource: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => UserLogin(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => UserStatusCheck(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => UserLogout(authRepository: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userLogin: serviceLocator(),
      userStatusCheck: serviceLocator(),
      userLogout: serviceLocator(),
    ),
  );
}
