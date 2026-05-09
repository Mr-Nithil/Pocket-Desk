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
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusColor.withOpacity(0.15)),
            boxShadow: [
              BoxShadow(
                blurRadius: 14,
                offset: const Offset(0, 4),
                color: Colors.black.withOpacity(
                  Theme.of(context).brightness == Brightness.dark
                      ? 0.16
                      : 0.035,
                ),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                              height: 1.2,
                              fontSize: 15,
                            ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    StatusChip(label: status.uiName, color: statusColor),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Icon(
                      Icons.tag_outlined,
                      size: 15,
                      color: colorScheme.onSurfaceVariant,
                    ),

                    const SizedBox(width: 4),

                    SizedBox(
                      width: 90,
                      child: Text(
                        code,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Icon(
                      Icons.schedule_outlined,
                      size: 15,
                      color: colorScheme.onSurfaceVariant,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      DateFormat('MMM dd, yyyy').format(date),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    PriorityChip(label: priority.uiName, color: priorityColor),

                    const Spacer(),

                    SizedBox(
                      width: 34,
                      height: 34,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: onEdit,
                        style: IconButton.styleFrom(
                          backgroundColor: ColorPalette.editAction.withOpacity(
                            0.12,
                          ),
                        ),
                        icon: Icon(
                          Icons.edit_outlined,
                          color: ColorPalette.editAction,
                          size: 18,
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    SizedBox(
                      width: 34,
                      height: 34,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: onDelete,
                        style: IconButton.styleFrom(
                          backgroundColor: ColorPalette.deleteAction
                              .withOpacity(0.12),
                        ),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: ColorPalette.deleteAction,
                          size: 18,
                        ),
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
