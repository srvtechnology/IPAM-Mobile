import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../constants/api_endpoints.dart';
import '../network/api_client.dart';
import '../network/auth_storage_service.dart';
import '../../firebase_options.dart';
import '../../routes/app_pages.dart';

/// Top-level background message handler required by Firebase Cloud Messaging.
/// Must be annotated with @pragma('vm:entry-point') so it is not tree-shaken by Dart.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase already initialized or background initialization note: $e');
  }
  debugPrint('🔥 [FCM Background] MessageId: ${message.messageId}');
  debugPrint('🔥 [FCM Background] Title: ${message.notification?.title}');
  debugPrint('🔥 [FCM Background] Data payload: ${message.data}');
}

class NotificationService extends GetxService {
  static NotificationService get to => Get.find<NotificationService>();
  static NotificationService get instance => Get.isRegistered<NotificationService>()
      ? Get.find<NotificationService>()
      : Get.put(NotificationService(), permanent: true);

  final FirebaseMessaging? _customFcm;
  final FlutterLocalNotificationsPlugin? _customLocalNotifications;

  NotificationService({
    FirebaseMessaging? fcm,
    FlutterLocalNotificationsPlugin? localNotifications,
  })  : _customFcm = fcm,
        _customLocalNotifications = localNotifications;

  FirebaseMessaging get _fcm => _customFcm ?? FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin get _localNotifications =>
      _customLocalNotifications ?? FlutterLocalNotificationsPlugin();

  AuthStorageService get _authStorage {
    if (Get.isRegistered<AuthStorageService>()) {
      return Get.find<AuthStorageService>();
    }
    return Get.put(AuthStorageService(), permanent: true);
  }

  ApiClient get _client {
    if (Get.isRegistered<ApiClient>()) {
      return Get.find<ApiClient>();
    }
    return Get.put(ApiClient(), permanent: true);
  }

  final RxnString fcmToken = RxnString();
  final RxBool isInitialized = false.obs;

  /// High importance notification channel for Android heads-up notifications
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'ipam_alumni_notifications',
    'IPAM Alumni Official Notifications',
    description: 'Degree sign-offs, physical ID tracking, job updates, and official broadcasts.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  /// Initializes FCM, permissions, local notifications plugin, and message streams
  Future<NotificationService> init() async {
    try {
      // 1. Request notification permissions (iOS & Android 13+)
      await _requestPermissions();

      // 2. Setup local notifications for foreground alerts
      await _setupLocalNotifications();

      // 3. Register and obtain device FCM token
      await _fetchFcmToken();

      // 4. Setup message listeners (foreground, background, tap)
      _setupMessageHandlers();

      // 5. Auto-subscribe to institutional broadcast topic
      await subscribeToTopic('all_alumni');

      isInitialized.value = true;
      debugPrint('🔔 NotificationService initialized successfully.');
    } catch (e, stack) {
      debugPrint('⚠️ Failed to initialize NotificationService: $e');
      debugPrint('$stack');
    }
    return this;
  }

