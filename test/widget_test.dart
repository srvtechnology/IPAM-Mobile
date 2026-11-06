import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/core/network/auth_storage_service.dart';
import 'package:ipam_mobile/core/network/api_client.dart';
import 'package:ipam_mobile/main.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  testWidgets('IPAM Alumni App launches and renders splash', (WidgetTester tester) async {
    // Inject required dependencies for test environment
    Get.put(AuthStorageService());
    Get.put(ApiClient());

    await tester.pumpWidget(const IpamAlumniApp());
    await tester.pump();

    // Verify IPAM branding is rendered
    expect(find.text('IPAM'), findsOneWidget);
    expect(find.text('ALUMNI ASSOCIATION'), findsOneWidget);
  });
}
