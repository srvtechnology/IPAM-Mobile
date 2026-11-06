import 'package:get/get.dart';
import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/auth_storage_service.dart';
import '../models/event_models.dart';

class EventService {
  final ApiClient _client;

  EventService({ApiClient? client})
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

  /// Lists all published public events (GET /api/events)
  Future<List<EventItem>> fetchEvents() async {
    try {
      final response = await _client.get(ApiEndpoints.events);

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final list = (body['data'] as List<dynamic>? ?? []);
        return list
            .whereType<Map<String, dynamic>>()
            .map((e) => EventItem.fromJson(e))
            .toList();
      }

      final errorMsg = response.body is Map && response.body['error'] != null
          ? response.body['error'].toString()
          : (response.statusText?.isNotEmpty == true
              ? response.statusText!
              : 'Failed to load events (${response.statusCode})');

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to load events: $e');
    }
  }

  /// Retrieves single event details (GET /api/events/{id})
  Future<EventItem> getEventDetails(String id) async {
    try {
      final response = await _client.get(ApiEndpoints.eventDetail(id));

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final data = body['data'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(body['data'])
            : body;

        return EventItem.fromJson(data);
      }

      final errorMsg = response.body is Map && response.body['error'] != null
          ? response.body['error'].toString()
          : (response.statusText?.isNotEmpty == true
              ? response.statusText!
              : 'Failed to retrieve event details (${response.statusCode})');

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to load event details: $e');
    }
  }

  /// Books tickets for an event (POST /api/events/{id}/register)
  Future<EventBooking> registerForEvent(
    String eventId, {
    int ticketCount = 1,
    String? attendeeName,
    String? attendeeEmail,
    String? attendeePhone,
    String? notes,
    String paymentMethod = 'FREE',
  }) async {
    final user = _authStorage.user;
    final name = attendeeName ?? user?.fullName ?? 'IPAM Alumni Member';
    final email = attendeeEmail ?? user?.email ?? 'alumni@ipam.edu.sl';
    final phone = attendeePhone ?? user?.phone ?? '+232 76 000000';

    final payload = {
      'ticketCount': ticketCount,
      'attendeeName': name,
      'attendeeEmail': email,
      'attendeePhone': phone,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
      'paymentMethod': paymentMethod,
    };

    try {
      final response = await _client.post(
        ApiEndpoints.eventRegister(eventId),
        payload,
      );

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final data = body['data'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(body['data'])
            : body;

        return EventBooking.fromJson(data);
      }

      final errorMsg = response.body is Map && response.body['error'] != null
          ? response.body['error'].toString()
          : (response.statusText?.isNotEmpty == true
              ? response.statusText!
              : 'Registration failed (${response.statusCode})');

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Registration failed: $e');
    }
  }

  /// Retrieves booked tickets for current authenticated member (GET /api/events/my-registrations)
  Future<List<EventBooking>> fetchMyRegistrations() async {
    try {
      final response = await _client.get(ApiEndpoints.myEventRegistrations);

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final list = (body['data'] as List<dynamic>? ?? []);
        return list
            .whereType<Map<String, dynamic>>()
            .map((b) => EventBooking.fromJson(b))
            .toList();
      }

      final errorMsg = response.body is Map && response.body['error'] != null
          ? response.body['error'].toString()
          : (response.statusText?.isNotEmpty == true
              ? response.statusText!
              : 'Failed to load bookings (${response.statusCode})');

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to fetch bookings: $e');
    }
  }

  /// Retrieves single registration by booking reference (GET /api/events/my-registrations/{bookingRef})
  Future<EventBooking> getRegistration(String bookingRef) async {
    try {
      final response = await _client.get(ApiEndpoints.myEventRegistrationDetail(bookingRef));

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        final data = body['data'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(body['data'])
            : body;

        return EventBooking.fromJson(data);
      }

      final errorMsg = response.body is Map && response.body['error'] != null
          ? response.body['error'].toString()
          : 'Failed to retrieve booking ($bookingRef)';

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to load booking: $e');
    }
  }

  /// Cancels an existing event registration (DELETE /api/events/my-registrations/{bookingRef})
  Future<void> cancelRegistration(String bookingRef) async {
    try {
      final response = await _client.delete(ApiEndpoints.myEventRegistrationDetail(bookingRef));

      if (response.isOk) {
        return;
      }

      final errorMsg = response.body is Map && response.body['error'] != null
          ? response.body['error'].toString()
          : (response.statusText?.isNotEmpty == true
              ? response.statusText!
              : 'Failed to cancel registration (${response.statusCode})');

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Cancellation error: $e');
    }
  }

  /// Submits an event proposal to the USL Directorate (POST /api/event-proposals)
  Future<Map<String, dynamic>> submitProposal(EventProposal proposal) async {
    try {
      final response = await _client.post(
        ApiEndpoints.eventProposals,
        proposal.toJson(),
      );

      if (response.isOk && response.body != null) {
        final body = response.body is Map
            ? Map<String, dynamic>.from(response.body)
            : <String, dynamic>{};

        return body['data'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(body['data'])
            : body;
      }

      final errorMsg = response.body is Map && response.body['error'] != null
          ? response.body['error'].toString()
          : (response.statusText?.isNotEmpty == true
              ? response.statusText!
              : 'Proposal submission failed (${response.statusCode})');

      throw Exception(errorMsg);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to submit proposal: $e');
    }
  }
}
