import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/core/network/api_client.dart';
import 'package:ipam_mobile/core/network/auth_storage_service.dart';
import 'package:ipam_mobile/features/directory/controllers/directory_controller.dart';
import 'package:ipam_mobile/features/directory/models/alumni_model.dart';
import 'package:ipam_mobile/models/directory_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Directory & Networking Models Tests', () {
    test('AlumniDirectoryMember correctly parses backend API payload', () {
      final json = {
        'id': 'cmv163kf90008l42gqg9mnv0s',
        'name': 'Alex Sesay',
        'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80',
        'classYear': 2015,
        'degree': 'BSc Public Administration',
        'major': 'Public Policy',
        'currentRole': 'Program Manager',
        'company': 'UNDP Sierra Leone',
        'location': 'Freetown',
        'country': 'Sierra Leone',
        'industry': 'Development',
        'isMentor': true,
        'bio': 'Passionate about public sector reform and youth empowerment.',
        'email': 'demo.alumni@ipam.edu',
        'linkedin': null,
        'skills': ['Policy Analysis', 'Project Management', 'Public Speaking'],
        'isVerifiedAlumni': true,
        'membershipTier': 'SILVER_LIFETIME',
      };

      final member = AlumniDirectoryMember.fromJson(json);

      expect(member.id, 'cmv163kf90008l42gqg9mnv0s');
      expect(member.name, 'Alex Sesay');
      expect(member.classYear, 2015);
      expect(member.degree, 'BSc Public Administration');
      expect(member.major, 'Public Policy');
      expect(member.currentRole, 'Program Manager');
      expect(member.company, 'UNDP Sierra Leone');
      expect(member.displayRole, 'Program Manager • UNDP Sierra Leone');
      expect(member.location, 'Freetown');
      expect(member.country, 'Sierra Leone');
      expect(member.industry, 'Development');
      expect(member.isMentor, isTrue);
      expect(member.skills.length, 3);
      expect(member.skills, contains('Policy Analysis'));
      expect(member.bio, contains('Passionate about public sector reform'));
      expect(member.isVerifiedAlumni, isTrue);
      expect(member.membershipTier, 'SILVER_LIFETIME');
    });

    test('BroadcastNotification parses university-wide broadcasts', () {
      final json = {
        'id': 'cmvnotif1',
        'title': 'Annual Alumni Gala 2026 Announced',
        'message': 'Tickets are now live for the Freetown Alumni Reunion Gala.',
        'category': 'EVENT',
        'createdAt': '2026-10-15T09:00:00.000Z',
        'actionUrl': '/events/seed-event-6',
      };

      final notif = BroadcastNotification.fromJson(json);

      expect(notif.id, 'cmvnotif1');
      expect(notif.title, 'Annual Alumni Gala 2026 Announced');
      expect(notif.category, 'EVENT');
      expect(notif.actionUrl, '/events/seed-event-6');
    });

    test('ConnectResponse parses connection status payload', () {
      final json = {
        'connected': true,
        'targetId': 'cmv163kf90008l42gqg9mnv0s',
        'message': 'Connected successfully',
      };

      final resp = ConnectResponse.fromJson(json);

      expect(resp.connected, isTrue);
      expect(resp.targetId, 'cmv163kf90008l42gqg9mnv0s');
      expect(resp.message, 'Connected successfully');
    });

    test('AlumniModel.fromJson maps backend API fields with initials & role', () {
      final json = {
        'id': 'cmv163kf90008l42gqg9mnv0s',
        'name': 'Alex Sesay',
        'avatar': '',
        'classYear': 2015,
        'degree': 'BSc Public Administration',
        'major': 'Public Policy',
        'currentRole': 'Program Manager',
        'company': 'UNDP Sierra Leone',
        'location': 'Freetown',
        'country': 'Sierra Leone',
        'industry': 'Development',
        'isMentor': true,
        'bio': 'Passionate about public sector reform.',
        'skills': ['Leadership'],
      };

      final model = AlumniModel.fromJson(json);

      expect(model.id, 'cmv163kf90008l42gqg9mnv0s');
      expect(model.name, 'Alex Sesay');
      expect(model.initials, 'AS');
      expect(model.graduationYear, 2015);
      expect(model.role, 'Program Manager • UNDP Sierra Leone');
      expect(model.faculty, 'Public Policy');
      expect(model.location, 'Freetown');
      expect(model.chapter, 'Sierra Leone');
      expect(model.isMentor, isTrue);
      expect(model.skills, contains('Leadership'));
    });
  });

  group('DirectoryController Connect & Bookmark Tests', () {
    late DirectoryController controller;

    setUp(() {
      Get.reset();
      Get.put(AuthStorageService());
      Get.put(ApiClient());
      controller = DirectoryController();
      Get.put(controller);
    });

    tearDown(() {
      Get.reset();
    });

    test('toggleConnect toggles connection state optimistically', () async {
      expect(controller.connectedIds.contains('test_id'), isFalse);

      await controller.toggleConnect('test_id', 'Test Member');
      expect(controller.connectedIds.contains('test_id'), isTrue);
      expect(controller.bookmarkedIds.contains('test_id'), isTrue);

      await controller.toggleConnect('test_id', 'Test Member');
      expect(controller.connectedIds.contains('test_id'), isFalse);
      expect(controller.bookmarkedIds.contains('test_id'), isFalse);
    });

    test('toggleBookmark toggles state in sync with connect', () async {
      await controller.toggleBookmark('test_bookmark_id');
      expect(controller.connectedIds.contains('test_bookmark_id'), isTrue);
      expect(controller.bookmarkedIds.contains('test_bookmark_id'), isTrue);

      await controller.toggleBookmark('test_bookmark_id');
      expect(controller.connectedIds.contains('test_bookmark_id'), isFalse);
      expect(controller.bookmarkedIds.contains('test_bookmark_id'), isFalse);
    });
  });
}
