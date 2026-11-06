import 'package:get/get.dart';
import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../models/job_models.dart';

/// Service repository handling all Jobs & Careers API communications (04-jobs-and-careers.md)
class JobService {
  final ApiClient _client;

  JobService({ApiClient? client})
      : _client = client ??
            (Get.isRegistered<ApiClient>()
                ? Get.find<ApiClient>()
                : Get.put(ApiClient(), permanent: true));

  /// Lists and filters job openings (GET /api/jobs)
  Future<List<JobOpening>> fetchJobs({
    String? query,
    String? category,
    String? type,
    String? workplaceType,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (query != null && query.isNotEmpty) queryParams['q'] = query;
      if (category != null && category.isNotEmpty && category != 'All' && category != 'All Roles') {
        queryParams['category'] = category;
      }
      if (type != null && type.isNotEmpty) queryParams['type'] = type;
      if (workplaceType != null && workplaceType.isNotEmpty) queryParams['workplaceType'] = workplaceType;

      final response = await _client.get(
        ApiEndpoints.jobs,
        query: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final list = (body['data'] as List<dynamic>? ?? []);
        return list
            .whereType<Map>()
            .map((e) => JobOpening.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      final errorMsg = response.body is Map && response.body['error'] != null
          ? response.body['error'].toString()
          : (response.statusText?.isNotEmpty == true
              ? response.statusText!
              : 'Failed to load jobs (${response.statusCode})');

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to load jobs: $e');
    }
  }

  /// Retrieves single job opening details (GET /api/jobs/{id})
  Future<JobOpening> getJobDetails(String id) async {
    try {
      final response = await _client.get(ApiEndpoints.jobDetail(id));

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final data = body['data'] is Map ? Map<String, dynamic>.from(body['data']) : body;
        return JobOpening.fromJson(data);
      }

      final errorMsg = response.body is Map && response.body['error'] != null
          ? response.body['error'].toString()
          : (response.statusText?.isNotEmpty == true
              ? response.statusText!
              : 'Failed to fetch job details (${response.statusCode})');

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to fetch job details: $e');
    }
  }

  /// Submits an application for a job opening (POST /api/jobs/{id}/apply)
  Future<JobApplicationResponse?> applyForJob(
    String jobId, {
    required String candidateName,
    required String email,
    String? phone,
    String? degree,
    String? faculty,
    int? gradYear,
    int? experienceYears,
    List<String>? skills,
    String? linkedinUrl,
    String? coverNote,
    String? cvUrl,
    String? cvFileName,
  }) async {
    try {
      final payload = <String, dynamic>{
        'candidateName': candidateName,
        'email': email,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        if (degree != null && degree.isNotEmpty) 'degree': degree,
        if (faculty != null && faculty.isNotEmpty) 'faculty': faculty,
        'gradYear': ?gradYear,
        'experienceYears': ?experienceYears,
        if (skills != null && skills.isNotEmpty) 'skills': skills,
        if (linkedinUrl != null && linkedinUrl.isNotEmpty) 'linkedinUrl': linkedinUrl,
        if (coverNote != null && coverNote.isNotEmpty) 'coverNote': coverNote,
        if (cvUrl != null && cvUrl.isNotEmpty) 'cvUrl': cvUrl,
        if (cvFileName != null && cvFileName.isNotEmpty) 'cvFileName': cvFileName,
      };

      final response = await _client.post(ApiEndpoints.jobApply(jobId), payload);

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final data = body['data'] is Map ? Map<String, dynamic>.from(body['data']) : body;
        final appData = data['application'] is Map
            ? Map<String, dynamic>.from(data['application'])
            : data;

        return JobApplicationResponse.fromJson(appData);
      }

      final errorMsg = response.body is Map && response.body['error'] != null
          ? response.body['error'].toString()
          : (response.statusText?.isNotEmpty == true
              ? response.statusText!
              : 'Application submission failed (${response.statusCode})');

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Application submission failed: $e');
    }
  }

