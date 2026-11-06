import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ipam_mobile/models/pass_models.dart';
import 'package:ipam_mobile/services/pass_pdf_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _MockPathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  final Directory tempDir;
  _MockPathProviderPlatform(this.tempDir);

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return tempDir.path;
  }
}

void main() {
  late Directory tempDir;
  late PassPdfService pdfService;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('ipam_pdf_test_');
    PathProviderPlatform.instance = _MockPathProviderPlatform(tempDir);
    await GetStorage.init();
    pdfService = PassPdfService();
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  final testPass = VirtualPass.fallback(
    name: 'Mohamed S. Bangura',
    studentId: 'IPAM-ALUM-2016-8841',
    degree: 'B.Sc. Banking & Finance',
    classYear: 2016,
  );

  test('PassPdfService generates valid PDF document file on device storage', () async {
    final pdfFile = await pdfService.generateAndSavePdf(testPass);

    expect(pdfFile.existsSync(), isTrue);
    expect(pdfFile.path.endsWith('IPAM_Alumni_Pass_IPAM-ALUM-2016-8841.pdf'), isTrue);

    // Verify PDF header magic bytes %PDF-
    final bytes = await pdfFile.readAsBytes();
    expect(bytes.length, greaterThan(1000));
    final header = String.fromCharCodes(bytes.sublist(0, 5));
    expect(header, equals('%PDF-'));
  });

  test('PassPdfService caches pass in GetStorage for offline fallback', () async {
    await pdfService.generateAndSavePdf(testPass);

    final storage = GetStorage();
    final cached = storage.read('latest_offline_pass');
    expect(cached, isNotNull);
    expect(cached['name'], equals('Mohamed S. Bangura'));
    expect(cached['studentId'], equals('IPAM-ALUM-2016-8841'));
  });
}
