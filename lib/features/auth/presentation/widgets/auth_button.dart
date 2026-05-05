import 'package:flutter/material.dart';
import 'package:pocket_desk/config/theme/color_palette.dart';

class AuthButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const AuthButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          shadowColor: ColorPalette.transparentColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
