import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocket_desk/config/theme/color_palette.dart';

import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/presentation/widgets/priority_chip.dart';
import 'package:pocket_desk/features/issue/presentation/widgets/status_chip.dart';

class IssueCard extends StatelessWidget {
  final String title;
  final IssueStatus status;
  final Color statusColor;
  final String code;
  final DateTime date;
  final IssuePriority priority;
  final Color priorityColor;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const IssueCard({
    super.key,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.code,
    required this.date,
    required this.priority,
    required this.priorityColor,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: statusColor.withOpacity(0.15)),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 6),
                color: Colors.black.withOpacity(
                  Theme.of(context).brightness == Brightness.dark ? 0.18 : 0.04,
                ),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    StatusChip(label: status.uiName, color: statusColor),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Icon(
                      Icons.tag_outlined,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),

                    const SizedBox(width: 5),

                    Container(
                      width: 100,
                      child: Text(
                        code,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Icon(
                      Icons.schedule_outlined,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),

                    const SizedBox(width: 5),

                    Text(
                      DateFormat('MMM dd, yyyy').format(date),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    PriorityChip(label: priority.uiName, color: priorityColor),

                    const Spacer(),

                    IconButton(
                      onPressed: onEdit,
                      style: IconButton.styleFrom(
                        backgroundColor: ColorPalette.editAction.withOpacity(
                          0.12,
                        ),
                      ),
                      icon: Icon(
                        Icons.edit_outlined,
                        color: ColorPalette.editAction,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 8),

                    IconButton(
                      onPressed: onDelete,
                      style: IconButton.styleFrom(
                        backgroundColor: ColorPalette.deleteAction.withOpacity(
                          0.12,
                        ),
                      ),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: ColorPalette.deleteAction,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