  /// Toggles saving/bookmarking a job opening (POST /api/jobs/{id}/save)
  Future<bool> toggleSaveJob(String jobId) async {
    try {
      final response = await _client.post(ApiEndpoints.jobSave(jobId), {});

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final data = body['data'] is Map ? Map<String, dynamic>.from(body['data']) : body;
        return data['saved'] == true || data['isSaved'] == true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  /// Retrieves user's saved/bookmarked jobs (GET /api/jobs/saved)
  Future<List<JobOpening>> fetchSavedJobs() async {
    try {
      final response = await _client.get(ApiEndpoints.savedJobs);

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final list = (body['data'] as List<dynamic>? ?? []);
        return list.whereType<Map>().map((e) {
          final map = Map<String, dynamic>.from(e);
          final jobData = map['job'] is Map
              ? Map<String, dynamic>.from(map['job'] as Map)
              : map;
          jobData['saved'] = true;
          jobData['isSaved'] = true;
          return JobOpening.fromJson(jobData);
        }).toList();
      }

      return [];
    } catch (_) {
      return [];
    }
  }

  /// Retrieves user's submitted job applications (GET /api/jobs/my-applications)
  Future<List<JobApplicationItem>> fetchMyApplications() async {
    try {
      final response = await _client.get(ApiEndpoints.myJobApplications);

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final data = body['data'] is Map ? Map<String, dynamic>.from(body['data']) : body;
        final list = (data['applications'] as List<dynamic>? ?? []);

        return list
            .whereType<Map>()
            .map((e) => JobApplicationItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      return [];
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to load applications: $e');
    }
  }

  /// Creates a new verified vacancy by alumni (POST /api/jobs)
  /// Creates a new verified vacancy by alumni (POST /api/jobs)
  Future<JobOpening?> postJobVacancy({
    required String title,
    required String company,
    required String location,
    required String salary,
    required String category,
    required String description,
    String type = 'FULL_TIME',
    String workplaceType = 'HYBRID',
    List<String>? requirements,
    String? deadline,
  }) async {
    try {
      // Map category to exact server enum: ENGINEERING, DATA_AI, FINANCE_BANKING, OPERATIONS, PRODUCT_DESIGN, LEGAL_PUBLIC_POLICY
      String apiCategory = 'ENGINEERING';
      final cat = category.toUpperCase().replaceAll('&', '_').replaceAll(' ', '_');
      if (cat.contains('DATA') || cat.contains('AI')) {
        apiCategory = 'DATA_AI';
      } else if (cat.contains('FINANCE') || cat.contains('BANK')) {
        apiCategory = 'FINANCE_BANKING';
      } else if (cat.contains('LEGAL') || cat.contains('POLICY') || cat.contains('PUBLIC')) {
        apiCategory = 'LEGAL_PUBLIC_POLICY';
      } else if (cat.contains('PRODUCT') || cat.contains('DESIGN')) {
        apiCategory = 'PRODUCT_DESIGN';
      } else if (cat.contains('OPERAT') || cat.contains('RISK') || cat.contains('GOVERN')) {
        apiCategory = 'OPERATIONS';
      } else {
        apiCategory = 'ENGINEERING';
      }

      // Map type to exact server enum: FULL_TIME, PART_TIME, CONTRACT, REMOTE
      String apiType = 'FULL_TIME';
      final t = type.toUpperCase().replaceAll('-', '_').replaceAll(' ', '_');
      if (t.contains('PART')) {
        apiType = 'PART_TIME';
      } else if (t.contains('CONTRACT')) {
        apiType = 'CONTRACT';
      } else if (t.contains('REMOTE')) {
        apiType = 'REMOTE';
      } else {
        apiType = 'FULL_TIME';
      }

      // Map workplaceType to exact server enum: REMOTE, HYBRID, ON_SITE
      String apiWorkplaceType = 'HYBRID';
      final w = workplaceType.toUpperCase().replaceAll('-', '_').replaceAll(' ', '_');
      if (w.contains('REMOTE')) {
        apiWorkplaceType = 'REMOTE';
      } else if (w.contains('ON') || w.contains('SITE') || w.contains('OFFICE')) {
        apiWorkplaceType = 'ON_SITE';
      } else {
        apiWorkplaceType = 'HYBRID';
      }

      final payload = <String, dynamic>{
        'title': title.trim(),
        'company': company.trim(),
        'location': location.trim().isNotEmpty ? location.trim() : 'Freetown, Sierra Leone',
        'salary': salary.trim().isNotEmpty ? salary.trim() : 'Competitive',
        'category': apiCategory,
        'description': description.trim().isNotEmpty ? description.trim() : 'Career opening on IPAM Alumni Career Network.',
        'type': apiType,
        'workplaceType': apiWorkplaceType,
        'requirements': requirements != null && requirements.isNotEmpty
            ? requirements
            : ['Relevant qualifications or equivalent practical experience'],
        if (deadline != null && deadline.isNotEmpty) 'deadline': deadline,
      };

      final response = await _client.post(ApiEndpoints.jobs, payload);

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final data = body['data'] is Map ? Map<String, dynamic>.from(body['data']) : body;
        return JobOpening.fromJson(data);
      }

      String errorMsg = 'Failed to post vacancy (${response.statusCode})';
      if (response.body is Map) {
        final bodyMap = response.body as Map;
        if (bodyMap['issues'] is Map && (bodyMap['issues']['fieldErrors'] is Map)) {
          final fieldErrors = bodyMap['issues']['fieldErrors'] as Map;
          final messages = <String>[];
          fieldErrors.forEach((key, val) {
            messages.add('$key: $val');
          });
          errorMsg = messages.join(', ');
        } else if (bodyMap['error'] != null) {
          errorMsg = bodyMap['error'].toString();
        }
      } else if (response.statusText?.isNotEmpty == true) {
        errorMsg = response.statusText!;
      }

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to post vacancy: $e');
    }
  }

  /// Updates job vacancy status (PATCH /api/jobs/{id})
  Future<bool> updateJobStatus(String jobId, String status) async {
    try {
      // Allowed server enum: ACTIVE, REVIEWING, SHORTLISTING, INTERVIEWING, OFFER_EXTENDED, CLOSED
      String apiStatus = 'ACTIVE';
      final upper = status.toUpperCase();
      if (upper == 'PAUSED') {
        apiStatus = 'REVIEWING';
      } else if (upper == 'FILLED' || upper == 'CLOSED') {
        apiStatus = 'CLOSED';
      } else {
        apiStatus = 'ACTIVE';
      }

      final response = await _client.patch('${ApiEndpoints.jobs}/$jobId', {
        'status': apiStatus,
      });

      return response.isOk;
    } catch (_) {
      return false;
    }
  }

  /// Deletes job vacancy (DELETE /api/jobs/{id})
  Future<bool> deleteJob(String jobId) async {
    try {
      final response = await _client.delete('${ApiEndpoints.jobs}/$jobId');
      return response.isOk;
    } catch (_) {
      return false;
    }
  }
}
