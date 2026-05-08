import 'package:flutter/material.dart';
import 'package:pocket_desk/features/issue/domain/entities/issue_priority.dart';

class PrioritySelector extends StatelessWidget {
  final IssuePriority selected;
  final ValueChanged<IssuePriority> onChanged;
  const PrioritySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: IssuePriority.values.map((priority) {
        final color = priority.color;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(priority),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected == priority
                    ? color.withOpacity(0.15)
                    : Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: selected == priority
                      ? color
                      : Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.circle, color: color, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    priority.uiName,
                    style: TextStyle(
                      fontWeight: selected == priority
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
