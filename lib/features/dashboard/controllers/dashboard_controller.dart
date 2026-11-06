import 'package:get/get.dart';
import '../../../core/network/auth_storage_service.dart';
import '../../../core/network/models/user_model.dart';

class DashboardController extends GetxController {
  final AuthStorageService _authStorage = Get.find<AuthStorageService>();

  final currentIndex = 0.obs;

  UserModel? get currentUser => _authStorage.user;

  // Stats
  final verifiedMembersCount = 14820.obs;
  final activeChaptersCount = 28.obs;
  final upcomingEventsCount = 6.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void refreshData() {
    update();
  }
}
