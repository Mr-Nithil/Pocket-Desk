import 'package:flutter/material.dart';
import 'package:pocket_desk/config/theme/color_palette.dart';

class StatusSummaryCard extends StatelessWidget {
  final String label;
  final int count;

  const StatusSummaryCard({
    required this.label,
    required this.count,
    super.key,
  });

  Color _getAccentColor(BuildContext context) {
    switch (label.toLowerCase()) {
      case 'open':
        return ColorPalette.statusOpen;

      case 'in progress':
        return ColorPalette.statusInProgress;

      case 'resolved':
        return ColorPalette.statusResolved;

      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _getAccentColor(context);

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: accent.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withOpacity(0.18)),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 4),
              color: Colors.black.withOpacity(
                Theme.of(context).brightness == Brightness.dark ? 0.20 : 0.05,
              ),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 48,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    count.toString().padLeft(2, '0'),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
