import 'package:flutter/material.dart';

class AppConfirmDialog {
  static Future<void> show({
    required BuildContext context,
    required String message,
    required String primaryButtonText,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: primaryButtonText == "Delete"
                      ? Icon(Icons.delete, color: colorScheme.error, size: 28)
                      : Icon(
                          Icons.info_outline,
                          color: colorScheme.primary,
                          size: 28,
                        ),
                ),

                const SizedBox(height: 16),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                    color: colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if (onCancel != null) onCancel();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: colorScheme.outline.withOpacity(0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryButtonText == "Delete"
                              ? colorScheme.error
                              : colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(primaryButtonText),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
