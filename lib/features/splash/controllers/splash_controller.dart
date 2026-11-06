import 'package:get/get.dart';
import '../../../core/network/auth_storage_service.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';

class SplashController extends GetxController {
  Future<void> navigateToNextScreen() async {
    final storage = Get.find<AuthStorageService>();
    if (storage.isAuthenticated) {
      try {
        final authService = AuthService();
        final session = await authService.checkSession();
        if (session != null) {
          Get.offAllNamed(Routes.DASHBOARD);
          return;
        } else {
          // Token is invalid or expired
          Get.offAllNamed(Routes.WELCOME);
          return;
        }
      } catch (_) {
        // If offline or network timeout, continue with cached session
        Get.offAllNamed(Routes.DASHBOARD);
        return;
      }
    } else {
      Get.offAllNamed(Routes.WELCOME);
    }
  }
}
