import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_desk/core/utils/show_snackbar.dart';
import 'package:pocket_desk/core/widgets/loader.dart';
import 'package:pocket_desk/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pocket_desk/features/auth/presentation/pages/login_page.dart';

import 'package:pocket_desk/features/issue/presentation/bloc/issue_bloc.dart';

import 'add_issue_page.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userEmail;
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _userEmail = authState.user.email;
      context.read<IssueBloc>().add(
        LoadIssuesEvent(userId: authState.user.email),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          showSnackBar(context, state.message);
        } else if (state is AuthUnauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            LoginPage.route(),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Issue List Screen")),
        body: BlocConsumer<IssueBloc, IssueState>(
          listener: (context, state) {
            if (state is IssueFailure) {
              showSnackBar(context, state.message);
            } else if (state is IssueLoading) {
              Loader();
            }
          },
          builder: (context, state) {
            if (state is IssueLoading) {
              return Loader();
            }

            if (state is IssueLoaded) {
              final issues = state.issues;

              if (state.issues.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 56,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No issues yet',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create the first issue.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: issues.length,
                itemBuilder: (context, index) {
                  final issue = issues[index];
                  return ListTile(
                    title: Text(issue.title),
                    subtitle: Text(
                      'User: ${issue.userId}\nStatus: ${issue.status.uiName}\nPriority: ${issue.priority.uiName}',
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            if (_userEmail != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddIssuePage(userId: _userEmail!),
                ),
              );
            } else {
              showSnackBar(
                context,
                'User email not found. Please log in again.',
              );
            }
          },
        ),
      ),
    );
  }
}
