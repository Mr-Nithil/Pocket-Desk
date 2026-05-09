import 'package:flutter/material.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';

Future<(IssueStatus?, IssuePriority?)?> showFilterBottomSheet(
  BuildContext context,
  IssueStatus? selectedStatus,
  IssuePriority? selectedPriority,
) {
  IssueStatus? tempStatus = selectedStatus;
  IssuePriority? tempPriority = selectedPriority;

  return showModalBottomSheet<(IssueStatus?, IssuePriority?)>(
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
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  value: tempStatus,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    labelText: "Status",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  items: IssueStatus.values.map((status) {
                    return DropdownMenuItem(
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
                    );
                  }).toList(),
                  onChanged: (value) {
                    setModalState(() => tempStatus = value);
                  },
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<IssuePriority>(
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  value: tempPriority,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    labelText: "Priority",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  items: IssuePriority.values.map((priority) {
                    return DropdownMenuItem(
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
                    );
                  }).toList(),
                  onChanged: (value) {
                    setModalState(() => tempPriority = value);
                  },
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, (null, null));
                        },
                        child: const Text("Reset"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, (tempStatus, tempPriority));
                        },
                        child: const Text("Apply"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
