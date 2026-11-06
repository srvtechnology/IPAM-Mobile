import 'package:get/get.dart';
import '../../../core/services/notification_service.dart';
import '../../../models/notification_model.dart';
import '../data/notifications_provider.dart';

class NotificationsController extends GetxController {
  final NotificationsProvider _provider;

  NotificationsController({NotificationsProvider? provider})
      : _provider = provider ?? NotificationsProvider();

  final RxList<AlumniNotification> notifications = <AlumniNotification>[].obs;
  final RxBool isLoading = true.obs;
  final RxInt unreadCount = 0.obs;
  final RxString selectedCategory = 'ALL'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  List<AlumniNotification> get filteredNotifications {
    if (selectedCategory.value == 'ALL') {
      return notifications;
    }
    return notifications.where((item) {
      final cat = (item.categoryType ?? item.type).toUpperCase();
      return cat == selectedCategory.value;
    }).toList();
  }

  void setFilter(String category) {
    selectedCategory.value = category;
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final result = await _provider.fetchNotifications();
      notifications.assignAll(result.notifications);
      unreadCount.value = result.unreadPersonalCount;
    } catch (_) {
      // Retain existing notifications if network drop occurs
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(AlumniNotification notif) async {
    if (notif.isRead || !notif.isPersonal) return;

    final index = notifications.indexWhere((n) => n.id == notif.id);
    if (index != -1) {
      notifications[index] = notif.copyWith(isRead: true);
      if (unreadCount.value > 0) {
        unreadCount.value--;
      }
    }

    await _provider.markAsRead(notif.id);
  }

  Future<void> markAllAsRead() async {
    try {
      final success = await _provider.markAllAsRead();
      if (success) {
        for (var i = 0; i < notifications.length; i++) {
          if (!notifications[i].isRead) {
            notifications[i] = notifications[i].copyWith(isRead: true);
          }
        }
        unreadCount.value = 0;
      }
    } catch (_) {}
  }

  void onNotificationTap(AlumniNotification notif) {
    markAsRead(notif);

    final actionUrl = notif.actionUrl;
    if (actionUrl != null && actionUrl.trim().isNotEmpty) {
      if (Get.isRegistered<NotificationService>()) {
        NotificationService.to.handleNavigationPayload(
          actionUrl,
          extraData: notif.toJson(),
        );
      }
    }
  }
}

