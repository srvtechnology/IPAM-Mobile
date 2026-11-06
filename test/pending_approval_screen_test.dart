import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/core/network/auth_storage_service.dart';
import 'package:ipam_mobile/core/theme/app_theme.dart';
import 'package:ipam_mobile/features/auth/controllers/auth_controller.dart';
import 'package:ipam_mobile/features/auth/screens/pending_approval_screen.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.put(AuthStorageService());
    Get.put(AuthController());
  });

  Widget buildTestWidget({
    ThemeMode themeMode = ThemeMode.light,
    String? email,
    String? name,
    String? studentId,
    String? degree,
    String? major,
  }) {
    return GetMaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: PendingApprovalScreen(
        email: email ?? 'rupeshsingh9790@gmail.com',
        name: name ?? 'Rupesh Singh',
        studentId: studentId ?? 'IPAM/2020/0142',
        degree: degree ?? 'B.Sc. Applied Accounting',
        major: major ?? 'Applied Accounting',
      ),
    );
  }

  testWidgets('PendingApprovalScreen renders institutional verification queue in Light Mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(themeMode: ThemeMode.light));
    await tester.pumpAndSettle();

    // Verification Header & Institutional Badges
    expect(find.text('UNIVERSITY OF SIERRA LEONE'), findsOneWidget);
    expect(find.text('REGISTRY QUEUE'), findsOneWidget);
    expect(find.text('Registration Submitted'), findsOneWidget);
    expect(find.text('Credentials Queued for Registrar Verification'), findsOneWidget);

    // Submitted Degree Record card
    expect(find.text('SUBMITTED DEGREE RECORD'), findsOneWidget);
    expect(find.text('Stage 1 of 2'), findsOneWidget);
    expect(find.text('Rupesh Singh'), findsOneWidget);
    expect(find.text('rupeshsingh9790@gmail.com'), findsOneWidget);
    expect(find.text('IPAM/2020/0142'), findsOneWidget);
    expect(find.text('B.Sc. Applied Accounting • Applied Accounting'), findsOneWidget);

    // Action CTAs
    expect(find.text('Check Approval Status'), findsOneWidget);
    expect(find.text('Explore in Verified Demo Mode'), findsOneWidget);
    expect(find.text('Sign In with Another Account'), findsOneWidget);
  });

  testWidgets('PendingApprovalScreen renders cleanly in Dark Mode with all institutional details',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(
      themeMode: ThemeMode.dark,
      name: 'Mohamed S. Bangura',
      email: 'mohamed.bangura@usl.edu.sl',
      studentId: 'IPAM/2019/0881',
      degree: 'B.Sc. Banking & Finance',
      major: 'Financial Economics',
    ));
    await tester.pumpAndSettle();

    expect(find.text('Registration Submitted'), findsOneWidget);
    expect(find.text('Mohamed S. Bangura'), findsOneWidget);
    expect(find.text('mohamed.bangura@usl.edu.sl'), findsOneWidget);
    expect(find.text('IPAM/2019/0881'), findsOneWidget);
    expect(find.text('B.Sc. Banking & Finance • Financial Economics'), findsOneWidget);
    expect(find.text('Check Approval Status'), findsOneWidget);
    expect(find.text('Explore in Verified Demo Mode'), findsOneWidget);
  });
}

