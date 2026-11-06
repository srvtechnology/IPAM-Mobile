import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../routes/app_pages.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Obx(() {
      final currentStep = controller.forgotPasswordStep.value;

      return Scaffold(
        backgroundColor: AppColors.background(context),
        appBar: CustomAppBar(
          title: '',
          showBackButton: true,
          onBack: () {
            if (currentStep == 2) {
              controller.forgotPasswordStep.value = 1;
            } else {
              Get.back();
            }
          },
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: currentStep == 1
                ? _buildStepOneRequestCode(context, isDark)
                : _buildStepTwoResetPassword(context, isDark),
          ),
        ),
      );
    });
  }

  /// Step 1: Input registered academic email to request dynamic 6-digit OTP
  Widget _buildStepOneRequestCode(BuildContext context, bool isDark) {
    return Form(
      key: controller.forgotPasswordFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          // Shield / Key Icon Badge
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.emeraldDeep.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              color: AppColors.emeraldDeep,
              size: 28,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Forgot Password',
            style: GoogleFonts.libreCaslonText(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.emeraldDeep,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the verified email associated with your IPAM alumni account. We will dispatch a single-use 6-digit dynamic OTP to verify your identity.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary(context),
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 28),
          CustomTextField(
            controller: controller.emailController,
            label: 'Registered University Email',
            hintText: 'e.g. alumni@ipam.edu.sl',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            isLoading: controller.isLoading.value,
            onPressed: controller.forgotPassword,
            child: const Text(
              'Send Verification Code',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () => Get.offAllNamed(Routes.LOGIN),
              child: Text(
                'Remember your password? Sign In',
                style: TextStyle(
                  color: AppColors.emeraldDeep,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Step 2: Enter 6-digit dynamic verification OTP + set new password
  Widget _buildStepTwoResetPassword(BuildContext context, bool isDark) {
    final emailText = controller.emailController.text.trim();

    return Form(
      key: controller.resetPasswordFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          // Email Dispatched Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.mark_email_read_outlined,
                            color: Color(0xFF10B981), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Dynamic 2FA Code Sent',
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 24),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => controller.forgotPasswordStep.value = 1,
                      child: const Text(
                        'Edit Email',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emeraldDeep,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'A single-use 6-digit dynamic code was dispatched via SMTP to:',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  emailText,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Reset Password',
            style: GoogleFonts.libreCaslonText(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.emeraldDeep,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Enter the 6-digit code received in your inbox and configure your new secure account password.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary(context),
                ),
          ),
          const SizedBox(height: 24),

          // 6-digit OTP Field
          Text(
            '6-Digit Verification Code',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.resetOtpController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: 10,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '••••••',
              hintStyle: TextStyle(
                letterSpacing: 10,
                color: isDark ? Colors.grey[600] : Colors.grey[400],
              ),
              filled: true,
              fillColor: isDark ? const Color(0xFF0F172A) : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.emeraldDeep, width: 2),
              ),
            ),
            validator: (val) {
              if (val == null || val.trim().length != 6) {
                return 'Please enter the 6-digit OTP received in your email.';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // New Password Field
          CustomTextField(
            controller: controller.newPasswordController,
            label: 'New Password',
            hintText: 'Minimum 8 characters',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            validator: Validators.password,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 18),

          // Confirm Password Field
          CustomTextField(
            controller: controller.confirmPasswordController,
            label: 'Confirm New Password',
            hintText: 'Re-enter your new password',
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please confirm your new password';
              }
              if (val != controller.newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 28),

          // Submit Reset Button
          PrimaryButton(
            isLoading: controller.isLoading.value,
            onPressed: controller.submitPasswordReset,
            child: const Text(
              'Reset Password & Sign In',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),

          // Resend Code with 30s Countdown
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn't receive the email?",
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: (controller.resendCooldown.value > 0 || controller.isResending.value)
                    ? null
                    : controller.resendForgotPasswordOtp,
                child: Text(
                  controller.resendCooldown.value > 0
                      ? 'Resend in ${controller.resendCooldown.value}s'
                      : (controller.isResending.value ? 'Sending...' : 'Resend Code'),
                  style: TextStyle(
                    color: controller.resendCooldown.value > 0
                        ? AppColors.textSecondary(context)
                        : AppColors.emeraldDeep,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
