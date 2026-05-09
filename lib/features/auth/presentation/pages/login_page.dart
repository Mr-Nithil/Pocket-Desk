import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_desk/core/utils/show_snackbar.dart';
import 'package:pocket_desk/core/utils/loader.dart';
import 'package:pocket_desk/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pocket_desk/features/auth/presentation/widgets/auth_field.dart';
import 'package:pocket_desk/features/auth/presentation/widgets/auth_button.dart';
import 'package:pocket_desk/features/issue/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                showSnackBar(context, state.message);
              } else if (state is AuthAuthenticated) {
                Navigator.pushAndRemoveUntil(
                  context,
                  HomePage.route(),
                  (route) => false,
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Loader();
              }
              return Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: ConstrainedBox(
                              constraints: BoxConstraints.tight(Size(100, 100)),
                              child: Placeholder(),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'PocketDesk',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 40,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Welcome back. Continue managing your tasks.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                          const SizedBox(height: 28),
                          AuthField(
                            hintText: 'Email',
                            controller: emailController,
                          ),
                          const SizedBox(height: 16),
                          AuthField(
                            hintText: 'Password',
                            controller: passwordController,
                            isObscureText: true,
                          ),
                          const SizedBox(height: 20),
                          AuthButton(
                            buttonText: 'Login',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  AuthLogin(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
