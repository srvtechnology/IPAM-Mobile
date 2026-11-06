import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/core/network/api_client.dart';
import 'package:ipam_mobile/core/network/auth_storage_service.dart';
import 'package:ipam_mobile/core/services/notification_service.dart';
import 'package:ipam_mobile/features/notifications/controllers/notifications_controller.dart';
import 'package:ipam_mobile/features/notifications/data/notifications_provider.dart';
import 'package:ipam_mobile/models/auth_models.dart';
import 'package:ipam_mobile/models/notification_model.dart';

class MockNotificationsProvider extends NotificationsProvider {
  final List<AlumniNotification> mockNotifications;
  final int mockUnread;

  MockNotificationsProvider({
    required this.mockNotifications,
    this.mockUnread = 0,
  });

  @override
  Future<NotificationsFeedResult> fetchNotifications() async {
    return NotificationsFeedResult(
      notifications: mockNotifications,
      unreadPersonalCount: mockUnread,
    );
  }

  @override
  Future<bool> markAsRead(String id) async {
    return true;
  }

  @override
  Future<bool> markAllAsRead() async {
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.reset();
    Get.testMode = true;
    Get.put(AuthStorageService());
    Get.put(ApiClient());
  });

  tearDown(() {
    Get.reset();
  });

  group('NotificationService Registration Tests', () {
    test('NotificationService can be instantiated and registered with GetX', () {
      final service = NotificationService();
      Get.put<NotificationService>(service);

      expect(Get.isRegistered<NotificationService>(), isTrue);
      expect(NotificationService.to, equals(service));
      expect(service.isInitialized.value, isFalse);
      expect(service.fcmToken.value, isNull);
    });

    test('Platform string and default values are resolved', () {
      final service = NotificationService();
      expect(service.getPlatformString(), isNotEmpty);
    });
  });

  group('AlumniNotification Model Tests', () {
    test('Parses from backend JSON with all fields', () {
      final json = {
        'id': 'notif_123',
        'type': 'NOTIFICATION',
        'categoryType': 'VERIFICATION',
        'title': 'Degree Verification Approved',
        'message': 'Your Bachelor of Science degree has been signed off.',
        'channels': ['PUSH', 'IN_APP'],
        'date': '2026-10-30T06:00:00.000Z',
        'priority': 'URGENT',
        'audienceLabel': 'Class of 2022',
        'actionUrl': '/pass',
        'isRead': false,
        'isPersonal': true,
      };

      final notif = AlumniNotification.fromJson(json);

      expect(notif.id, 'notif_123');
      expect(notif.type, 'NOTIFICATION');
      expect(notif.categoryType, 'VERIFICATION');
      expect(notif.title, 'Degree Verification Approved');
      expect(notif.isUrgent, isTrue);
      expect(notif.isRead, isFalse);
      expect(notif.isPersonal, isTrue);
      expect(notif.actionUrl, '/pass');
      expect(notif.channels, contains('PUSH'));
    });

    test('toJson and copyWith operate correctly', () {
      final notif = AlumniNotification(
        id: '1',
        type: 'NOTIFICATION',
        categoryType: 'JOB',
        title: 'New Opportunity',
        message: 'A role matches your skills.',
        channels: ['PUSH'],
        date: DateTime(2026, 10, 30),
        priority: 'NORMAL',
        audienceLabel: 'All',
        actionUrl: '/jobs',
        isRead: false,
        isPersonal: true,
      );

      expect(notif.isUrgent, isFalse);

      final updated = notif.copyWith(isRead: true);
      expect(updated.isRead, isTrue);
      expect(updated.id, '1');

      final map = updated.toJson();
      expect(map['isRead'], isTrue);
      expect(map['actionUrl'], '/jobs');
    });
  });

  group('Atomic Handshake Models Tests', () {
    test('LoginRequest serializes device fields for unified handshake', () {
      final req = LoginRequest(
        email: 'demo.alumni@ipam.edu',
        password: 'Password123!',
        rememberMe: true,
        deviceToken: 'mock_fcm_token_1234567890',
        platform: 'android',
        deviceName: 'Google Pixel 8 Pro',
        appVersion: '1.0.0',
        subscribeToAll: true,
      );

      final json = req.toJson();
      expect(json['email'], 'demo.alumni@ipam.edu');
      expect(json['password'], 'Password123!');
      expect(json['deviceToken'], 'mock_fcm_token_1234567890');
      expect(json['platform'], 'android');
      expect(json['deviceName'], 'Google Pixel 8 Pro');
      expect(json['appVersion'], '1.0.0');
      expect(json['subscribeToAll'], isTrue);
    });

    test('LoginResponse parses device registration metadata', () {
      final json = {
        'id': 'user_123',
        'email': 'demo.alumni@ipam.edu',
        'studentId': 'IPAM-2015-0042',
        'isVerifiedAlumni': true,
        'membershipTier': 'PLATINUM',
        'status': 'APPROVED',
        'token': 'jwt_token_sample',
        'deviceRegistered': true,
        'topicSubscribed': true,
      };

      final res = LoginResponse.fromJson(json);
      expect(res.id, 'user_123');
      expect(res.email, 'demo.alumni@ipam.edu');
      expect(res.deviceRegistered, isTrue);
      expect(res.topicSubscribed, isTrue);
    });
  });

  group('NotificationsController Tests', () {
    test('fetches notifications and filters by category', () async {
      final mockData = [
        AlumniNotification(
          id: '1',
          type: 'NOTIFICATION',
          categoryType: 'VERIFICATION',
          title: 'Verification Complete',
          message: 'Approved',
          channels: ['PUSH'],
          date: DateTime.now(),
          priority: 'URGENT',
          audienceLabel: 'Class of 2020',
          actionUrl: '/pass',
          isRead: false,
          isPersonal: true,
        ),
        AlumniNotification(
          id: '2',
          type: 'MESSAGE',
          categoryType: 'MESSAGE',
          title: 'Campus Gala Broadcast',
          message: 'Join us tonight',
          channels: ['PUSH'],
          date: DateTime.now(),
          priority: 'NORMAL',
          audienceLabel: 'All',
          actionUrl: '/events',
          isRead: true,
          isPersonal: false,
        ),
      ];

      final provider = MockNotificationsProvider(
        mockNotifications: mockData,
        mockUnread: 1,
      );

      final controller = NotificationsController(provider: provider);
      await controller.fetchNotifications();

      expect(controller.notifications.length, 2);
      expect(controller.unreadCount.value, 1);
      expect(controller.filteredNotifications.length, 2);

      // Filter by VERIFICATION
      controller.setFilter('VERIFICATION');
      expect(controller.filteredNotifications.length, 1);
      expect(controller.filteredNotifications.first.id, '1');

      // Filter by MESSAGE
      controller.setFilter('MESSAGE');
      expect(controller.filteredNotifications.length, 1);
      expect(controller.filteredNotifications.first.id, '2');

      // Reset to ALL
      controller.setFilter('ALL');
      expect(controller.filteredNotifications.length, 2);
    });

    test('markAsRead updates item state and decrements unread count', () async {
      final mockData = [
        AlumniNotification(
          id: '10',
          type: 'NOTIFICATION',
          categoryType: 'JOB',
          title: 'Job Shortlist',
          message: 'You have been shortlisted',
          channels: ['PUSH'],
          date: DateTime.now(),
          priority: 'NORMAL',
          audienceLabel: 'You',
          actionUrl: '/jobs',
          isRead: false,
          isPersonal: true,
        ),
      ];

      final provider = MockNotificationsProvider(
        mockNotifications: mockData,
        mockUnread: 1,
      );

      final controller = NotificationsController(provider: provider);
      await controller.fetchNotifications();

      expect(controller.unreadCount.value, 1);
      expect(controller.notifications.first.isRead, isFalse);

      await controller.markAsRead(controller.notifications.first);

      expect(controller.notifications.first.isRead, isTrue);
      expect(controller.unreadCount.value, 0);
    });

    test('markAllAsRead marks all notifications as read', () async {
      final mockData = [
        AlumniNotification(
          id: '10',
          type: 'NOTIFICATION',
          categoryType: 'JOB',
          title: 'Job Shortlist',
          message: 'Shortlisted',
          channels: ['PUSH'],
          date: DateTime.now(),
          priority: 'NORMAL',
          audienceLabel: 'You',
          isRead: false,
          isPersonal: true,
        ),
        AlumniNotification(
          id: '11',
          type: 'NOTIFICATION',
          categoryType: 'ID_CARD',
          title: 'Card Dispatched',
          message: 'On the way',
          channels: ['PUSH'],
          date: DateTime.now(),
          priority: 'NORMAL',
          audienceLabel: 'You',
          isRead: false,
          isPersonal: true,
        ),
      ];

      final provider = MockNotificationsProvider(
        mockNotifications: mockData,
        mockUnread: 2,
      );

      final controller = NotificationsController(provider: provider);
      await controller.fetchNotifications();

      expect(controller.unreadCount.value, 2);

      await controller.markAllAsRead();

      expect(controller.unreadCount.value, 0);
      expect(controller.notifications.every((n) => n.isRead), isTrue);
    });
  });
}
