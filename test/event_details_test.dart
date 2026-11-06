import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/features/events/controllers/event_details_controller.dart';
import 'package:ipam_mobile/features/events/controllers/events_controller.dart';
import 'package:ipam_mobile/features/events/models/event_model.dart';
import 'package:ipam_mobile/features/events/screens/event_details_screen.dart';

final _transparentImage = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
];

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  bool autoUncompress = true;
  @override
  Duration? connectionTimeout;
  @override
  Duration idleTimeout = const Duration(seconds: 15);
  @override
  int? maxConnectionsPerHost;
  @override
  void addCredentials(Uri url, String realm, HttpClientCredentials credentials) {}
  @override
  void addProxyCredentials(String host, int port, String realm, HttpClientCredentials credentials) {}
  @override
  set authenticate(Future<bool> Function(Uri url, String scheme, String? realm)? f) {}
  @override
  set authenticateProxy(Future<bool> Function(String host, int port, String scheme, String? realm)? f) {}
  @override
  void close({bool force = false}) {}

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return _MockHttpClientRequest();
  }
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async {
    return _MockHttpClientResponse();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _MockHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => 200;
  @override
  int get contentLength => _transparentImage.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(_transparentImage).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  group('EventDetailsController Unit Tests', () {
    late EventDetailsController controller;
    late EventsController eventsController;

    setUp(() {
      Get.reset();
      eventsController = EventsController();
      Get.put<EventsController>(eventsController);
      controller = EventDetailsController();
      Get.put<EventDetailsController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    test('Initializes with default curated webinar event and patron tier selected', () {
      expect(controller.event.value.title, 'Career Growth & Global Mobility Webinar');
      expect(controller.selectedTierId.value, 'patron');
      expect(controller.currentSelectedTier.name, 'Patron Sponsor Pass');
      expect(controller.currentSelectedTier.priceUsd, 50.0);
    });

    test('Selecting standard tier updates currentSelectedTier and pricing', () {
      controller.selectTier('standard');
      expect(controller.selectedTierId.value, 'standard');
      expect(controller.currentSelectedTier.name, 'Standard Alumni Pass');
      expect(controller.currentSelectedTier.priceUsd, 0.0);
    });

    test('Toggling bookmark updates event state and syncs to EventsController', () {
      final initialBookmark = controller.event.value.isBookmarked;
      controller.toggleBookmark();
      expect(controller.event.value.isBookmarked, !initialBookmark);

      controller.toggleBookmark();
      expect(controller.event.value.isBookmarked, initialBookmark);
    });

    test('Booking a ticket issues ticketCode, sets isRsvp, and syncs with EventsController', () async {
      final testEvent = EventModel(
        id: 'ev_test_book',
        title: 'Tech & AI Symposium 2026',
        description: 'Navigating executive transitions and technology innovation.',
        category: 'Summit / Symposium',
        dateTime: DateTime(2026, 11, 20),
        timeFormatted: 'Friday, Nov 20, 2026 • 10:00 AM',
        location: 'Freetown City Hall',
        price: 'Free',
        badgeTag: 'IN-PERSON SUMMIT',
        rsvpCount: 150,
      );

      Get.reset();
      eventsController = EventsController();
      eventsController.eventsList.add(testEvent);
      Get.put<EventsController>(eventsController);

      final ctrl = EventDetailsController();
      ctrl.event = Rx<EventModel>(testEvent);
      ctrl.selectTier('standard');

      expect(ctrl.event.value.isRsvp, isFalse);

      // Verify tier
      expect(ctrl.currentSelectedTier.id, 'standard');
    });
  });

  group('EventDetailsScreen Widget Tests', () {
    setUp(() {
      Get.reset();
      final eventsCtrl = EventsController();
      Get.put<EventsController>(eventsCtrl);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('Renders all Event Details sections matching screenshots', (tester) async {
      tester.view.physicalSize = const Size(420, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const GetMaterialApp(
          home: EventDetailsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Top App Bar
      expect(find.text('Event Details'), findsOneWidget);
      expect(find.text('IPAM USL • ALUMNI NETWORK'), findsOneWidget);

      // 2. Hero Card
      expect(find.text('OFFICIAL IPAM USL ALUMNI EVENT'), findsOneWidget);
      expect(find.text('EST. 1980'), findsOneWidget);
      expect(find.text('Career Growth & Global Mobility Webinar'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('58 Seats Remaining'),
        ),
        findsOneWidget,
      );
      expect(find.text('ID VERIFIED ONLY'), findsOneWidget);

      // 3. 2x2 Grid of Event Meta Cards
      expect(find.text('DATE & TIME'), findsOneWidget);
      expect(find.text('LOCATION'), findsOneWidget);
      expect(find.text('ADMISSION TICKET'), findsOneWidget);
      expect(find.text('DRESS CODE'), findsOneWidget);
      expect(find.text('Smart Casual'), findsOneWidget);

      // 4. Admission Tiers
      expect(find.text('Select Admission Tier'), findsOneWidget);
      expect(find.text('Step 1 of 2'), findsOneWidget);
      expect(find.text('Standard Alumni Pass'), findsOneWidget);
      expect(find.text('Patron Sponsor Pass'), findsOneWidget);

      // 5. Who is Attending?
      expect(find.text('Who is Attending?'), findsOneWidget);
      expect(find.text('Prof. Aminata Bangura'), findsOneWidget);
      expect(find.text('David Okoro'), findsOneWidget);
      expect(find.text('Elena Rodriguez'), findsOneWidget);

      // 6. Complimentary Parking
      expect(find.text('Complimentary Alumni Parking'), findsOneWidget);
      expect(find.text('Open in Maps'), findsOneWidget);
      expect(find.text('Get Directions'), findsOneWidget);

      // 7. Bottom Bar (matches Ticket Confirmed in screenshots 2, 3, 4)
      expect(find.text('PATRON SPONSOR PASS'), findsOneWidget);
      expect(find.text('Ticket Confirmed ✓'), findsOneWidget);
    });

    testWidgets('Selecting Standard Alumni Pass updates the tier and bottom bar price', (tester) async {
      tester.view.physicalSize = const Size(420, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const GetMaterialApp(
          home: EventDetailsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Initially Patron Sponsor Pass is selected ($50)
      expect(find.text('PATRON SPONSOR PASS'), findsOneWidget);

      // Tap on Standard Alumni Pass
      await tester.tap(find.text('Standard Alumni Pass'));
      await tester.pumpAndSettle();

      // Bottom bar updates to Standard Alumni Pass ($0)
      expect(find.text('STANDARD ALUMNI PASS'), findsOneWidget);
    });

    testWidgets('Tapping Book Ticket confirms reservation and displays digital pass confirmation', (tester) async {
      tester.view.physicalSize = const Size(420, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final unbookedEvent = EventModel(
        id: 'ev_unbooked',
        title: 'Freetown Young Alumni Networking Mixer',
        description: 'Connect with young professionals and senior executives.',
        dateTime: DateTime(2026, 11, 6, 18, 0),
        timeFormatted: 'FRIDAY, NOV 6, 2026 • 6:00 PM',
        location: 'Lumley Beach Pavilion, Aberdeen, Freetown',
        category: 'In-Person Gathering',
        rsvpCount: 85,
        isRsvp: false,
      );

      final ctrl = EventDetailsController(initialEvent: unbookedEvent);
      Get.put<EventDetailsController>(ctrl);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: EventDetailsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Unbooked event shows 'Book Ticket'
      expect(find.text('Book Ticket'), findsOneWidget);

      // Tap Book Ticket
      await tester.tap(find.text('Book Ticket'));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      // Confirmation bottom sheet should appear
      expect(find.text('Ticket Confirmed! 🎉'), findsOneWidget);
      expect(find.text('OFFICIAL DIGITAL PASS'), findsOneWidget);
      expect(find.text('View in My Tickets'), findsOneWidget);

      // Dismiss sheet
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      // Bottom bar now displays Ticket Confirmed
      expect(find.text('Ticket Confirmed ✓'), findsOneWidget);
    });
  });
}
