import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocket_desk/core/cubits/theme_cubit.dart';
import 'package:pocket_desk/features/auth/data/datasources/mock_auth_datasource.dart';
import 'package:pocket_desk/features/auth/data/repository/auth_repository_impl.dart';
import 'package:pocket_desk/features/auth/domain/repository/auth_repository.dart';
import 'package:pocket_desk/features/auth/domain/usecases/user_login.dart';
import 'package:pocket_desk/features/auth/domain/usecases/user_logout.dart';
import 'package:pocket_desk/features/auth/domain/usecases/user_status_check.dart';
import 'package:pocket_desk/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pocket_desk/features/issue/data/datasources/issue_local_datasource.dart';
import 'package:pocket_desk/features/issue/data/models/issue_model.dart';
import 'package:pocket_desk/features/issue/data/models/issue_priority.dart';
import 'package:pocket_desk/features/issue/data/models/issue_status.dart';
import 'package:pocket_desk/features/issue/data/repository/issue_repository_impl.dart';
import 'package:pocket_desk/features/issue/domain/repository/issue_repository.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_create.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_delete.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_fetch_all.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_get_stats.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_query.dart';
import 'package:pocket_desk/features/issue/domain/usecases/issue_update.dart';
import 'package:pocket_desk/features/issue/presentation/bloc/issue_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(() => prefs);

  await _initHive();

  _initTheme();
  _initAuth();
  _initIssue();
}

void _initTheme() {
  serviceLocator.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(preferencesBox: serviceLocator()),
  );
}

Future<void> _initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(IssueStatusAdapter());
  Hive.registerAdapter(IssuePriorityAdapter());
  Hive.registerAdapter(IssueModelAdapter());

  final issueBox = await Hive.openBox<IssueModel>('issues');
  serviceLocator.registerLazySingleton<Box<IssueModel>>(() => issueBox);

  final preferencesBox = await Hive.openBox('preferences');
  serviceLocator.registerSingleton<Box>(preferencesBox);
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

void _initIssue() {
  serviceLocator.registerLazySingleton<IssueLocalDatasource>(
    () => IssueLocalDatasourceImpl(issueBox: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<IssueRepository>(
    () => IssueRepositoryImpl(issueLocalDatasource: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => IssueCreate(issueRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => IssueFetchAll(issueRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => IssueUpdate(issueRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => IssueDelete(issueRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => IssueQuery(issueRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => IssueGetStats(issueRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => IssueBloc(
      issueCreate: serviceLocator(),
      issueFetchAll: serviceLocator(),
      issueUpdate: serviceLocator(),
      issueDelete: serviceLocator(),
      issueGetStats: serviceLocator(),
      issueQuery: serviceLocator(),
    ),
  );
}
