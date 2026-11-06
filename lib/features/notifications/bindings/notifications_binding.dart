import 'package:get/get.dart';
import '../controllers/notifications_controller.dart';
import '../data/notifications_provider.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsProvider>(() => NotificationsProvider());
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(provider: Get.find<NotificationsProvider>()),
    );
  }
}

