import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/core/network/api_client.dart';
import 'package:ipam_mobile/core/network/auth_storage_service.dart';
import 'package:ipam_mobile/features/auth/controllers/auth_controller.dart';
import 'package:ipam_mobile/features/auth/screens/otp_verification_screen.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.testMode = true;
    Get.put(AuthStorageService());
    Get.put(ApiClient());
    final authController = Get.put(AuthController());
    authController.emailController.text = 'jane.doe@alumni.ipam.edu';
  });

  Widget buildTestWidget() {
    return const GetMaterialApp(
      home: OtpVerificationScreen(),
    );
  }

  testWidgets('OtpVerificationScreen renders all 2FA authentication components cleanly',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Top Header & Status Badges
    expect(find.text('UNIVERSITY OF SIERRA LEONE'), findsOneWidget);
    expect(find.text('Registrar\nVerification'), findsOneWidget);

    // Title and Subtitle
    expect(find.text('Two-Factor Verification'), findsOneWidget);
    expect(find.textContaining('jane.doe@alumni.ipam.edu'), findsAtLeastNWidgets(1));

    // Dynamic 2FA Banner & SMTP Dispatched Notice
    expect(find.text('SMTP Dynamic 2FA'), findsOneWidget);
    expect(find.text('Dispatched via Gmail SMTP'), findsOneWidget);
    expect(find.text('Expires in 15m'), findsOneWidget);

    // 6 PIN Input Boxes (TextFormFields)
    expect(find.byType(TextFormField), findsNWidgets(6));

    // CTA Button
    expect(find.text('Verify & Complete Registration'), findsOneWidget);

    // Resend Code and Back to Edit Link
    expect(find.text('Resend Code'), findsOneWidget);
    expect(find.text('Edit Registration Details'), findsOneWidget);

    // Test helper banner
    expect(find.text('Test Code: 123456'), findsOneWidget);
    expect(find.text('Auto-fill Code'), findsOneWidget);

    // Tapping Auto-fill Code fills 123456 into controller
    await tester.tap(find.text('Auto-fill Code'));
    await tester.pumpAndSettle();

    final controller = Get.find<AuthController>();
    expect(controller.otpController.text, '123456');

    // Entering digits in PIN boxes updates controller.otpController
    final pinInputs = find.byType(TextFormField);
    await tester.enterText(pinInputs.at(0), '9');
    await tester.enterText(pinInputs.at(1), '8');
    await tester.enterText(pinInputs.at(2), '7');
    await tester.enterText(pinInputs.at(3), '6');
    await tester.enterText(pinInputs.at(4), '5');
    await tester.enterText(pinInputs.at(5), '4');
    await tester.pumpAndSettle();

    expect(controller.otpController.text, '987654');
  });

  testWidgets('Navigating to OtpVerificationScreen and popping back allows text field tap without disposal assertion',
      (WidgetTester tester) async {
    final authController = Get.find<AuthController>();
    authController.fullNameController.text = 'Mohamed Bangura';
    authController.emailController.text = 'mohamed@alumni.ipam.edu';

    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/auth/otp',
      getPages: [
        GetPage(
          name: '/auth/otp',
          page: () => const OtpVerificationScreen(),
        ),
      ],
    ));
    await tester.pumpAndSettle();

    // Verify OTP screen is open
    expect(find.text('Two-Factor Verification'), findsOneWidget);

    // Scroll to and tap "Edit Registration Details" (calls Get.back())
    await tester.ensureVisible(find.text('Edit Registration Details'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit Registration Details'));
    await tester.pumpAndSettle();

    // Verify controllers are still alive and usable
    expect(authController.emailController.text, 'mohamed@alumni.ipam.edu');
    expect(authController.fullNameController.text, 'Mohamed Bangura');

    // Modifying or updating value on controller does not throw debugAssertNotDisposed
    authController.emailController.text = 'updated@alumni.ipam.edu';
    expect(authController.emailController.text, 'updated@alumni.ipam.edu');
  });
}
