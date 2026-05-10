import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_desk/config/theme/theme.dart';
import 'package:pocket_desk/core/cubits/theme_cubit.dart';
import 'package:pocket_desk/core/widgets/loader.dart';
import 'package:pocket_desk/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pocket_desk/features/auth/presentation/pages/login_page.dart';
import 'package:pocket_desk/features/issue/presentation/bloc/issue_bloc.dart';
import 'package:pocket_desk/features/issue/presentation/pages/home_page.dart';
import 'package:pocket_desk/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<ThemeCubit>()),
        BlocProvider(create: (_) => serviceLocator<IssueBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckState());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PocketDesk',
          theme: AppTheme.lightThemeMode,
          darkTheme: AppTheme.darkThemeMode,
          themeMode: state,
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Scaffold(body: Loader());
              }
              if (state is AuthAuthenticated) {
                return HomePage();
              }
              return LoginPage();
            },
          ),
        );
      },
    );
  }
}
