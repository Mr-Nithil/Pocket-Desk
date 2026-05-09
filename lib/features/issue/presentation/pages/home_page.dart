import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_desk/config/theme/color_palette.dart';
import 'package:pocket_desk/core/utils/show_snackbar.dart';
import 'package:pocket_desk/core/widgets/app_confirm_dialog.dart';
import 'package:pocket_desk/core/widgets/loader.dart';
import 'package:pocket_desk/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pocket_desk/features/auth/presentation/pages/login_page.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_status.dart';
import 'package:pocket_desk/features/issue/domain/entities/summary_stat_item.dart';

import 'package:pocket_desk/features/issue/presentation/bloc/issue_bloc.dart';
import 'package:pocket_desk/features/issue/presentation/pages/issue_view_page.dart';
import 'package:pocket_desk/features/issue/presentation/widgets/compact_filter_chip.dart';
import 'package:pocket_desk/features/issue/presentation/widgets/show_filter_bottom_sheet.dart';
import 'package:pocket_desk/features/issue/presentation/widgets/summary_stat_section.dart';

import 'add_edit_issue_page.dart';
import '../widgets/issue_card.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String? userId;
  IssueStatus? selectedStatus;
  IssuePriority? selectedPriority;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthAuthenticated) {
      userId = authState.user.email;
      context.read<IssueBloc>().add(
        LoadIssuesEvent(userId: authState.user.email),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        appBar: AppBar(
          title: Text("PocketDesk"),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
            ),
          ],
        ),
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
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                    child: SummaryStatsSection(
                      items: [
                        SummaryStatItem(
                          label: "Total",
                          count: state.stats.issueCount,
                          color: ColorPalette.editAction,
                          icon: Icons.assignment_outlined,
                        ),

                        SummaryStatItem(
                          label: "Open",
                          count: state.stats.openCount,
                          color: ColorPalette.statusOpen,
                          icon: Icons.radio_button_unchecked,
                        ),

                        SummaryStatItem(
                          label: "In Progress",
                          count: state.stats.inProgressCount,
                          color: ColorPalette.statusInProgress,
                          icon: Icons.sync,
                        ),

                        SummaryStatItem(
                          label: "Resolved",
                          count: state.stats.resolvedCount,
                          color: ColorPalette.statusResolved,
                          icon: Icons.check_circle_outline,
                        ),

                        SummaryStatItem(
                          label: "Closed",
                          count:
                              (state.stats.issueCount -
                              state.stats.openCount -
                              state.stats.inProgressCount -
                              state.stats.resolvedCount),
                          color: ColorPalette.statusClosed,
                          icon: Icons.lock_outline,
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(fontSize: 15),
                              onChanged: (value) {
                                if (value.trim().isEmpty &&
                                    selectedStatus == null &&
                                    selectedPriority == null) {
                                  context.read<IssueBloc>().add(
                                    LoadIssuesEvent(userId: userId!),
                                  );
                                } else {
                                  context.read<IssueBloc>().add(
                                    ApplyIssueQueryEvent(
                                      userId: userId!,
                                      query: value.trim(),
                                      status: selectedStatus,
                                      priority: selectedPriority,
                                    ),
                                  );
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Search issues...",
                                prefixIcon: const Icon(Icons.search, size: 22),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, size: 20),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {
                                            selectedStatus = null;
                                            selectedPriority = null;
                                          });
                                          context.read<IssueBloc>().add(
                                            LoadIssuesEvent(userId: userId!),
                                          );
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                              ),
                            ),
                          ),

                          if (selectedStatus != null ||
                              selectedPriority != null) ...[
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 110,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (selectedStatus != null)
                                    CompactFilterChip(
                                      label: selectedStatus!.uiName,
                                      color: selectedStatus!.color,
                                      onRemove: () {
                                        setState(() => selectedStatus = null);
                                        context.read<IssueBloc>().add(
                                          ApplyIssueQueryEvent(
                                            userId: userId!,
                                            query: _searchController.text,
                                            status: null,
                                            priority: selectedPriority,
                                          ),
                                        );
                                      },
                                    ),
                                  if (selectedStatus != null &&
                                      selectedPriority != null)
                                    const SizedBox(height: 4),
                                  if (selectedPriority != null)
                                    CompactFilterChip(
                                      label: selectedPriority!.uiName,
                                      color: selectedPriority!.color,
                                      onRemove: () {
                                        setState(() => selectedPriority = null);
                                        context.read<IssueBloc>().add(
                                          ApplyIssueQueryEvent(
                                            userId: userId!,
                                            query: _searchController.text,
                                            status: selectedStatus,
                                            priority: null,
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(width: 6),

                          AspectRatio(
                            aspectRatio: 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.filter_alt_outlined,
                                  size: 22,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () async {
                                  final result = await showFilterBottomSheet(
                                    context,
                                    selectedStatus,
                                    selectedPriority,
                                  );
                                  if (result != null) {
                                    setState(() {
                                      selectedStatus = result.$1;
                                      selectedPriority = result.$2;
                                    });
                                    context.read<IssueBloc>().add(
                                      ApplyIssueQueryEvent(
                                        userId: userId!,
                                        query: _searchController.text,
                                        status: selectedStatus,
                                        priority: selectedPriority,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  issues.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: issues.length,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemBuilder: (context, index) {
                              final issue = issues[index];
                              return IssueCard(
                                title: issue.title,
                                status: issue.status,
                                statusColor: issue.status.color,
                                code: issue.id,
                                date: issue.createdAt,
                                priority: issue.priority,
                                priorityColor: issue.priority.color,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          IssueViewPage(issue: issue),
                                    ),
                                  );
                                },
                                onEdit: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AddEditIssuePage(issue: issue),
                                    ),
                                  );
                                },
                                onDelete: () {
                                  AppConfirmDialog.show(
                                    context: context,
                                    message:
                                        "Warning: This will permanently erase this issue and all its content.",
                                    primaryButtonText: "Delete",
                                    onConfirm: () {
                                      context.read<IssueBloc>().add(
                                        DeleteIssueEvent(
                                          userId: userId!,
                                          id: issue.id,
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 28,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outline.withOpacity(0.15),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? 0.18
                                          : 0.05,
                                    ),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.10),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.inbox_outlined,
                                      size: 34,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  Text(
                                    'No issues found',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    'Your workspace is clean. Start by creating a new issue to track tasks and progress.',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                          height: 1.4,
                                        ),
                                  ),

                                  const SizedBox(height: 18),

                                  SizedBox(
                                    width: 160,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => AddEditIssuePage(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.add),
                                      label: const Text("Create Issue"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 40),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => AddEditIssuePage()));
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
