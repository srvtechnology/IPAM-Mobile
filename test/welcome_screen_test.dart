import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/core/network/auth_storage_service.dart';
import 'package:ipam_mobile/features/auth/screens/welcome_screen.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.put(AuthStorageService());
  });

  Widget buildTestWidget() {
    return const GetMaterialApp(
      home: WelcomeScreen(),
    );
  }

  testWidgets('WelcomeScreen renders redesigned institutional UI elements cleanly', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Verify Official Portal badge
    expect(find.text('OFFICIAL PORTAL • USL REGISTRAR'), findsOneWidget);

    // Verify Institution Crest & Global Network
    expect(find.text('IPAM'), findsOneWidget);
    expect(find.text('UNIVERSITY OF SIERRA LEONE'), findsOneWidget);
    expect(find.text('IPAM GLOBAL NETWORK'), findsOneWidget);

    // Verify Main Headline & Subtitle
    expect(find.text('Connect.\nEmpower. Excel.'), findsOneWidget);
    expect(
      find.text('The Official Association for IPAM Graduates Worldwide. Uniting leaders across public governance & global enterprise.'),
      findsOneWidget,
    );

    // Verify 3 Stat Tiles
    expect(find.text('15,000+'), findsOneWidget);
    expect(find.text('GLOBAL ALUMNI'), findsOneWidget);
    expect(find.text('45+'), findsWidgets); // Stat and chapters
    expect(find.text('COUNTRIES'), findsOneWidget);
    expect(find.text('Est. 1980'), findsOneWidget);
    expect(find.text('FREETOWN'), findsOneWidget);

    // Verify Action Buttons
    expect(find.text('Join Alumni Network'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Explore as Guest'), findsOneWidget);
    expect(find.text('USL Registrar Verified Alumni Records'), findsOneWidget);

    // Verify New Graduate Card
    expect(find.text('New graduate?'), findsOneWidget);
    expect(find.text('REGISTRAR RECORD'), findsOneWidget);
    expect(
      find.text('Register with your Matriculation No. to verify your alumni degree records with the USL Registrar.'),
      findsOneWidget,
    );
    expect(find.text('Claim Verified Digital ID'), findsOneWidget);

    // Verify Trust Indicators & Footer
    expect(find.text('256-bit\nEncrypted'), findsOneWidget);
    expect(find.text('Official USL\nPortal'), findsOneWidget);
    expect(find.text('Tower Hill, Freetown, Sierra Leone • IPAM Alumni Association Secretariat'), findsOneWidget);
  });
}
