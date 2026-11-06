import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/core/network/api_client.dart';
import 'package:ipam_mobile/models/event_models.dart';
import 'package:ipam_mobile/services/event_service.dart';

class _MockEventApiClient extends ApiClient {
  _MockEventApiClient();

  @override
  Future<Response<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) async {
    if (url == '/api/events') {
      return Response<T>(
        statusCode: 200,
        body: {
          'data': [
            {
              'id': 'seed-event-6',
              'title': 'IPAM Mentorship Network Orientation',
              'slug': 'ipam-mentorship-orientation-2026',
              'category': 'CAREER_WORKSHOP',
              'date': '2026-10-18T14:00:00.000Z',
              'location': 'IPAM Main Auditorium, Freetown',
              'bannerImage': '/uploads/events/mentorship.jpg',
              'description': 'Annual launch of the university-wide alumni mentorship circle.',
              'capacity': 250,
              'registeredCount': 84,
              'isFree': true,
              'ticketPrice': 0,
              'status': 'UPCOMING',
              'speakers': [
                {'name': 'Mariama Jalloh', 'title': 'Director of Operations'}
              ],
            },
            {
              'id': 'seed-event-3',
              'title': 'Freetown Young Alumni Networking Mixer',
              'category': 'NETWORKING',
              'date': '2026-11-06T18:30:00.000Z',
              'location': 'Lumley Beach Pavilion, Freetown',
              'bannerImage': '/images/alumni_networking_mixer.jpg',
              'description': 'Casual evening mixer connecting recent graduates.',
              'capacity': 80,
              'registeredCount': 2,
              'isPaid': true,
              'ticketPrice': '15',
              'featured': true,
              'status': 'PUBLISHED',
            }
          ]
        } as T,
      );
    }

    if (url == '/api/events/seed-event-6') {
      return Response<T>(
        statusCode: 200,
        body: {
          'data': {
            'id': 'seed-event-6',
            'title': 'IPAM Mentorship Network Orientation',
            'date': '2026-10-18T14:00:00.000Z',
            'location': 'IPAM Main Auditorium, Freetown',
            'description': 'Annual launch of the university-wide alumni mentorship circle.',
            'capacity': 250,
            'registeredCount': 84,
            'availableSeats': 166,
            'isFree': true,
            'ticketPrice': 0,
            'registered': true,
          }
        } as T,
      );
    }

    if (url == '/api/events/my-registrations') {
      return Response<T>(
        statusCode: 200,
        body: {
          'data': [
            {
              'id': 'cmv19901',
              'bookingReference': 'BK-EVT-MV9ANUCY-Z8KF',
              'ticketCount': 1,
              'bookingStatus': 'CONFIRMED',
              'registeredAt': '2026-10-26T11:22:00.000Z',
              'event': {
                'id': 'seed-event-6',
                'title': 'IPAM Mentorship Network Orientation',
                'date': '2026-10-18T14:00:00.000Z',
                'location': 'IPAM Main Auditorium, Freetown',
                'bannerImage': '/uploads/events/mentorship.jpg',
              }
            }
          ]
        } as T,
      );
    }

    if (url == '/api/events/my-registrations/BK-EVT-MV9ANUCY-Z8KF') {
      return Response<T>(
        statusCode: 200,
        body: {
          'data': {
            'id': 'cmv19901',
            'bookingReference': 'BK-EVT-MV9ANUCY-Z8KF',
            'ticketCount': 1,
            'bookingStatus': 'CONFIRMED',
            'registeredAt': '2026-10-26T11:22:00.000Z',
            'event': {
              'id': 'seed-event-6',
              'title': 'IPAM Mentorship Network Orientation',
              'date': '2026-10-18T14:00:00.000Z',
              'location': 'IPAM Main Auditorium, Freetown',
            }
          }
        } as T,
      );
    }

    return Response<T>(statusCode: 404, statusText: 'Not found');
  }

  @override
  Future<Response<T>> post<T>(
    String? url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    Progress? uploadProgress,
  }) async {
    if (url == '/api/events/seed-event-6/register') {
      return Response<T>(
        statusCode: 201,
        body: {
          'data': {
            'id': 'cmv19988',
            'bookingReference': 'BK-EVT-MV9ANUCY-Z8KF',
            'eventId': 'seed-event-6',
            'ticketCount': 1,
            'totalAmount': 0,
            'bookingStatus': 'CONFIRMED',
            'registeredAt': '2026-10-26T11:22:00.000Z',
          }
        } as T,
      );
    }

    if (url == '/api/event-proposals') {
      return Response<T>(
        statusCode: 201,
        body: {
          'data': {
            'id': 'prop-100',
            'title': body['title'],
            'status': 'PENDING_REVIEW',
            'organizerEmail': body['organizerEmail'],
          }
        } as T,
      );
    }

    return Response<T>(statusCode: 400, body: {'error': 'Bad request'} as T);
  }

  @override
  Future<Response<T>> delete<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) async {
    if (url == '/api/events/my-registrations/BK-EVT-MV9ANUCY-Z8KF') {
      return Response<T>(
        statusCode: 200,
        body: {
          'data': {
            'message': 'Registration cancelled successfully',
            'bookingReference': 'BK-EVT-MV9ANUCY-Z8KF'
          }
        } as T,
      );
    }

    if (url.contains('PAST-EVENT')) {
      return Response<T>(
        statusCode: 400,
        body: {'error': 'Cannot cancel registration for a past event'} as T,
      );
    }

    return Response<T>(statusCode: 404, statusText: 'Not found');
  }
}

