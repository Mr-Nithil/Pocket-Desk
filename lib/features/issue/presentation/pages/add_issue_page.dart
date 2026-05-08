import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_desk/config/theme/color_palette.dart';
import 'package:pocket_desk/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/presentation/bloc/issue_bloc.dart';
import 'package:pocket_desk/features/issue/presentation/widgets/issue_text_field.dart';
import 'package:pocket_desk/features/issue/presentation/widgets/priority_selector.dart';
import 'package:pocket_desk/features/issue/presentation/widgets/status_selector.dart';

class AddIssuePage extends StatefulWidget {
  const AddIssuePage({super.key});
  @override
  State<AddIssuePage> createState() => _AddIssuePageState();
}

class _AddIssuePageState extends State<AddIssuePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _assigneeController = TextEditingController();
  IssuePriority _priority = IssuePriority.medium;
  IssueStatus _status = IssueStatus.open;
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
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _assigneeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('New Issue'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? ColorPalette.darkSurface
            : ColorPalette.lightSurface,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? ColorPalette.darkPrimaryText
            : ColorPalette.lightPrimaryText,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.12),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                  color: Colors.black.withOpacity(
                    Theme.of(context).brightness == Brightness.dark
                        ? 0.18
                        : 0.04,
                  ),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create a new task to track progress and assign optional team members.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  IssueTextField(
                    label: 'TITLE',
                    hint: 'e.g., Fix navigation jitter on mobile',
                    controller: _titleController,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter title' : null,
                  ),
                  const SizedBox(height: 20),
                  IssueTextField(
                    label: 'DESCRIPTION',
                    hint: 'Describe the issue in detail...',
                    controller: _descController,
                    maxLines: 3,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter description' : null,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'PRIORITY',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? ColorPalette.darkPrimaryText
                          : ColorPalette.lightPrimaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  PrioritySelector(
                    selected: _priority,
                    onChanged: (val) => setState(() => _priority = val),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'STATUS',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? ColorPalette.darkPrimaryText
                          : ColorPalette.lightPrimaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StatusSelector(
                    selected: _status,
                    onChanged: (val) => setState(() => _status = val),
                  ),
                  const SizedBox(height: 20),
                  IssueTextField(
                    label: 'OPTIONAL ASSIGNEE',
                    hint: 'e.g. John Doe',
                    controller: _assigneeController,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: ColorPalette.fabColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Create Issue',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<IssueBloc>().add(
                            AddIssueEvent(
                              userId: _userEmail!,
                              title: _titleController.text,
                              description: _descController.text,
                              status: _status,
                              priority: _priority,
                              optionalAssignee: null,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          letterSpacing: 1.2,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? ColorPalette.darkSecondaryText
                              : ColorPalette.lightSecondaryText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
