import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_desk/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/presentation/bloc/issue_bloc.dart';
import 'package:pocket_desk/features/issue/presentation/widgets/issue_text_field.dart';
import 'package:pocket_desk/features/issue/presentation/widgets/priority_selector.dart';
import 'package:pocket_desk/features/issue/presentation/widgets/status_selector.dart';

class AddEditIssuePage extends StatefulWidget {
  final Issue? issue;

  const AddEditIssuePage({super.key, this.issue});

  @override
  State<AddEditIssuePage> createState() => _AddEditIssuePageState();
}

class _AddEditIssuePageState extends State<AddEditIssuePage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _assigneeController = TextEditingController();

  IssuePriority _priority = IssuePriority.medium;
  IssueStatus _status = IssueStatus.open;

  String? _userEmail;

  bool get isEditMode => widget.issue != null;

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _userEmail = authState.user.email;
    }

    final issue = widget.issue;
    if (issue != null) {
      _titleController.text = issue.title;
      _descController.text = issue.description ?? "";
      _priority = issue.priority;
      _status = issue.status;
      _assigneeController.text = issue.optionalAssignee ?? '';
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Issue' : 'New Issue'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: colorScheme.outline.withOpacity(0.12)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    isEditMode
                        ? 'Update the issue details, adjust requirements, and save your changes.'
                        : 'Create a new task to define objectives and track progress over time.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 24),

                  IssueTextField(
                    label: 'TITLE',
                    hint: 'Enter title',
                    controller: _titleController,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter title' : null,
                  ),

                  const SizedBox(height: 20),

                  IssueTextField(
                    label: 'DESCRIPTION',
                    hint: 'Enter description',
                    controller: _descController,
                    minLines: 4,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter description' : null,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'PRIORITY',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),

                  const SizedBox(height: 8),

                  PrioritySelector(
                    selected: _priority,
                    onChanged: (val) => setState(() => _priority = val),
                  ),

                  const SizedBox(height: 20),

                  Text('STATUS', style: Theme.of(context).textTheme.labelLarge),

                  const SizedBox(height: 8),

                  StatusSelector(
                    selected: _status,
                    onChanged: (val) => setState(() => _status = val),
                  ),

                  const SizedBox(height: 20),

                  IssueTextField(
                    label: 'ASSIGNEE (OPTIONAL)',
                    hint: 'Enter name',
                    controller: _assigneeController,
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        isEditMode ? 'Update Issue' : 'Create Issue',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (isEditMode) {
                            context.read<IssueBloc>().add(
                              UpdateIssueEvent(
                                id: widget.issue!.id,
                                userId: _userEmail!,
                                title: _titleController.text,
                                description: _descController.text,
                                status: _status,
                                priority: _priority,
                                optionalAssignee: _assigneeController.text,
                              ),
                            );
                          } else {
                            context.read<IssueBloc>().add(
                              AddIssueEvent(
                                userId: _userEmail!,
                                title: _titleController.text,
                                description: _descController.text,
                                status: _status,
                                priority: _priority,
                                optionalAssignee: _assigneeController.text,
                              ),
                            );
                          }

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
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: 1.2,
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
