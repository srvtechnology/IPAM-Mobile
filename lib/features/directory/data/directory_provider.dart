import 'package:get/get.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/alumni_model.dart';

class DirectoryProvider {
  ApiClient get _client =>
      Get.isRegistered<ApiClient>() ? Get.find<ApiClient>() : Get.put(ApiClient(), permanent: true);

  /// Fetches directory alumni list from GET /api/alumni with optional filters
  Future<List<AlumniModel>> fetchAlumni({
    String? query,
    int? classYear,
    String? industry,
    bool? isMentor,
    String? category,
    String? chapter,
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
        if (list.isNotEmpty) {
          return list
              .whereType<Map<String, dynamic>>()
              .map((e) => AlumniModel.fromJson(e))
              .toList();
        }
      }
    } catch (_) {
      // Fallback to sample data matching design references on offline/network failure
    }

    return _getSampleAlumni();
  }

  /// Fetches single public profile details from GET /api/alumni/{id}
  Future<AlumniModel?> getAlumniDetails(String id) async {
    try {
      final response = await _client.get(ApiEndpoints.alumniDetail(id));
      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};
        final data = body['data'] as Map<String, dynamic>? ?? body;
        return AlumniModel.fromJson(data);
      }
    } catch (_) {}
    return null;
  }

  /// Connects with an alumni member (POST /api/alumni/{id}/connect)
  Future<bool> connectAlumni(String alumniId) async {
    try {
      final response = await _client.post(
        ApiEndpoints.alumniConnect(alumniId),
        {},
      );
      if (response.isOk && response.body != null) {
        final body = response.body is Map ? response.body : {};
        final data = body['data'] is Map ? body['data'] : body;
        return data['connected'] == true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  /// Disconnects from an alumni member (DELETE /api/alumni/{id}/connect)
  Future<bool> disconnectAlumni(String alumniId) async {
    try {
      final response = await _client.delete(
        ApiEndpoints.alumniConnect(alumniId),
      );
      if (response.isOk && response.body != null) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches saved network bookmarks / connections (GET /api/alumni/bookmarks)
  Future<List<AlumniModel>> fetchBookmarks() async {
    try {
      final response = await _client.get(ApiEndpoints.alumniBookmarks);
      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};
        final list = (body['data'] as List<dynamic>? ?? []);
        return list
            .whereType<Map<String, dynamic>>()
            .map((item) => AlumniModel.fromJson(item['alumni'] is Map ? item['alumni'] : item))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  List<AlumniModel> _getSampleAlumni() {
    return [
      AlumniModel.defaultAminata(),
      AlumniModel(
        id: '2',
        name: 'David Okoro',
        role: 'VP Outreach • Lead Consultant',
        faculty: 'Faculty of Information Systems & Technology',
        graduationYear: 2010,
        location: 'London & UK',
        badge: 'Executive Council Leader',
        isExecutiveLeader: true,
        isMentor: false,
        isVerified: true,
        category: 'Executive Council',
        chapter: 'United Kingdom',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
        degree: 'B.Sc. Information Systems',
      ),
      AlumniModel(
        id: '3',
        name: 'Elena Rodriguez',
        role: 'Treasurer & Financial Director',
        faculty: 'Global Banking & Capital Markets',
        graduationYear: 2012,
        location: 'London & West Africa',
        badge: 'Executive Council Leader',
        isExecutiveLeader: true,
        isMentor: false,
        isVerified: true,
        category: 'Finance & Accounting',
        chapter: 'United Kingdom',
        avatarUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&w=300&q=80',
        degree: 'M.Sc. Banking & Finance',
      ),
      AlumniModel(
        id: '4',
        name: 'Fatima Sesay',
        role: 'Senior Data Analyst, AfDB',
        faculty: 'Development Economics & Analytics',
        graduationYear: 2019,
        location: 'Nairobi & West Africa',
        badge: 'Active Mentor',
        isExecutiveLeader: false,
        isMentor: true,
        isVerified: true,
        category: 'Finance & Accounting',
        chapter: 'West Africa',
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
        degree: 'B.Sc. Economics & Analytics',
      ),
      AlumniModel(
        id: '5',
        name: 'Dr. Mohamed S. Bangura',
        role: 'Director of Operations & Governance',
        faculty: 'Faculty of Public Administration and Management',
        graduationYear: 2015,
        location: 'Tower Hill Campus',
        badge: 'Executive Council Leader',
        isExecutiveLeader: true,
        isMentor: false,
        isVerified: true,
        category: 'Public Admin',
        chapter: 'Sierra Leone',
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80',
        degree: 'D.P.A. Public Administration',
      ),
    ];
  }
}
