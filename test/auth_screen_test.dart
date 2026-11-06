import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/core/network/auth_storage_service.dart';
import 'package:ipam_mobile/features/auth/controllers/auth_controller.dart';
import 'package:ipam_mobile/features/auth/screens/auth_screen.dart';
import 'package:ipam_mobile/routes/app_pages.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.put(AuthStorageService());
    Get.put(AuthController());
  });

  Widget buildTestWidget({int initialTab = 0}) {
    return GetMaterialApp(
      home: AuthScreen(initialTab: initialTab),
    );
  }

  testWidgets('AuthScreen renders Sign In tab by default and switches to Register cleanly', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(initialTab: 0));
    await tester.pumpAndSettle();

    // Top Header & Registrar Badge
    expect(find.text('UNIVERSITY OF SIERRA LEONE'), findsOneWidget);
    expect(find.text('Registrar\nAuthenticated'), findsOneWidget);

    // Segmented Tabs
    expect(find.text('Sign In'), findsWidgets);
    expect(find.text('Register as Graduate'), findsOneWidget);

    // Network Pill
    expect(find.text('EST. 1980 • 15,000+ GLOBAL NETWORK'), findsOneWidget);

    // Sign In Title & Fields
    expect(find.text('Welcome Back, Alumnus'), findsOneWidget);
    expect(find.text('Email or Alumni ID'), findsOneWidget);
    expect(find.text('Matriculation No. Accepted'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Remember device'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Sign In to Alumni Portal'), findsOneWidget);

    // Switch to "Register as Graduate" tab by tapping the tab button
    await tester.tap(find.text('Register as Graduate'));
    await tester.pumpAndSettle();

    // Register Tab Title & Fields
    expect(find.text('Register as Graduate'), findsWidgets);
    expect(find.text('Official Full Name'), findsOneWidget);
    expect(find.text('As on USL Degree Scroll'), findsOneWidget);
    expect(find.text('Matriculation Number'), findsOneWidget);
    expect(find.text('e.g. IPAM/2019/0142'), findsOneWidget);
    expect(find.text('Grad Year'), findsOneWidget);
    expect(find.text('Degree / Faculty'), findsOneWidget);
    expect(find.text('Primary Email Address'), findsOneWidget);
    expect(find.text('Create Password'), findsOneWidget);
    expect(find.text('Verify with USL Registrar & Register'), findsOneWidget);

    // Switch back to "Sign In"
    await tester.tap(find.widgetWithText(Row, 'Sign In').first);
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back, Alumnus'), findsOneWidget);
  });

  testWidgets('AuthScreen directly renders Register as Graduate when initialTab is 1', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(initialTab: 1));
    await tester.pumpAndSettle();

    expect(find.text('Register as Graduate'), findsWidgets);
    expect(find.text('Official Full Name'), findsOneWidget);
    expect(find.text('Matriculation Number'), findsOneWidget);
  });

  testWidgets('Redirecting to Login after registration renders cleanly with pre-filled email without error',
      (WidgetTester tester) async {
    final controller = Get.find<AuthController>();
    controller.emailController.text = 'new.graduate@alumni.ipam.edu';
    controller.passwordController.text = 'Password123!';

    // Simulate navigation to Login screen with registered email in arguments
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/auth/login',
      getPages: [
        GetPage(
          name: '/auth/login',
          page: () => const AuthScreen(initialTab: 0),
        ),
      ],
    ));
    await tester.pumpAndSettle();

    // Verify Sign In screen renders cleanly without any ErrorWidget
    expect(find.byType(ErrorWidget), findsNothing);
    expect(find.text('Welcome Back, Alumnus'), findsOneWidget);
    expect(find.text('Email or Alumni ID'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In to Alumni Portal'), findsOneWidget);

    // Verify text can be entered and modified without any assertion
    await tester.enterText(find.widgetWithText(TextFormField, '••••••••••••'), 'MySecretPassword');
    await tester.pumpAndSettle();
    expect(controller.passwordController.text, 'MySecretPassword');
  });

  testWidgets('Register tab renders password strength indicator, live criteria checklist, and enforces strong password',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(initialTab: 1));
    await tester.pumpAndSettle();

    // 1. Initial State: All 5 criteria chips should be rendered
    expect(find.text('Create Password'), findsOneWidget);
    expect(find.text('8+ chars'), findsOneWidget);
    expect(find.text('Uppercase (A-Z)'), findsOneWidget);
    expect(find.text('Lowercase (a-z)'), findsOneWidget);
    expect(find.text('Number (0-9)'), findsOneWidget);
    expect(find.text('Special (!@#\$)'), findsOneWidget);

    // 2. Enter weak password into Create Password field
    final passwordFieldFinder = find.widgetWithText(TextFormField, 'At least 8 chars with Aa, 1, @');
    expect(passwordFieldFinder, findsOneWidget);

    await tester.enterText(passwordFieldFinder, 'weak');
    await tester.pumpAndSettle();

    // Should indicate "Weak" strength
    expect(find.text('Weak'), findsOneWidget);

    // 3. Fill other required fields so we can test password validation specifically
    final controller = Get.find<AuthController>();
    controller.fullNameController.text = 'Mohamed S. Bangura';
    controller.matriculationController.text = 'IPAM/2019/0142';
    controller.gradYearController.text = '2020';
    controller.degreeController.text = 'B.Sc. Applied Accounting';
    controller.majorController.text = 'Applied Accounting';
    controller.emailController.text = 'mohamed.bangura@alumni.ipam.edu';

    // 4. Tap "Verify with USL Registrar & Register" with weak password
    final submitButtonFinder = find.text('Verify with USL Registrar & Register');
    await tester.ensureVisible(submitButtonFinder);
    await tester.tap(submitButtonFinder);
    await tester.pumpAndSettle();

    // Should trigger validation error for length
    expect(find.text('Password must be at least 8 characters'), findsOneWidget);

    // 5. Update to partially strong password (missing special character)
    await tester.enterText(passwordFieldFinder, 'SecretPass123');
    await tester.pumpAndSettle();
    expect(find.text('Good'), findsOneWidget);

    await tester.tap(submitButtonFinder);
    await tester.pumpAndSettle();
    expect(find.text('Include at least one special character (!@#\$%^&*)'), findsOneWidget);

    // 6. Enter a fully strong password
    await tester.enterText(passwordFieldFinder, 'SecretP@ss123');
    await tester.pumpAndSettle();

    // Strength should be "Strong"
    expect(find.text('Strong'), findsWidgets);
    expect(find.text('Password must be at least 8 characters'), findsNothing);
    expect(find.text('Include at least one special character (!@#\$%^&*)'), findsNothing);
  });

  testWidgets('Redirecting to Login after registration renders all sign-in fields and pre-filled email cleanly without error',
      (WidgetTester tester) async {
    FlutterErrorDetails? caughtError;
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      caughtError = details;
      originalOnError?.call(details);
    };

    await tester.pumpWidget(GetMaterialApp(
      initialRoute: Routes.REGISTER,
      getPages: AppPages.routes,
    ));
    await tester.pumpAndSettle();

    final controller = Get.find<AuthController>();
    controller.selectedAuthTab.value = 1;
    await tester.pumpAndSettle();

    // Navigate to OTP verification
    Get.toNamed(Routes.OTP_VERIFICATION);
    await tester.pumpAndSettle();

    // Simulate completion of registration redirecting to Login
    controller.resetFormKeys();
    controller.selectedAuthTab.value = 0;
    Get.offAllNamed(Routes.LOGIN, arguments: {'tab': 0, 'email': 'test.graduate@alumni.ipam.edu'});

    // Pump frame during transition
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();

    FlutterError.onError = originalOnError;

    // Verify all Sign In form fields are visible and properly rendered without any error
    expect(caughtError, isNull);
    expect(find.byType(ErrorWidget), findsNothing);
    expect(find.text('Welcome Back, Alumnus'), findsOneWidget);
    expect(find.text('Email or Alumni ID'), findsOneWidget);
    expect(find.text('Matriculation No. Accepted'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Remember device'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Sign In to Alumni Portal'), findsOneWidget);
    expect(find.text('test.graduate@alumni.ipam.edu'), findsOneWidget);
  });
}