  /// Request permissions from user
  Future<void> _requestPermissions() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('🔔 FCM Authorization status: ${settings.authorizationStatus}');
  }

  /// Configure flutter_local_notifications
  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final data = jsonDecode(response.payload!);
            if (data is Map<String, dynamic>) {
              _handleNotificationClick(data);
            } else {
              _handleNavigationPayload(response.payload!);
            }
          } catch (_) {
            _handleNavigationPayload(response.payload!);
          }
        }
      },
    );

    // Create high-importance Android channel
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (platform != null) {
      await platform.createNotificationChannel(_channel);
    }

    // Set foreground notification presentation options for iOS
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Retrieve FCM registration token, cache it, and setup rotation listener
  Future<void> _fetchFcmToken() async {
    try {
      // Listen to registered token updates (Firebase Messaging 17+)
      _fcm.onRegistered.listen((token) async {
        fcmToken.value = token;
        await _authStorage.saveFcmToken(token);
        debugPrint('📱 FCM Token received via onRegistered: $token');
        await syncTokenWithBackend(token);
      });

      // Register device with FCM
      await _fcm.register();

      // Retrieve device token
      // ignore: deprecated_member_use
      final token = await _fcm.getToken();
      if (token != null) {
        fcmToken.value = token;
        await _authStorage.saveFcmToken(token);
        debugPrint('📱 Device FCM Token: $token');
        await syncTokenWithBackend(token);
      }

      // Token rotation listener
      // ignore: deprecated_member_use
      _fcm.onTokenRefresh.listen((newToken) async {
        debugPrint('🔄 FCM Token Refreshed: $newToken');
        fcmToken.value = newToken;
        await _authStorage.saveFcmToken(newToken);
        await syncTokenWithBackend(newToken);
      });
    } catch (e) {
      debugPrint('⚠️ Error registering FCM token: $e');
    }
  }

  /// Returns active FCM device token
  Future<String?> getDeviceToken() async {
    if (fcmToken.value != null && fcmToken.value!.isNotEmpty) {
      return fcmToken.value;
    }
    final stored = await _authStorage.getFcmToken();
    if (stored != null && stored.isNotEmpty) {
      fcmToken.value = stored;
      return stored;
    }
    try {
      // ignore: deprecated_member_use
      final token = await _fcm.getToken();
      if (token != null) {
        fcmToken.value = token;
        await _authStorage.saveFcmToken(token);
      }
      return token;
    } catch (e) {
      debugPrint('Could not retrieve token: $e');
      return null;
    }
  }

  /// Collects device metadata for registration payload
  Future<String> getDeviceName() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        final brand = androidInfo.manufacturer.capitalizeFirst ?? androidInfo.manufacturer;
        return '$brand ${androidInfo.model}'.trim();
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.utsname.machine.trim();
      }
    } catch (e) {
      debugPrint('Error getting device name: $e');
    }
    return 'Mobile Device';
  }

  Future<String> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      return '1.0.0';
    }
  }

  String getPlatformString() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'android';
  }

  /// Synchronizes device token with the IPAM backend (POST /api/notifications/register-token)
  Future<void> syncTokenWithBackend(String token) async {
    try {
      await _authStorage.saveFcmToken(token);

      if (!_authStorage.isAuthenticated) {
        debugPrint('ℹ️ User not authenticated yet. FCM token cached for post-login sync.');
        return;
      }

      final deviceName = await getDeviceName();
      final appVersion = await getAppVersion();
      final platform = getPlatformString();

      final response = await _client.post(
        ApiEndpoints.registerToken,
        {
          'token': token,
          'platform': platform,
          'deviceName': deviceName,
          'appVersion': appVersion,
          'subscribeToAll': true,
        },
      );

      if (response.isOk) {
        debugPrint('✅ FCM token registered on backend: ${response.statusCode}');
      } else {
        debugPrint('⚠️ Register token status: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Failed to register FCM token on backend: $e');
    }
  }

  /// Unregisters FCM token on logout to stop notifications for the account
  Future<void> unregisterOnLogout() async {
    try {
      final token = await getDeviceToken();
      if (token != null && token.isNotEmpty) {
        final response = await _client.post(
          ApiEndpoints.unregisterToken,
          {'token': token},
        );
        debugPrint('🚪 FCM token unregistered on backend: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('⚠️ Token unregister notice: $e');
    }
  }

  /// Register FCM message handlers
  void _setupMessageHandlers() {
    // 1. App in Foreground: Show a local notification banner
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 [FCM Foreground] Received: ${message.notification?.title}');
      _showForegroundNotification(message);
    });

    // 2. App opened from background by tapping a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🚀 [FCM onMessageOpenedApp] Clicked notification: ${message.data}');
      _handleNotificationClick(message.data);
    });

    // 3. App launched from terminated state via notification tap
    _fcm.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('⚡ [FCM getInitialMessage] Launched from terminated: ${message.data}');
        Future.delayed(const Duration(milliseconds: 600), () {
          _handleNotificationClick(message.data);
        });
      }
    });
  }

  /// Shows heads-up notification when app is active in foreground
  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    final title = notification?.title ?? data['title'] ?? 'IPAM Alumni Association';
    final body = notification?.body ?? data['message'] ?? '';
    final actionUrl = data['actionUrl'] ?? data['route'] ?? data['screen'] ?? '';

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFF10B981), // Emerald 500
      styleInformation: BigTextStyleInformation(body),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: jsonEncode({
        'actionUrl': actionUrl,
        ...data,
      }),
    );
  }

  /// Handles notification tap payload
  void _handleNotificationClick(Map<String, dynamic> data) {
    debugPrint('FCM: Handling notification payload click: $data');
    final actionUrl = data['actionUrl'] ?? data['route'] ?? data['screen'] ?? '';
    _handleNavigationPayload(actionUrl.toString(), extraData: data);
  }

  /// Deep-link routing based on the IPAM route matrix
  void handleNavigationPayload(String actionUrl, {Map<String, dynamic>? extraData}) {
    debugPrint('🧭 Deep linking to action URL: $actionUrl');
    final target = actionUrl.trim();
    final lower = target.toLowerCase();

    if (lower == '/pass' || lower.contains('virtual_pass') || lower.contains('/virtual-pass')) {
      Get.toNamed(Routes.VIRTUAL_PASS, arguments: extraData);
    } else if (lower.contains('/jobs') ||
        lower.contains('job_applications') ||
        lower.contains('/careers/applications')) {
      Get.toNamed(Routes.CAREER_APPLICATIONS, arguments: extraData);
    } else if (lower.contains('/careers') || lower.contains('careers')) {
      Get.toNamed(Routes.CAREERS, arguments: extraData);
    } else if (lower.contains('/events') || lower.contains('event_detail')) {
      Get.toNamed(Routes.EVENTS, arguments: extraData);
    } else if (lower.contains('/physical-card') ||
        lower.contains('card_tracker') ||
        lower.contains('/card-tracker') ||
        lower.contains('/id-cards')) {
      Get.toNamed(Routes.DASHBOARD, arguments: extraData);
    } else if (target.isNotEmpty && target != '/notifications') {
      // Check if target is a valid registered route
      final exists = Get.routeTree.routes.any((route) => route.name == target);
      if (exists) {
        Get.toNamed(target, arguments: extraData);
      } else {
        Get.toNamed(Routes.NOTIFICATIONS, arguments: extraData);
      }
    } else {
      Get.toNamed(Routes.NOTIFICATIONS, arguments: extraData);
    }
  }

  void _handleNavigationPayload(String actionUrl, {Map<String, dynamic>? extraData}) =>
      handleNavigationPayload(actionUrl, extraData: extraData);

  /// Subscribe to an FCM notification topic (e.g. 'all_alumni')
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _fcm.subscribeToTopic(topic);
      debugPrint('FCM: Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('FCM: Error subscribing to topic $topic: $e');
    }
  }

  /// Unsubscribe from an FCM notification topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _fcm.unsubscribeFromTopic(topic);
      debugPrint('FCM: Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('FCM: Error unsubscribing from topic $topic: $e');
    }
  }
}
