import 'package:flutter/material.dart';
import 'package:pocket_desk/features/issue/domain/entities/summary_stat_item.dart';
import 'package:pocket_desk/features/issue/presentation/widgets/status_summary_card.dart';

class SummaryStatsSection extends StatelessWidget {
  final List<SummaryStatItem> items;

  const SummaryStatsSection({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: StatusSummaryCard(
                  label: item.label,
                  count: item.count,
                  accent: item.color,
                  icon: item.icon,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
