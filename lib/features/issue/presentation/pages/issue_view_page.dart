import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pocket_desk/config/theme/color_palette.dart';
import 'package:pocket_desk/core/utils/app_confirm_dialog.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/presentation/bloc/issue_bloc.dart';
import 'package:pocket_desk/features/issue/presentation/pages/add_edit_issue_page.dart';
import 'package:pocket_desk/features/issue/presentation/widgets/priority_chip.dart';
import 'package:pocket_desk/features/issue/presentation/widgets/section_card.dart';
import 'package:pocket_desk/features/issue/presentation/widgets/status_chip.dart';

class IssueViewPage extends StatelessWidget {
  final Issue issue;

  const IssueViewPage({super.key, required this.issue});

  static route(Issue issue) =>
      MaterialPageRoute(builder: (_) => IssueViewPage(issue: issue));

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Issue Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      Theme.of(context).brightness == Brightness.dark
                          ? 0.15
                          : 0.05,
                    ),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.tag_outlined,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),

                          const SizedBox(width: 5),
                          Text(
                            issue.id,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('MMM dd, yyyy').format(issue.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    issue.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      StatusChip(
                        label: issue.status.uiName,
                        color: issue.status.color,
                      ),
                      const SizedBox(width: 10),
                      PriorityChip(
                        label: issue.priority.uiName,
                        color: issue.priority.color,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SectionCard(
              title: "DESCRIPTION",
              child: Text(
                issue.description ?? "No description provided",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ),

            const SizedBox(height: 20),

            SectionCard(
              title: "ASSIGNEE (OPTIONAL)",
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colorScheme.primary.withOpacity(0.12),
                    child: Icon(
                      Icons.person_rounded,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    issue.optionalAssignee?.isNotEmpty == true
                        ? issue.optionalAssignee!
                        : "Not assigned",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddEditIssuePage(issue: issue),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: Text("Edit", style: TextStyle(fontSize: 10)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.successColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: ColorPalette.successColor
                          .withOpacity(0.3),
                      disabledForegroundColor: Colors.white70,
                    ),

                    onPressed: issue.status == IssueStatus.resolved
                        ? null
                        : () {
                            AppConfirmDialog.show(
                              context: context,
                              message:
                                  "Warning: Are you sure you want to resolve this issue?",
                              primaryButtonText: "Resolve",
                              onConfirm: () {
                                context.read<IssueBloc>().add(
                                  UpdateIssueEvent(
                                    id: issue.id,
                                    userId: issue.userId,
                                    title: issue.title,
                                    description: issue.description,
                                    status: IssueStatus.resolved,
                                    priority: issue.priority,
                                    optionalAssignee: issue.optionalAssignee,
                                  ),
                                );
                              },
                            );
                          },

                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(
                      issue.status == IssueStatus.resolved
                          ? "Resolved"
                          : "Resolve",
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.statusClosed,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: ColorPalette.statusClosed
                          .withOpacity(0.3),
                      disabledForegroundColor: Colors.white70,
                    ),

                    onPressed: issue.status == IssueStatus.closed
                        ? null
                        : () {
                            AppConfirmDialog.show(
                              context: context,
                              message:
                                  "Warning: Are you sure you want to close this issue?",
                              primaryButtonText: "Close",
                              onConfirm: () {
                                context.read<IssueBloc>().add(
                                  UpdateIssueEvent(
                                    id: issue.id,
                                    userId: issue.userId,
                                    title: issue.title,
                                    description: issue.description,
                                    status: IssueStatus.closed,
                                    priority: issue.priority,
                                    optionalAssignee: issue.optionalAssignee,
                                  ),
                                );
                              },
                            );
                          },

                    icon: const Icon(Icons.lock),
                    label: Text(
                      issue.status == IssueStatus.resolved ? "Closed" : "Close",
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
