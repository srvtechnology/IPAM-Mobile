import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/features/profile/screens/virtual_pass_screen.dart';
import 'package:ipam_mobile/models/pass_models.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  final testPass = VirtualPass.fallback(
    name: 'Alex Sesay',
    studentId: 'IPAM-2015-0042',
    degree: 'B.Sc. Applied Accounting',
    classYear: 2015,
  );

  group('VirtualPassScreen Widget Tests', () {
    testWidgets('Renders all Digital ID Pass elements, university crest, EMV chip, and QR code', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: VirtualPassScreen(initialPass: testPass),
        ),
      );
      await tester.pumpAndSettle();

      // Screen Header & Security Pill
      expect(find.text('Digital Alumni Pass'), findsWidgets);
      expect(find.text('USL REGISTRAR CRYPTOGRAPHIC PASS • V1'), findsOneWidget);
      expect(find.text('UNIVERSITY OF SIERRA LEONE'), findsOneWidget);
      expect(find.text('Institute of Public Administration and Management (IPAM)'), findsOneWidget);

      // Member Credentials
      expect(find.text('Alex Sesay'), findsWidgets);
      expect(find.text('B.Sc. Applied Accounting • Class of 2015'), findsOneWidget);
      expect(find.text('PLATINUM MEMBER'), findsOneWidget);
      expect(find.text('USL REGISTRAR CERTIFIED'), findsOneWidget);
      expect(find.text('IPAM-2015-0042'), findsWidgets);

      // QR Code rendering
      expect(find.byType(QrImageView), findsWidgets);
      expect(find.text('SCAN OR TAP TO ENLARGE'), findsOneWidget);

      // Action Buttons
      expect(find.text('Scan Member Pass'), findsOneWidget);
      expect(find.text('Enlarge Code'), findsOneWidget);
      expect(find.text('Add to Apple / Google Wallet'), findsOneWidget);
      expect(find.text('Export PDF Pass'), findsOneWidget);
      expect(find.text('Share Pass'), findsOneWidget);

      // Security Notice
      expect(find.text('Institutional Authenticity Guarantee'), findsOneWidget);
    });

    testWidgets('Tapping Enlarge Code opens zoom dialog with cryptographic verification details', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: VirtualPassScreen(initialPass: testPass),
        ),
      );
      await tester.pumpAndSettle();

      // Find and scroll to "Enlarge Code" button
      final enlargeBtn = find.text('Enlarge Code');
      expect(enlargeBtn, findsOneWidget);
      await tester.ensureVisible(enlargeBtn);
      await tester.pumpAndSettle();

      await tester.tap(enlargeBtn);
      await tester.pumpAndSettle();

      // Verify enlarged QR dialog appears
      expect(find.text('Registrar Cryptographic Token'), findsOneWidget);
      expect(find.text('Present this QR code for gate check-in, library access, and official alumni events.'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);

      // Dismiss dialog
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(find.text('Registrar Cryptographic Token'), findsNothing);
    });
  });
}
