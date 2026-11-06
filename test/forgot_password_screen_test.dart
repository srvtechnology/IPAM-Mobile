import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/core/network/api_client.dart';
import 'package:ipam_mobile/core/network/auth_storage_service.dart';
import 'package:ipam_mobile/features/auth/controllers/auth_controller.dart';
import 'package:ipam_mobile/features/auth/screens/forgot_password_screen.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.testMode = true;
    Get.put(AuthStorageService());
    Get.put(ApiClient());
  });

  Widget buildTestWidget() {
    return const GetMaterialApp(
      home: ForgotPasswordScreen(),
    );
  }

  group('ForgotPasswordScreen Tests', () {
    testWidgets('Renders Step 1 (Request Code) initially', (WidgetTester tester) async {
      final controller = Get.put(AuthController());
      controller.forgotPasswordStep.value = 1;

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Forgot Password'), findsOneWidget);
      expect(find.text('Registered University Email'), findsOneWidget);
      expect(find.text('Send Verification Code'), findsOneWidget);
      expect(find.text('Remember your password? Sign In'), findsOneWidget);
    });

    testWidgets('Renders Step 2 (Reset Password with dynamic OTP) when step is 2',
        (WidgetTester tester) async {
      final controller = Get.put(AuthController());
      controller.emailController.text = 'alumni@ipam.edu.sl';
      controller.forgotPasswordStep.value = 2;

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Dynamic 2FA Code Sent'), findsOneWidget);
      expect(find.text('alumni@ipam.edu.sl'), findsOneWidget);
      expect(find.text('Edit Email'), findsOneWidget);
      expect(find.text('Reset Password'), findsOneWidget);
      expect(find.text('6-Digit Verification Code'), findsOneWidget);
      expect(find.text('New Password'), findsOneWidget);
      expect(find.text('Confirm New Password'), findsOneWidget);
      expect(find.text('Reset Password & Sign In'), findsOneWidget);
      expect(find.text('Resend Code'), findsOneWidget);

      // Tapping "Edit Email" switches back to Step 1
      await tester.tap(find.text('Edit Email'));
      await tester.pumpAndSettle();

      expect(controller.forgotPasswordStep.value, 1);
      expect(find.text('Forgot Password'), findsOneWidget);
    });
  });
}

