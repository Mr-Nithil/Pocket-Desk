import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/presentation/bloc/issue_bloc.dart';

void showFilterBottomSheet(
  BuildContext context,
  IssueStatus? selectedStatus,
  IssuePriority? selectedPriority,
  String? userId,
) {
  IssueStatus? tempStatus = selectedStatus;
  IssuePriority? tempPriority = selectedPriority;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Filter Issues",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<IssueStatus>(
                  value: tempStatus,
                  decoration: InputDecoration(
                    labelText: "Status",
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  items: [
                    for (final status in IssueStatus.values)
                      DropdownMenuItem(
                        value: status,
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: status.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(status.uiName),
                          ],
                        ),
                      ),
                  ],
                  onChanged: (value) {
                    setModalState(() {
                      tempStatus = value;
                    });
                  },
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<IssuePriority>(
                  value: tempPriority,
                  decoration: InputDecoration(
                    labelText: "Priority",
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  items: [
                    for (final priority in IssuePriority.values)
                      DropdownMenuItem(
                        value: priority,
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: priority.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(priority.uiName),
                          ],
                        ),
                      ),
                  ],
                  onChanged: (value) {
                    setModalState(() {
                      tempPriority = value;
                    });
                  },
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          selectedStatus = null;
                          selectedPriority = null;

                          Navigator.pop(context);

                          context.read<IssueBloc>().add(
                            LoadIssuesEvent(userId: userId!),
                          );
                        },
                        child: const Text("Reset"),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          selectedStatus = tempStatus;
                          selectedPriority = tempPriority;

                          Navigator.pop(context);

                          context.read<IssueBloc>().add(
                            FilterIssuesEvent(
                              userId: userId!,
                              status: selectedStatus,
                              priority: selectedPriority,
                            ),
                          );
                        },
                        child: const Text("Apply"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    },
  );
}
