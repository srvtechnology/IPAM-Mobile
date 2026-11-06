import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/features/profile/screens/qr_scanner_screen.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  group('QrScannerScreen Widget Tests', () {
    testWidgets('Renders AppBar, viewfinder instructions, and manual entry action', (tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: QrScannerScreen(),
        ),
      );
      await tester.pump();

      // AppBar and controls
      expect(find.text('Scan Member Pass'), findsOneWidget);
      expect(find.byTooltip('Toggle Flashlight'), findsOneWidget);
      expect(find.byTooltip('Switch Camera'), findsOneWidget);

      // Viewfinder guidance
      expect(find.text('Align QR code inside the frame to scan'), findsOneWidget);

      // Manual entry fallback
      expect(find.text('Enter Student ID Manually'), findsOneWidget);
    });

    testWidgets('Tapping manual entry opens dialog to type student registration number', (tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: QrScannerScreen(),
        ),
      );
      await tester.pump();

      // Tap "Enter Student ID Manually"
      final manualBtn = find.text('Enter Student ID Manually');
      expect(manualBtn, findsOneWidget);
      await tester.tap(manualBtn);
      await tester.pumpAndSettle();

      // Check dialog content
      expect(find.text('Manual ID Verification'), findsOneWidget);
      expect(find.text('Enter the alumni student ID or registration number to verify against registrar records.'), findsOneWidget);
      expect(find.text('Verify ID'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Cancel dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Manual ID Verification'), findsNothing);
    });
  });
}
