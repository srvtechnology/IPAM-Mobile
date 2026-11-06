import 'package:get/get.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../models/notification_model.dart';

class NotificationsFeedResult {
  final List<AlumniNotification> notifications;
  final int unreadPersonalCount;

  NotificationsFeedResult({
    required this.notifications,
    required this.unreadPersonalCount,
  });
}

class NotificationsProvider {
  final ApiClient _client;

  NotificationsProvider({ApiClient? client})
      : _client = client ??
            (Get.isRegistered<ApiClient>()
                ? Get.find<ApiClient>()
                : Get.put(ApiClient(), permanent: true));

  /// Fetches notification stream from backend (GET /api/alumni/notifications)
  Future<NotificationsFeedResult> fetchNotifications() async {
    try {
      final response = await _client.get(ApiEndpoints.alumniNotifications);

      if (response.isOk && response.body != null) {
        final body = response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : (response.body is Map ? Map<String, dynamic>.from(response.body) : <String, dynamic>{});

        final data = body.containsKey('data') && body['data'] is Map
            ? Map<String, dynamic>.from(body['data'])
            : body;

        final rawList = data['notifications'] is List ? data['notifications'] as List : [];
        final notifications = rawList
            .whereType<Map<String, dynamic>>()
            .map((item) => AlumniNotification.fromJson(item))
            .toList();

        final unreadCount = data['unreadPersonalCount'] is int
            ? data['unreadPersonalCount'] as int
            : int.tryParse(data['unreadPersonalCount']?.toString() ?? '0') ?? 0;

        return NotificationsFeedResult(
          notifications: notifications,
          unreadPersonalCount: unreadCount,
        );
      }

      final errorMsg = response.body is Map && response.body['error'] != null
          ? response.body['error'].toString()
          : (response.statusText?.isNotEmpty == true
              ? response.statusText!
              : 'Failed to load notifications (${response.statusCode})');

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to load notifications: $e');
    }
  }

  /// Marks a specific notification as read (PATCH /api/alumni/notifications/{id}/read)
  Future<bool> markAsRead(String id) async {
    try {
      final response = await _client.patch(ApiEndpoints.markNotificationRead(id), {});
      return response.isOk;
    } catch (e) {
      return false;
    }
  }

  /// Marks all personal notifications as read (POST /api/alumni/notifications/read-all)
  Future<bool> markAllAsRead() async {
    try {
      final response = await _client.post(ApiEndpoints.markAllNotificationsRead, {});
      return response.isOk;
    } catch (e) {
      return false;
    }
  }
}

