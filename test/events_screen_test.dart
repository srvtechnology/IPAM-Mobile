import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/features/events/controllers/events_controller.dart';
import 'package:ipam_mobile/features/events/screens/events_screen.dart';

// 1x1 transparent png for testing NetworkImage without network calls
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
    return _createMockHttpClient();
  }
}

HttpClient _createMockHttpClient() {
  final client = _MockHttpClient();
  return client;
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
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();
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

class _MockHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
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
    return Stream<List<int>>.fromIterable([_transparentImage]).listen(
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

  group('EventsController Tests', () {
    late EventsController controller;

    setUp(() {
      Get.testMode = true;
      Get.reset();
      controller = Get.put(EventsController());
    });

    tearDown(() {
      Get.reset();
    });

    test('Initializes with 5 total events, 1 flagship, and 2 confirmed tickets', () {
      expect(controller.upcomingEventsCount, 5);
      expect(controller.flagshipEvent, isNotNull);
      expect(controller.flagshipEvent!.title, 'Freetown Young Alumni Networking Mixer');
      expect(controller.flagshipEvent!.isFeatured, isTrue);
      expect(controller.myTicketsCount, 2);
    });

    test('Filtering by category (Virtual / Webinars) filters gatherings properly', () {
      controller.selectCategory('Virtual / Webinars');
      final filtered = controller.upcomingGatherings;
      expect(filtered.isNotEmpty, isTrue);
      expect(filtered.every((e) => e.category == 'Virtual / Webinars'), isTrue);
    });

    test('Filtering by chapter filters gatherings', () {
      controller.selectChapter('UK & European Diaspora');
      final filtered = controller.upcomingGatherings;
      expect(filtered.length, 1);
      expect(filtered.first.title, 'London & Diaspora Chapter Winter Reception');
    });

    test('Toggling RSVP adds/removes pass in My Tickets', () async {
      final flagship = controller.flagshipEvent!;
      expect(flagship.isRsvp, isFalse);

      await controller.toggleRsvp(flagship);
      expect(controller.myTicketsCount, 3);
      expect(controller.flagshipEvent!.isRsvp, isTrue);

      await controller.toggleRsvp(controller.flagshipEvent!);
      expect(controller.myTicketsCount, 2);
      expect(controller.flagshipEvent!.isRsvp, isFalse);
    });

    test('Toggling bookmark toggles event bookmark state', () {
      final flagship = controller.flagshipEvent!;
      final initialBookmark = flagship.isBookmarked;

      controller.toggleBookmark(flagship);
      expect(controller.flagshipEvent!.isBookmarked, !initialBookmark);

      controller.toggleBookmark(controller.flagshipEvent!);
      expect(controller.flagshipEvent!.isBookmarked, initialBookmark);
    });

    test('Switching subtabs updates activeTab observable', () {
      expect(controller.activeTab.value, 'Upcoming Events');
      controller.switchTab('My Tickets');
      expect(controller.activeTab.value, 'My Tickets');
      controller.switchTab('Upcoming Events');
      expect(controller.activeTab.value, 'Upcoming Events');
    });
  });

  group('EventsScreen Widget Tests', () {
    setUp(() {
      Get.testMode = true;
      Get.reset();
      Get.put(EventsController());
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('Renders Alumni Gatherings & Summits UI components cleanly', (tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: EventsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Header
      expect(find.text('Alumni Gatherings & Summits'), findsOneWidget);
      expect(find.text('USL CONVOCATION & EVENTS'), findsOneWidget);
      expect(find.text('• Global Directorate'), findsOneWidget);

      // Verify Stats Pills
      expect(find.text('3 Upcoming'), findsOneWidget);
      expect(find.text('12 Chapters'), findsOneWidget);
      expect(find.text('Free & Paid Passes'), findsOneWidget);

      // Verify Subtabs
      expect(find.text('Upcoming Events (5)'), findsOneWidget);
      expect(find.text('My Tickets (2)'), findsOneWidget);
      expect(find.text('New'), findsOneWidget);

      // Verify Flagship Event Card
      expect(find.text('Freetown Young Alumni Networking Mixer'), findsOneWidget);
      expect(find.text('FEATURED FLAGSHIP EVENT'), findsOneWidget);
      expect(find.text('142 Alumni Registered'), findsOneWidget);
      expect(find.text('Pass Open'), findsOneWidget);
      expect(find.text(r'$15 USD / NLe 350'), findsOneWidget);

      // Verify Upcoming Gathering Card 1
      expect(find.text('Upcoming Gatherings'), findsOneWidget);
      expect(find.text('Career Growth & Global Mobility Webinar'), findsOneWidget);
      expect(find.text('Free • Virtual'), findsOneWidget);
      expect(find.text('Free Admission'), findsWidgets);

      // Verify Chapter Organizers Banner
      expect(find.text('Hosting a Regional Chapter Meetup?'), findsOneWidget);
      expect(find.text('Submit Event Proposal'), findsOneWidget);
    });

    testWidgets('Tapping My Tickets tab renders digital passes', (tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: EventsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on My Tickets subtab
      await tester.tap(find.text('My Tickets (2)'));
      await tester.pumpAndSettle();

      // Verify ticket passes
      expect(find.text('My Confirmed Passes'), findsOneWidget);
      expect(find.text('VERIFIED ALUMNI PASS'), findsWidgets);
      expect(find.text('Save Digital Pass'), findsWidgets);
    });
  });
}
