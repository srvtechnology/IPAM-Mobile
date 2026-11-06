import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'models/token_model.dart';
import 'models/user_model.dart';
import '../constants/storage_keys.dart';

class AuthStorageService extends GetxService {
  final _storage = const FlutterSecureStorage();

  final Rx<TokenModel?> _token = Rx<TokenModel?>(null);
  final Rx<UserModel?> _user = Rx<UserModel?>(null);
  final Rx<Map<String, dynamic>?> _pendingRegistration = Rx<Map<String, dynamic>?>(null);
  final RxBool _isInitialized = false.obs;
  final RxBool _isGuest = false.obs;

  TokenModel? get token => _token.value;
  UserModel? get user => _user.value;
  Map<String, dynamic>? get pendingRegistration => _pendingRegistration.value;
  bool get isAuthenticated => _token.value != null && (_token.value?.accessToken.isNotEmpty ?? false);
  bool get isGuest => _isGuest.value;
  String? get accessToken => _token.value?.accessToken;
  bool get isInitialized => _isInitialized.value;

  void setGuestMode(bool value) {
    _isGuest.value = value;
  }

  Future<AuthStorageService> init() async {
    await _loadSession();
    _isInitialized.value = true;
    return this;
  }

  Future<void> _loadSession() async {
    try {
      final tokenJson = await _storage.read(key: StorageKeys.token);
      if (tokenJson != null && tokenJson.isNotEmpty) {
        _token.value = TokenModel.fromJson(jsonDecode(tokenJson));
      }

      final userJson = await _storage.read(key: StorageKeys.user);
      if (userJson != null && userJson.isNotEmpty) {
        _user.value = UserModel.fromJson(jsonDecode(userJson));
      }

      final pendingJson = await _storage.read(key: StorageKeys.pendingRegistration);
      if (pendingJson != null && pendingJson.isNotEmpty) {
        _pendingRegistration.value = Map<String, dynamic>.from(jsonDecode(pendingJson));
      }
    } catch (e) {
      dev.log('❌ Error loading auth session: $e', name: 'AUTH_STORAGE', error: e);
      await clearSession();
    }
  }

  Future<void> savePendingRegistration({
    required String email,
    required String name,
    required String studentId,
    String? degree,
    String? major,
    int? classYear,
  }) async {
    try {
      final data = {
        'email': email.trim().toLowerCase(),
        'name': name.trim(),
        'studentId': studentId.trim(),
        'degree': degree ?? '',
        'major': major ?? '',
        'classYear': classYear ?? DateTime.now().year,
        'submittedAt': DateTime.now().toIso8601String(),
      };
      _pendingRegistration.value = data;
      await _storage.write(key: StorageKeys.pendingRegistration, value: jsonEncode(data));
    } catch (e) {
      dev.log('❌ Error saving pending registration: $e', name: 'AUTH_STORAGE', error: e);
    }
  }

  Future<void> clearPendingRegistration() async {
    try {
      _pendingRegistration.value = null;
      await _storage.delete(key: StorageKeys.pendingRegistration);
    } catch (e) {
      dev.log('❌ Error clearing pending registration: $e', name: 'AUTH_STORAGE', error: e);
    }
  }

  Future<void> saveSession({required TokenModel token, required UserModel user}) async {
    try {
      _isGuest.value = false;
      _token.value = token;
      _user.value = user;

      await _storage.write(key: StorageKeys.token, value: jsonEncode(token.toJson()));
      await _storage.write(key: 'auth_token', value: token.accessToken);
      await _storage.write(key: StorageKeys.user, value: jsonEncode(user.toJson()));
    } catch (e) {
      dev.log('❌ Error saving auth session: $e', name: 'AUTH_STORAGE', error: e);
    }
  }

  Future<void> saveFcmToken(String fcmToken) async {
    try {
      await _storage.write(key: StorageKeys.fcmDeviceToken, value: fcmToken);
    } catch (e) {
      dev.log('❌ Error saving FCM token: $e', name: 'AUTH_STORAGE', error: e);
    }
  }

  Future<String?> getFcmToken() async {
    try {
      return await _storage.read(key: StorageKeys.fcmDeviceToken);
    } catch (e) {
      dev.log('❌ Error reading FCM token: $e', name: 'AUTH_STORAGE', error: e);
      return null;
    }
  }

  Future<void> clearFcmToken() async {
    try {
      await _storage.delete(key: StorageKeys.fcmDeviceToken);
    } catch (e) {
      dev.log('❌ Error clearing FCM token: $e', name: 'AUTH_STORAGE', error: e);
    }
  }

  Future<void> updateUser(UserModel updatedUser) async {
    try {
      _user.value = updatedUser;
      await _storage.write(key: StorageKeys.user, value: jsonEncode(updatedUser.toJson()));
    } catch (e) {
      dev.log('❌ Error updating user: $e', name: 'AUTH_STORAGE', error: e);
    }
  }

  Future<void> saveToken(String rawToken) async {
    try {
      final tokenModel = TokenModel(accessToken: rawToken, refreshToken: '');
      _token.value = tokenModel;
      await _storage.write(key: StorageKeys.token, value: jsonEncode(tokenModel.toJson()));
    } catch (e) {
      dev.log('❌ Error saving token: $e', name: 'AUTH_STORAGE', error: e);
    }
  }

  Future<String?> getToken() async {
    if (_token.value?.accessToken.isNotEmpty ?? false) {
      return _token.value!.accessToken;
    }
    try {
      final tokenJson = await _storage.read(key: StorageKeys.token);
      if (tokenJson != null && tokenJson.isNotEmpty) {
        final decoded = jsonDecode(tokenJson);
        if (decoded is Map<String, dynamic>) {
          return decoded['accessToken'] ?? decoded['access_token'] ?? decoded['token'];
        }
        return tokenJson;
      }
    } catch (_) {}
    return null;
  }

  Future<void> clearToken() async {
    await clearSession();
  }

  Future<void> clearSession() async {
    try {
      _isGuest.value = false;
      _token.value = null;
      _user.value = null;
      await _storage.delete(key: StorageKeys.token);
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: StorageKeys.user);
    } catch (e) {
      dev.log('❌ Error clearing auth session: $e', name: 'AUTH_STORAGE', error: e);
    }
  }
}
