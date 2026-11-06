import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'core/network/api_client.dart';
import 'core/network/auth_storage_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_service.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Configure Environment (staging by default for development)
  ApiClient.setEnvironment(AppEnvironment.staging);

  // 2. Initialize Theme Service & Persistence
  final themeService = ThemeService();
  await themeService.init();
  Get.put(themeService, permanent: true);

  // 3. Initialize Persistent Session Storage
  final authStorage = AuthStorageService();
  await authStorage.init();
  Get.put(authStorage, permanent: true);

  // 4. Initialize Global API Client
  Get.put(ApiClient(), permanent: true);

  // 5. Initialize Firebase & Notification Service
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    final notificationService = NotificationService();
    await notificationService.init();
    Get.put(notificationService, permanent: true);
  } catch (e) {
    debugPrint('Firebase initialization note: $e');
  }

  runApp(const IpamAlumniApp());
}

class IpamAlumniApp extends StatelessWidget {
  const IpamAlumniApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.isRegistered<ThemeService>() ? Get.find<ThemeService>() : null;

    if (themeService == null) {
      return GetMaterialApp(
        title: 'IPAM Alumni',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        defaultTransition: Transition.fadeIn,
      );
    }

    return Obx(
      () => GetMaterialApp(
        title: 'IPAM Alumni',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeService.themeMode,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        defaultTransition: Transition.fadeIn,
      ),
    );
  }
}
