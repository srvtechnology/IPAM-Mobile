import 'package:get/get.dart';
import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/auth_storage_service.dart';
import '../models/directory_models.dart';

/// Networking and Alumni Directory service integrating with:
/// - GET /api/alumni
/// - GET /api/alumni/{id}
/// - POST /api/alumni/{id}/connect
/// - DELETE /api/alumni/{id}/connect
/// - GET /api/alumni/bookmarks
/// - GET /api/alumni/notifications
/// - GET & PATCH /api/profile
class NetworkingService {
  final ApiClient _client;

  NetworkingService({ApiClient? client})
      : _client = client ??
            (Get.isRegistered<ApiClient>()
                ? Get.find<ApiClient>()
                : Get.put(ApiClient(), permanent: true));

  AuthStorageService get _authStorage {
    if (Get.isRegistered<AuthStorageService>()) {
      return Get.find<AuthStorageService>();
    }
    return Get.put(AuthStorageService(), permanent: true);
  }

  bool get isAuthenticated => _authStorage.isAuthenticated;

  /// Searches the global alumni directory with optional query, graduation year, industry, or mentor filter.
  Future<List<AlumniDirectoryMember>> searchDirectory({
    String? query,
    int? classYear,
    String? industry,
    bool? isMentor,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.alumniDirectory,
        query: {
          if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
          if (classYear != null) 'classYear': classYear.toString(),
          if (industry != null && industry != 'All (5.4k)' && industry != 'All') 'industry': industry,
          if (isMentor != null) 'isMentor': isMentor.toString(),
        },
      );

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final list = (body['data'] as List<dynamic>? ?? []);
        return list
            .whereType<Map<String, dynamic>>()
            .map((e) => AlumniDirectoryMember.fromJson(e))
            .toList();
      }

      final errorMsg = response.body is Map && response.body['error'] != null
          ? response.body['error'].toString()
          : (response.statusText?.isNotEmpty == true
              ? response.statusText!
              : 'Failed to search directory (${response.statusCode})');

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Directory search failed: $e');
    }
  }

  /// Retrieves single public alumni profile details (GET /api/alumni/{id})
  Future<AlumniDirectoryMember> getAlumniDetails(String id) async {
    try {
      final response = await _client.get(ApiEndpoints.alumniDetail(id));

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final data = body['data'] as Map<String, dynamic>? ?? body;
        return AlumniDirectoryMember.fromJson(data);
      }

      final errorMsg = response.body is Map && response.body['error'] != null
          ? response.body['error'].toString()
          : (response.statusText?.isNotEmpty == true
              ? response.statusText!
              : 'Alumni profile not found (${response.statusCode})');

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to load alumni details: $e');
    }
  }

  /// Connects with an alumni member (POST /api/alumni/{id}/connect)
  Future<ConnectResponse> connectAlumni(String alumniId) async {
    try {
      final response = await _client.post(
        ApiEndpoints.alumniConnect(alumniId),
        {},
      );

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final data = body['data'] as Map<String, dynamic>? ?? body;
        return ConnectResponse.fromJson(data);
      }

      final errorMsg = response.body is Map && response.body['error'] != null
          ? response.body['error'].toString()
          : (response.statusText?.isNotEmpty == true
              ? response.statusText!
              : 'Connection request failed (${response.statusCode})');

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Connection request failed: $e');
    }
  }

  /// Disconnects from an alumni member (DELETE /api/alumni/{id}/connect)
  Future<ConnectResponse> disconnectAlumni(String alumniId) async {
    try {
      final response = await _client.delete(
        ApiEndpoints.alumniConnect(alumniId),
      );

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final data = body['data'] as Map<String, dynamic>? ?? body;
        return ConnectResponse.fromJson(data);
      }

      final errorMsg = response.body is Map && response.body['error'] != null
          ? response.body['error'].toString()
          : (response.statusText?.isNotEmpty == true
              ? response.statusText!
              : 'Disconnect request failed (${response.statusCode})');

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Disconnect request failed: $e');
    }
  }

  /// Fetches saved network bookmarks / connections (GET /api/alumni/bookmarks)
  Future<List<AlumniDirectoryMember>> fetchBookmarks() async {
    try {
      final response = await _client.get(ApiEndpoints.alumniBookmarks);

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final list = (body['data'] as List<dynamic>? ?? []);
        return list
            .whereType<Map<String, dynamic>>()
            .map((e) => AlumniDirectoryMember.fromJson(e['alumni'] is Map ? e['alumni'] : e))
            .toList();
      }

      final errorMsg = response.body is Map && response.body['error'] != null
          ? response.body['error'].toString()
          : (response.statusText?.isNotEmpty == true
              ? response.statusText!
              : 'Failed to load connections (${response.statusCode})');

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to load connections: $e');
    }
  }

  /// Fetches broadcast notifications (GET /api/alumni/notifications)
  Future<List<BroadcastNotification>> fetchNotifications() async {
    try {
      final response = await _client.get(ApiEndpoints.alumniNotifications);

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final list = (body['data']?['notifications'] as List<dynamic>? ??
            body['data'] as List<dynamic>? ??
            []);
        return list
            .whereType<Map<String, dynamic>>()
            .map((e) => BroadcastNotification.fromJson(e))
            .toList();
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
}
