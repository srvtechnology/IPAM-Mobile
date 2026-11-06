import 'dart:developer' as dev;
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'auth_storage_service.dart';
import '../../routes/app_pages.dart';
import '../constants/app_constants.dart';

enum AppEnvironment { staging, production, local }

class ApiClient extends GetConnect {
  static const Map<AppEnvironment, String> _baseUrls = {
    AppEnvironment.local: 'http://localhost:3000',
    AppEnvironment.staging: 'https://ipam.billnbite.cloud',
    AppEnvironment.production: 'https://ipam.billnbite.cloud',
  };

  static AppEnvironment _env = AppEnvironment.production;

  static void setEnvironment(AppEnvironment env) {
    _env = env;
    if (Get.isRegistered<ApiClient>()) {
      Get.find<ApiClient>().httpClient.baseUrl = _baseUrls[_env];
    }
  }

  static AppEnvironment get currentEnvironment => _env;
  static String get currentBaseUrl => _baseUrls[_env]!;

  static String formatUrl(String url) {
    if (url.trim().isEmpty) return url;
    final trimmed = url.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final cleanPath = trimmed.startsWith('/') ? trimmed : '/$trimmed';
    final base = currentBaseUrl.endsWith('/')
        ? currentBaseUrl.substring(0, currentBaseUrl.length - 1)
        : currentBaseUrl;
    return '$base$cleanPath';
  }

  AuthStorageService get _authStorage {
    if (Get.isRegistered<AuthStorageService>()) {
      return Get.find<AuthStorageService>();
    }
    return Get.put(AuthStorageService());
  }

  Future<void> saveToken(String token) async {
    await _authStorage.saveToken(token);
  }

  Future<String?> getToken() async {
    return _authStorage.getToken();
  }

  Future<void> clearToken() async {
    await _authStorage.clearSession();
  }

  @override
  void onInit() {
    super.onInit();

    httpClient.baseUrl = currentBaseUrl;
    httpClient.timeout = AppConstants.connectTimeout;

    // 1. Request Interceptor: Attach Bearer Token & Common Headers
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';

      if (_authStorage.isAuthenticated && _authStorage.accessToken != null) {
        request.headers['Authorization'] = 'Bearer ${_authStorage.accessToken}';
      }

      dev.log(
        '🚀 [${request.method}] ${request.url}',
        name: 'API_CLIENT',
      );

      return request;
    });

    // 2. Response Interceptor: Handle status codes & auth expiration
    httpClient.addResponseModifier((request, response) {
      dev.log(
        '📥 [${response.statusCode}] ${request.url}',
        name: 'API_CLIENT',
      );

      // Handle session expiration (do not trigger on login/register endpoints or public screens)
      final path = request.url.path;
      final isAuthEndpoint = path.contains('/api/auth/alumni/login') ||
          path.contains('/api/auth/alumni/register');

      if (response.statusCode == HttpStatus.unauthorized && !isAuthEndpoint) {
        dev.log('⚠️ 401 Unauthorized encountered on protected route.', name: 'API_CLIENT');
        final wasAuthenticated = _authStorage.isAuthenticated;
        if (wasAuthenticated) {
          _authStorage.clearSession();
          if (Get.key.currentState != null &&
              Get.currentRoute != Routes.LOGIN &&
              Get.currentRoute != Routes.SPLASH &&
              Get.currentRoute != Routes.WELCOME) {
            Get.offAllNamed(Routes.LOGIN);
          }
        }
      }

      return response;
    });
  }
}
