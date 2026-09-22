import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'shared_text.dart';

class SharedSnackBar {
  static void showSuccess({
    required BuildContext context,
    required String message,
  }) {
    _show(
      context: context,
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline_rounded,
      iconColor: AppColors.gold,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
  }) {
    _show(
      context: context,
      message: message,
      backgroundColor: Colors.redAccent,
      icon: Icons.error_outline_rounded,
      iconColor: Colors.white,
    );
  }

  static void _show({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required Color iconColor,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              Icon(icon, color: iconColor),

              const SizedBox(width: 10),

              Expanded(
                child: SharedText(
                  title: message,
                  colorString: Colors.white,
                  fontNum: 14,
                ),
              ),
            ],
          ),
        ),
      );
  }
}
