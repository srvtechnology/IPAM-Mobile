import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/core/network/api_client.dart';
import 'package:ipam_mobile/core/network/auth_storage_service.dart';
import 'package:ipam_mobile/features/auth/controllers/auth_controller.dart';

void main() {
  setUp(() {
    Get.reset();
    Get.testMode = true;
    Get.put(AuthStorageService());
    Get.put(ApiClient());
  });

  group('AuthController Logic Tests', () {
    test('AuthController initializes with default values', () {
      final controller = Get.put(AuthController());

      expect(controller.selectedAuthTab.value, 0);
      expect(controller.rememberMe.value, isTrue);
      expect(controller.isLoading.value, isFalse);
      expect(controller.otpController.text, '');
      expect(controller.resendCooldown.value, 0);
      expect(controller.forgotPasswordStep.value, 1);

      controller.setAuthTab(1);
      expect(controller.selectedAuthTab.value, 1);

      controller.togglePasswordVisibility();
      expect(controller.isPasswordVisible.value, isTrue);
    });

    test('AuthController logout clears auth storage session', () async {
      final storage = Get.find<AuthStorageService>();
      final controller = Get.put(AuthController());

      await storage.saveToken('dummy_token');
      expect(storage.isAuthenticated, isTrue);

      await controller.logout();
      expect(storage.isAuthenticated, isFalse);
    });

    test('AuthController register accepts test OTP 123456 and saves pending registration', () async {
      final storage = Get.find<AuthStorageService>();
      final controller = Get.put(AuthController());

      controller.emailController.text = 'jane.doe@alumni.ipam.edu';
      controller.fullNameController.text = 'Jane Doe';
      controller.matriculationController.text = 'IPAM-2022-8492';
      controller.passwordController.text = 'Password123!';
      controller.degreeController.text = 'B.Sc';
      controller.majorController.text = 'Applied Computing';
      controller.gradYearController.text = '2022';
      controller.otpController.text = '123456';

      await controller.register();

      expect(storage.pendingRegistration, isNotNull);
      expect(storage.pendingRegistration!['email'], 'jane.doe@alumni.ipam.edu');
      expect(storage.pendingRegistration!['studentId'], 'IPAM-2022-8492');
    });
  });
}