void main() {
  setUp(() {
    Get.reset();
  });

  group('Event Models & Data Parsing Tests', () {
    test('EventItem correctly parses API response from doc specification', () {
      final json = {
        'id': 'seed-event-6',
        'title': 'IPAM Mentorship Network Orientation',
        'slug': 'ipam-mentorship-orientation-2026',
        'category': 'CAREER_WORKSHOP',
        'date': '2026-10-18T14:00:00.000Z',
        'location': 'IPAM Main Auditorium, Freetown',
        'bannerImage': '/uploads/events/mentorship.jpg',
        'description': 'Annual launch of the university-wide alumni mentorship circle.',
        'capacity': 250,
        'registeredCount': 84,
        'availableSeats': 166,
        'isFree': true,
        'ticketPrice': 0,
        'status': 'UPCOMING',
        'registered': false,
      };

      final event = EventItem.fromJson(json);

      expect(event.id, 'seed-event-6');
      expect(event.title, 'IPAM Mentorship Network Orientation');
      expect(event.category, 'CAREER_WORKSHOP');
      expect(event.capacity, 250);
      expect(event.registeredCount, 84);
      expect(event.remainingSeats, 166);
      expect(event.isFree, isTrue);
      expect(event.dateMonth, 'OCT');
      expect(event.dateDay, '18');
      expect(event.priceFormatted, 'Free Admission');

      // Bridge to EventModel
      final eventModel = event.toEventModel();
      expect(eventModel.id, 'seed-event-6');
      expect(eventModel.title, 'IPAM Mentorship Network Orientation');
      expect(eventModel.seatsRemaining, 166);
      expect(eventModel.isFree, isTrue);
    });

    test('EventItem correctly parses paid event with string price and converts to EventModel', () {
      final json = {
        'id': 'seed-event-3',
        'title': 'Freetown Young Alumni Networking Mixer',
        'date': '2026-11-06T18:30:00.000Z',
        'location': 'Lumley Beach Pavilion, Freetown',
        'venueDetails': 'Sunset Deck, Lumley Beach Road',
        'category': 'NETWORKING',
        'bannerImage': '/images/alumni_networking_mixer.jpg',
        'description': 'Casual evening mixer connecting recent graduates.',
        'isPaid': true,
        'ticketPrice': '15',
        'currency': 'USD',
        'capacity': 80,
        'registeredCount': 2,
        'featured': true,
      };

      final event = EventItem.fromJson(json);

      expect(event.id, 'seed-event-3');
      expect(event.isFree, isFalse);
      expect(event.ticketPrice, 15.0);
      expect(event.priceFormatted, contains(r'$15 USD'));
      expect(event.remainingSeats, 78);
      expect(event.dateMonth, 'NOV');
      expect(event.dateDay, '06');

      final eventModel = event.toEventModel();
      expect(eventModel.isFeatured, isTrue);
      expect(eventModel.featuredTag, 'FEATURED FLAGSHIP EVENT');
      expect(eventModel.venueType, 'Sunset Deck, Lumley Beach Road');
    });

    test('EventBooking correctly parses booking confirmation payload', () {
      final json = {
        'id': 'cmv19901',
        'bookingReference': 'BK-EVT-MV9ANUCY-Z8KF',
        'eventId': 'seed-event-6',
        'ticketCount': 1,
        'totalAmount': 0,
        'bookingStatus': 'CONFIRMED',
        'registeredAt': '2026-10-26T11:22:00.000Z',
        'event': {
          'id': 'seed-event-6',
          'title': 'IPAM Mentorship Network Orientation',
          'date': '2026-10-18T14:00:00.000Z',
          'location': 'IPAM Main Auditorium, Freetown',
        }
      };

      final booking = EventBooking.fromJson(json);

      expect(booking.id, 'cmv19901');
      expect(booking.bookingReference, 'BK-EVT-MV9ANUCY-Z8KF');
      expect(booking.bookingStatus, 'CONFIRMED');
      expect(booking.ticketCount, 1);
      expect(booking.event.id, 'seed-event-6');

      final model = booking.toEventModel();
      expect(model.ticketCode, 'BK-EVT-MV9ANUCY-Z8KF');
      expect(model.isRsvp, isTrue);
    });

    test('EventProposal correctly serializes to JSON for proposal submission', () {
      const proposal = EventProposal(
        title: 'IPAM Tech Alumni Hackathon 2026',
        category: 'CAREER_WORKSHOP',
        format: 'HYBRID',
        location: 'IPAM Innovation Hub, Freetown',
        description: 'A 2-day hackathon building Flutter mobile apps.',
        organizerEmail: 'demo.alumni@ipam.edu',
      );

      final map = proposal.toJson();

      expect(map['title'], 'IPAM Tech Alumni Hackathon 2026');
      expect(map['category'], 'CAREER_WORKSHOP');
      expect(map['format'], 'HYBRID');
      expect(map['organizerEmail'], 'demo.alumni@ipam.edu');
    });
  });

  group('EventService API Integration Tests', () {
    late EventService service;

    setUp(() {
      final mockClient = _MockEventApiClient();
      service = EventService(client: mockClient);
    });

    test('fetchEvents retrieves list of published events from GET /api/events', () async {
      final events = await service.fetchEvents();

      expect(events.length, 2);
      expect(events.first.id, 'seed-event-6');
      expect(events.first.title, 'IPAM Mentorship Network Orientation');
      expect(events.first.speakers.length, 1);
      expect(events.first.speakers.first.name, 'Mariama Jalloh');
      expect(events.last.id, 'seed-event-3');
      expect(events.last.featured, isTrue);
    });

    test('getEventDetails retrieves single event by ID from GET /api/events/{id}', () async {
      final event = await service.getEventDetails('seed-event-6');

      expect(event.id, 'seed-event-6');
      expect(event.title, 'IPAM Mentorship Network Orientation');
      expect(event.registered, isTrue);
      expect(event.availableSeats, 166);
    });

    test('registerForEvent successfully books ticket via POST /api/events/{id}/register', () async {
      final booking = await service.registerForEvent(
        'seed-event-6',
        ticketCount: 1,
        attendeeName: 'Alex Sesay',
        attendeeEmail: 'demo.alumni@ipam.edu',
        notes: 'Preferred seating',
      );

      expect(booking.bookingReference, 'BK-EVT-MV9ANUCY-Z8KF');
      expect(booking.bookingStatus, 'CONFIRMED');
      expect(booking.eventId, 'seed-event-6');
    });

    test('fetchMyRegistrations returns booked tickets from GET /api/events/my-registrations', () async {
      final bookings = await service.fetchMyRegistrations();

      expect(bookings.length, 1);
      expect(bookings.first.bookingReference, 'BK-EVT-MV9ANUCY-Z8KF');
      expect(bookings.first.event.title, 'IPAM Mentorship Network Orientation');
    });

    test('getRegistration fetches single booking by reference', () async {
      final booking = await service.getRegistration('BK-EVT-MV9ANUCY-Z8KF');

      expect(booking.bookingReference, 'BK-EVT-MV9ANUCY-Z8KF');
      expect(booking.ticketCount, 1);
    });

    test('cancelRegistration successfully cancels booking via DELETE', () async {
      // Should complete without error
      await service.cancelRegistration('BK-EVT-MV9ANUCY-Z8KF');
    });

    test('cancelRegistration throws friendly error when cancelling past event', () async {
      expect(
        () => service.cancelRegistration('PAST-EVENT-001'),
        throwsA(predicate((e) => e.toString().contains('Cannot cancel registration for a past event'))),
      );
    });

    test('submitProposal sends event proposal to POST /api/event-proposals', () async {
      const proposal = EventProposal(
        title: 'Diaspora Banking Summit',
        category: 'FINANCE',
        format: 'IN_PERSON',
        location: 'London',
        description: 'Meeting of financial professionals',
        organizerEmail: 'alumni@ipam.edu.sl',
      );

      final result = await service.submitProposal(proposal);

      expect(result['id'], 'prop-100');
      expect(result['status'], 'PENDING_REVIEW');
    });

    test('toEventModel produces dynamic admission tiers matching paid ticketPrice', () {
      final paidItem = EventItem(
        id: 'seed-event-3',
        title: 'Freetown Young Alumni Networking Mixer',
        category: 'NETWORKING',
        date: DateTime(2026, 11, 6, 18, 30),
        location: 'Lumley Beach Pavilion, Freetown',
        description: 'Casual evening mixer connecting recent graduates.',
        capacity: 80,
        registeredCount: 3,
        isFree: false,
        ticketPrice: 15.0,
      );

      final eventModel = paidItem.toEventModel();

      expect(eventModel.price, '\$15 USD / NLe 352');
      expect(eventModel.admissionTiers.length, 2);

      final standardTier = eventModel.admissionTiers.firstWhere((t) => t.id == 'standard');
      expect(standardTier.priceUsd, 15.0);
      expect(standardTier.priceNle, 352);
      expect(standardTier.name, 'Standard Alumni Pass');

      final patronTier = eventModel.admissionTiers.firstWhere((t) => t.id == 'patron');
      expect(patronTier.priceUsd, 50.0);
      expect(patronTier.priceNle, 1200);
      expect(patronTier.name, 'Patron Sponsor Pass');
    });

    test('toEventModel produces dynamic complimentary admission tiers for free events', () {
      final freeItem = EventItem(
        id: 'seed-event-6',
        title: 'IPAM Mentorship Network Orientation',
        category: 'CAREER_WORKSHOP',
        date: DateTime(2026, 10, 18, 14, 0),
        location: 'IPAM Main Auditorium, Freetown',
        description: 'Annual launch of alumni mentorship circle.',
        capacity: 250,
        registeredCount: 84,
        isFree: true,
        ticketPrice: 0.0,
      );

      final eventModel = freeItem.toEventModel();

      expect(eventModel.price, 'Free Admission');
      final standardTier = eventModel.admissionTiers.firstWhere((t) => t.id == 'standard');
      expect(standardTier.priceUsd, 0.0);
      expect(standardTier.priceNle, 0);
    });
  });
}
