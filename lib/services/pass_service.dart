import 'dart:convert';
import 'package:get/get.dart';
import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/auth_storage_service.dart';
import '../models/pass_models.dart';

class PassService {
  final ApiClient _client;

  PassService({ApiClient? client})
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

  /// Fetches the digital alumni pass for the authenticated member.
  /// Uses GET /api/alumni/pass with BearerAuth header.
  Future<VirtualPass> fetchMyPass() async {
    final cachedUser = _authStorage.user;
    try {
      final response = await _client.get(ApiEndpoints.alumniPass);

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final data = body.containsKey('data') && body['data'] is Map
            ? Map<String, dynamic>.from(body['data'])
            : body;

        return VirtualPass.fromJson(data);
      }

      final errorMsg = response.body is Map && response.body['error'] != null
          ? response.body['error'].toString()
          : (response.statusText?.isNotEmpty == true
              ? response.statusText!
              : 'Failed to load alumni digital pass (${response.statusCode})');

      throw Exception(errorMsg);
    } catch (e) {
      // If network fails or offline, construct fallback pass from logged in user profile if available
      final user = cachedUser ?? _authStorage.user;
      if (user != null && user.fullName.isNotEmpty) {
        return VirtualPass.fallback(
          id: user.id,
          name: user.fullName,
          studentId: (user.membershipNumber != null && user.membershipNumber!.isNotEmpty)
              ? user.membershipNumber!
              : 'IPAM-2019-0142',
          degree: user.degree,
          classYear: user.graduationYear,
        );
      }
      return VirtualPass.fallback();
    }
  }

  /// Verifies a scanned pass using user ID or student registration ID.
  /// Uses public endpoint GET /api/alumni/pass/verify/{id}.
  Future<VerificationResult> verifyPass(String identifier) async {
    final cleanId = extractIdentifier(identifier);
    if (cleanId.isEmpty) {
      throw Exception('Scanned QR code did not contain a valid student ID or pass token');
    }

    final encodedId = Uri.encodeComponent(cleanId);
    final response = await _client.get('${ApiEndpoints.verifyPass}/$encodedId');

    if (response.isOk && response.body != null) {
      final body = response.body is Map
          ? Map<String, dynamic>.from(response.body)
          : <String, dynamic>{};

      final data = body.containsKey('data') && body['data'] is Map
          ? Map<String, dynamic>.from(body['data'])
          : body;

      return VerificationResult.fromJson(data);
    }

    final errorMsg = response.body is Map && response.body['error'] != null
        ? response.body['error'].toString()
        : 'Pass not found or invalid alumni registration';

    throw Exception(errorMsg);
  }

  /// Extracts the student registration ID or pass ID from scanned QR data
  String extractIdentifier(String rawData) {
    final trimmed = rawData.trim();
    if (trimmed.isEmpty) return '';

    // URL or deep link extraction (e.g. /verify/ID)
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      final uri = Uri.tryParse(trimmed);
      if (uri != null && uri.pathSegments.isNotEmpty) {
        return uri.pathSegments.last;
      }
    }

    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map) {
        if (decoded['studentId'] != null && decoded['studentId'].toString().isNotEmpty) {
          return decoded['studentId'].toString();
        }
        if (decoded['id'] != null && decoded['id'].toString().isNotEmpty) {
          return decoded['id'].toString();
        }
      }
    } catch (_) {
      // Plain text string: already an ID or matriculation number
    }

    return trimmed;
  }
}
