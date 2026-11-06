import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class SnackbarUtils {
  static void showSuccess({required String title, required String message}) {
    if (Get.context == null || Get.overlayContext == null) return;
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.emeraldDeep,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle_rounded, color: AppColors.jadeSoft),
      margin: const EdgeInsets.all(AppSpacing.md),
      borderRadius: AppSpacing.radiusMd,
      duration: const Duration(seconds: 3),
      boxShadows: [
        BoxShadow(
          color: AppColors.emeraldDarker.withValues(alpha: 0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static void showError({required String title, required String message}) {
    if (Get.context == null || Get.overlayContext == null) return;
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
      margin: const EdgeInsets.all(AppSpacing.md),
      borderRadius: AppSpacing.radiusMd,
      duration: const Duration(seconds: 4),
      boxShadows: [
        BoxShadow(
          color: AppColors.error.withValues(alpha: 0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static void showInfo({required String title, required String message}) {
    if (Get.context == null || Get.overlayContext == null) return;
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.charcoal,
      colorText: Colors.white,
      icon: const Icon(Icons.info_outline_rounded, color: AppColors.jadeAccent),
      margin: const EdgeInsets.all(AppSpacing.md),
      borderRadius: AppSpacing.radiusMd,
      duration: const Duration(seconds: 3),
    );
  }
}
