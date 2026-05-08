import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/presentation/bloc/issue_bloc.dart';

class AddIssuePage extends StatefulWidget {
  final String userId;

  const AddIssuePage({super.key, required this.userId});
  @override
  State<AddIssuePage> createState() => _AddIssuePageState();
}

class _AddIssuePageState extends State<AddIssuePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  IssuePriority? _priority = IssuePriority.medium;
  IssueStatus? _status = IssueStatus.open;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Issue')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Enter title' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter description' : null,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<IssuePriority>(
                value: _priority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: IssuePriority.values
                    .map(
                      (e) => DropdownMenuItem(value: e, child: Text(e.uiName)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _priority = val),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<IssueStatus>(
                value: _status,
                decoration: InputDecoration(labelText: 'Status'),
                items: IssueStatus.values
                    .map(
                      (e) => DropdownMenuItem(value: e, child: Text(e.uiName)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _status = val),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                child: Text('Create'),
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _priority != null &&
                      _status != null) {
                    context.read<IssueBloc>().add(
                      AddIssueEvent(
                        userId: widget.userId,
                        title: _titleController.text,
                        description: _descController.text,
                        status: _status!,
                        priority: _priority!,
                        optionalAssignee: null,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
