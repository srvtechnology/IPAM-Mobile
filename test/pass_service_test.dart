import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/core/network/auth_storage_service.dart';
import 'package:ipam_mobile/core/network/models/token_model.dart';
import 'package:ipam_mobile/core/network/models/user_model.dart';
import 'package:ipam_mobile/models/pass_models.dart';
import 'package:ipam_mobile/services/pass_service.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  group('Pass Models Tests', () {
    test('VirtualPass correctly parses full API response payload', () {
      final json = {
        'id': 'cmv163kf90007l42gvm5h5uom',
        'studentId': 'IPAM-2015-0042',
        'name': 'Alex Sesay',
        'avatar': '/uploads/avatar_123.jpg',
        'degree': 'B.Sc. Applied Accounting',
        'major': 'Financial Accounting',
        'classYear': 2015,
        'membershipTier': 'PLATINUM',
        'isVerifiedAlumni': true,
        'membershipValidUntil': '2027-10-15T00:00:00.000Z',
        'issuedAt': '2026-10-15T08:00:00.000Z',
        'institution': 'Institute of Public Administration and Management (IPAM)',
        'qrPayload': '{"schema":"IPAM_PASS_V1","id":"cmv163kf90007l42gvm5h5uom","studentId":"IPAM-2015-0042","name":"Alex Sesay","tier":"PLATINUM","issuedAt":"2026-10-15T08:00:00.000Z"}',
      };

      final pass = VirtualPass.fromJson(json);

      expect(pass.id, 'cmv163kf90007l42gvm5h5uom');
      expect(pass.studentId, 'IPAM-2015-0042');
      expect(pass.name, 'Alex Sesay');
      expect(pass.avatar, '/uploads/avatar_123.jpg');
      expect(pass.degree, 'B.Sc. Applied Accounting');
      expect(pass.major, 'Financial Accounting');
      expect(pass.classYear, 2015);
      expect(pass.membershipTier, 'PLATINUM');
      expect(pass.isVerifiedAlumni, isTrue);
      expect(pass.institution, contains('IPAM'));
      expect(pass.qrPayload, contains('IPAM_PASS_V1'));
      expect(pass.qrPayload, contains('cmv163kf90007l42gvm5h5uom'));

      final outJson = pass.toJson();
      expect(outJson['studentId'], 'IPAM-2015-0042');
      expect(outJson['isVerifiedAlumni'], isTrue);
    });

    test('VirtualPass.fallback generates valid offline demonstration pass', () {
      final fallback = VirtualPass.fallback(
        name: 'Mohamed S. Bangura',
        studentId: 'IPAM-2019-0142',
        degree: 'B.Sc. Banking & Finance',
        classYear: 2019,
      );

      expect(fallback.name, 'Mohamed S. Bangura');
      expect(fallback.studentId, 'IPAM-2019-0142');
      expect(fallback.degree, 'B.Sc. Banking & Finance');
      expect(fallback.classYear, 2019);
      expect(fallback.isVerifiedAlumni, isTrue);
      expect(fallback.membershipTier, 'PLATINUM');
      expect(fallback.qrPayload, contains('IPAM_PASS_V1'));
      expect(fallback.qrPayload, contains('IPAM-2019-0142'));
    });

    test('VerificationResult parses successful verification response from swagger spec', () {
      final json = {
        'valid': true,
        'status': 'APPROVED',
        'message': 'Valid Verified Alumni Pass',
        'verifiedAt': '2026-10-26T11:20:00.000Z',
        'user': {
          'id': 'cmuznxfl90007o63lnxqupalc',
          'studentId': 'IPAM-2015-0042',
          'name': 'Alex Sesay',
          'avatar': '/uploads/avatar_123.jpg',
          'classYear': 2015,
          'degree': 'B.Sc. Applied Accounting',
          'membershipTier': 'PLATINUM',
          'isVerifiedAlumni': true,
        }
      };

      final result = VerificationResult.fromJson(json);

      expect(result.valid, isTrue);
      expect(result.isVerified, isTrue);
      expect(result.status, 'APPROVED');
      expect(result.message, 'Valid Verified Alumni Pass');
      expect(result.displayName, 'Alex Sesay');
      expect(result.studentRegistrationId, 'IPAM-2015-0042');
      expect(result.tier, 'PLATINUM');
      expect(result.graduationYear, 2015);
      expect(result.degree, 'B.Sc. Applied Accounting');

      final outJson = result.toJson();
      expect(outJson['valid'], isTrue);
      expect(outJson['user']['name'], 'Alex Sesay');
    });

    test('VerificationResult handles unverified / invalid pass response', () {
      final json = {
        'valid': false,
        'status': 'REJECTED',
        'message': 'Pass not found or invalid alumni registration',
        'verifiedAt': '2026-10-26T11:25:00.000Z',
        'user': null,
      };

      final result = VerificationResult.fromJson(json);

      expect(result.valid, isFalse);
      expect(result.isVerified, isFalse);
      expect(result.status, 'REJECTED');
      expect(result.message, contains('Pass not found'));
      expect(result.displayName, 'Alumnus');
      expect(result.studentRegistrationId, isEmpty);
    });
  });

  group('PassService Logic and Identifier Extraction Tests', () {
    test('extractIdentifier extracts clean ID from raw studentId string', () {
      final service = PassService();
      expect(service.extractIdentifier('IPAM-2016-8841'), 'IPAM-2016-8841');
      expect(service.extractIdentifier('  IPAM-2016-8841  '), 'IPAM-2016-8841');
    });

    test('extractIdentifier extracts studentId or id from JSON QR payload', () {
      final service = PassService();
      const qrJson = '{"schema":"IPAM_PASS_V1","id":"cmv1234567","studentId":"IPAM-2015-0042","name":"Alex Sesay","tier":"SILVER_LIFETIME"}';

      expect(service.extractIdentifier(qrJson), 'IPAM-2015-0042');

      const qrJsonIdOnly = '{"schema":"IPAM_PASS_V1","id":"cmv1234567","name":"Alex Sesay"}';
      expect(service.extractIdentifier(qrJsonIdOnly), 'cmv1234567');
    });

    test('extractIdentifier extracts identifier from verification URL', () {
      final service = PassService();
      const url1 = 'https://ipam.billnbite.cloud/api/alumni/pass/verify/IPAM-2016-8841';
      expect(service.extractIdentifier(url1), 'IPAM-2016-8841');

      const url2 = 'https://ipam.edu.sl/verify/cmv163kf90007l42gvm5h5uom';
      expect(service.extractIdentifier(url2), 'cmv163kf90007l42gvm5h5uom');
    });

    test('fetchMyPass falls back gracefully to authenticated session user', () async {
      final storage = Get.put(AuthStorageService());
      await storage.saveSession(
        token: TokenModel(
          accessToken: 'test_token',
          refreshToken: 'test_refresh',
          expiresIn: 3600,
        ),
        user: UserModel(
          id: 'user_123',
          email: 'test@alumni.ipam.edu',
          fullName: 'Test Graduate',
          membershipNumber: 'IPAM-2022-7711',
          degree: 'B.Sc. Applied Accounting',
          graduationYear: 2022,
          isVerified: true,
        ),
      );

      final service = PassService();
      final pass = await service.fetchMyPass();

      expect(pass.id, 'user_123');
      expect(pass.studentId, 'IPAM-2022-7711');
      expect(pass.name, 'Test Graduate');
      expect(pass.degree, 'B.Sc. Applied Accounting');
      expect(pass.classYear, 2022);
      expect(pass.isVerifiedAlumni, isTrue);
      expect(pass.qrPayload, contains('IPAM_PASS_V1'));
      expect(pass.qrPayload, contains('IPAM-2022-7711'));
    });
  });
}
