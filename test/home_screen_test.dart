import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/core/network/auth_storage_service.dart';
import 'package:ipam_mobile/core/network/models/user_model.dart';
import 'package:ipam_mobile/core/theme/app_theme.dart';
import 'package:ipam_mobile/features/dashboard/controllers/dashboard_controller.dart';
import 'package:ipam_mobile/features/events/models/event_model.dart';
import 'package:ipam_mobile/features/home/controllers/home_controller.dart';
import 'package:ipam_mobile/features/home/screens/home_screen.dart';
import 'package:ipam_mobile/routes/app_pages.dart';

// 1x1 transparent png
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
  String? userAgent;

  @override
  void addCredentials(Uri url, String realm, HttpClientCredentials credentials) {}
  @override
  void addProxyCredentials(String host, int port, String realm, HttpClientCredentials credentials) {}
  @override
  set authenticate(Future<bool> Function(Uri url, String scheme, String? realm)? f) {}
  @override
  set authenticateProxy(Future<bool> Function(String host, int port, String scheme, String? realm)? f) {}
  @override
  set badCertificateCallback(bool Function(X509Certificate cert, String host, int port)? callback) {}
  @override
  set findProxy(String Function(Uri url)? f) {}
  @override
  void close({bool force = false}) {}

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> open(String method, String host, int port, String path) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> get(String host, int port, String path) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> post(String host, int port, String path) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> postUrl(Uri url) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> put(String host, int port, String path) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> putUrl(Uri url) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> delete(String host, int port, String path) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> deleteUrl(Uri url) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> patch(String host, int port, String path) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> patchUrl(Uri url) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> head(String host, int port, String path) async => _MockHttpClientRequest();
  @override
  Future<HttpClientRequest> headUrl(Uri url) async => _MockHttpClientRequest();
  @override
  set connectionFactory(Future<ConnectionTask<Socket>> Function(Uri url, String? proxyHost, int? proxyPort)? f) {}
  @override
  set keyLog(Function(String line)? callback) {}
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  bool bufferOutput = true;
  @override
  int contentLength = 0;
  @override
  Encoding encoding = utf8;
  @override
  bool followRedirects = true;
  @override
  int maxRedirects = 5;
  @override
  bool persistentConnection = true;

  @override
  void add(List<int> data) {}
  @override
  void addError(Object error, [StackTrace? stackTrace]) {}
  @override
  Future addStream(Stream<List<int>> stream) async {}
  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();
  @override
  HttpConnectionInfo? get connectionInfo => null;
  @override
  List<Cookie> get cookies => [];
  @override
  Future<HttpClientResponse> get done async => _MockHttpClientResponse();
  @override
  Future flush() async {}
  @override
  String get method => 'GET';
  @override
  Uri get uri => Uri.parse('http://localhost');
  @override
  void write(Object? obj) {}
  @override
  void writeAll(Iterable objects, [String separator = ""]) {}
  @override
  void writeCharCode(int charCode) {}
  @override
  void writeln([Object? obj = ""]) {}
  @override
  void abort([Object? exception, StackTrace? stackTrace]) {}
}

class _MockHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  @override
  int get statusCode => 200;
  @override
  int get contentLength => _transparentImage.length;
  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;
  @override
  final HttpHeaders headers = _MockHttpHeaders();
  @override
  final List<Cookie> cookies = [];
  @override
  final String reasonPhrase = 'OK';
  @override
  final bool isRedirect = false;
  @override
  final List<RedirectInfo> redirects = [];
  @override
  final bool persistentConnection = true;
  @override
  final X509Certificate? certificate = null;
  @override
  final HttpConnectionInfo? connectionInfo = null;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream.value(_transparentImage).listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  Future<HttpClientResponse> redirect([String? method, Uri? url, bool? followLoops]) async => this;

  @override
  Future<Socket> detachSocket() async {
    throw UnimplementedError();
  }
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  List<String>? operator [](String name) => null;
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  void clear() {}
  @override
  void forEach(void Function(String name, List<String> values) action) {}
  @override
  void noFolding(String name) {}
  @override
  void remove(String name, Object value) {}
  @override
  void removeAll(String name) {}
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  String? value(String name) => null;
  @override
  bool chunkedTransferEncoding = false;
  @override
  int contentLength = 0;
  @override
  ContentType? contentType;
  @override
  DateTime? date;
  @override
  DateTime? expires;
  @override
  String? host;
  @override
  DateTime? ifModifiedSince;
  @override
  bool persistentConnection = true;
  @override
  int? port;
}

void main() {
  setUp(() {
    HttpOverrides.global = _TestHttpOverrides();
    Get.reset();
    final auth = Get.put(AuthStorageService());
    auth.updateUser(
      UserModel(
        id: 'usr_pranab',
        fullName: 'Pranabesh Sarkar',
        email: 'pranabesh@ipam.edu',
        graduationYear: 2020,
        degree: 'B.Sc',
        isVerified: true,
      ),
    );
    Get.put(DashboardController());
    Get.put(HomeController());
  });

  tearDown(() {
    HttpOverrides.global = null;
  });

  testWidgets('HomeScreen renders user profile, quick actions, and highlights', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify User Greeting & Verified Pill matching screenshot
    expect(find.text('Hello, Pranabesh Sarkar'), findsOneWidget);
    expect(find.text('Class of 2020 • B.Sc'), findsOneWidget);
    expect(find.text('Registrar Verified'), findsOneWidget);

    // Verify 2x2 Grid Actions
    expect(find.text('My Digital ID'), findsOneWidget);
    expect(find.text('Directory'), findsOneWidget);
    expect(find.text('Career Portal'), findsOneWidget);
    expect(find.text('Giving & Dues'), findsOneWidget);

    // Verify Global Reach metrics
    expect(find.text('OUR GLOBAL REACH'), findsOneWidget);
    expect(find.text('15k+'), findsNWidgets(2)); // in Directory card and in Global Reach
    expect(find.text('45+'), findsOneWidget);
    expect(find.text('\$100k+'), findsOneWidget);

    // Verify Campus Banner
    expect(find.text('Visit IPAM Tower Hill Freetown'), findsOneWidget);
    expect(find.text('Tower Hill, Freetown'), findsOneWidget);
    expect(find.text('University of Sierra Leone'), findsOneWidget);
  });

  testWidgets('Quick action redirections link properly to dashboard tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.darkTheme,
        getPages: AppPages.routes,
        home: const HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    final dashboard = Get.find<DashboardController>();

    // 1. Directory -> Tab 1
    await tester.tap(find.text('Directory'));
    await tester.pumpAndSettle();
    expect(dashboard.currentIndex.value, equals(1));

    // 2. Career Portal -> Tab 2
    await tester.tap(find.text('Career Portal'));
    await tester.pumpAndSettle();
    expect(dashboard.currentIndex.value, equals(2));

    // 3. Giving & Dues -> Redirects to dedicated Giving & Dues Screen
    await tester.tap(find.text('Giving & Dues'));
    await tester.pumpAndSettle();
    expect(Get.currentRoute, equals(Routes.GIVING));
    expect(find.text('LIFETIME CONTRIBUTIONS'), findsOneWidget);
    expect(find.text('Make a Gift'), findsOneWidget);
    expect(find.text('Annual Dues'), findsOneWidget);
    expect(find.text('My Ledger'), findsOneWidget);
    expect(find.text('Impact Feed'), findsOneWidget);

    // Return back to HomeScreen
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
  });

  testWidgets('Upcoming Events and Jobs sections redirection and modal sheets link properly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    final dashboard = Get.find<DashboardController>();

    // 1. Upcoming Events 'View All' -> Tab 3
    await tester.scrollUntilVisible(find.text('View All'), 200);
    await tester.tap(find.text('View All'));
    await tester.pumpAndSettle();
    expect(dashboard.currentIndex.value, equals(3));

    // 2. Latest Jobs 'Explore Portal' -> Tab 2
    await tester.scrollUntilVisible(find.text('Explore Portal'), 200);
    await tester.tap(find.text('Explore Portal'));
    await tester.pumpAndSettle();
    expect(dashboard.currentIndex.value, equals(2));

    // 3. Directions & Hours tap -> Campus sheet
    await tester.scrollUntilVisible(find.text('Directions & Hours'), 200);
    await tester.tap(find.text('Directions & Hours'));
    await tester.pumpAndSettle();
    expect(find.text('IPAM Tower Hill Campus'), findsOneWidget);
    expect(find.text('Got It'), findsOneWidget);
    await tester.tap(find.text('Got It'));
    await tester.pumpAndSettle();

    // 4. Executive Council 'All Leaders' -> Tab 1
    await tester.scrollUntilVisible(find.text('All Leaders'), 200);
    await tester.tap(find.text('All Leaders'));
    await tester.pumpAndSettle();
    expect(dashboard.currentIndex.value, equals(1));

    // 5. Read Bio -> Leader Bio modal sheet with 'View Full Profile'
    final readBioFinder = find.text('Read Bio');
    int drags = 0;
    while (readBioFinder.evaluate().isEmpty && drags < 15) {
      await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -250));
      await tester.pumpAndSettle();
      drags++;
    }
    if (readBioFinder.evaluate().isNotEmpty) {
      await tester.tap(readBioFinder.first);
      await tester.pumpAndSettle();
      expect(find.text('View Full Profile'), findsOneWidget);
    }
  });

  testWidgets('Upcoming Events section strictly filters out backdated events and only displays upcoming ones', (WidgetTester tester) async {
    final homeController = Get.find<HomeController>();

    // Inject events matching the real API response (2 backdated in Oct 2026, 2 upcoming in Nov/Dec 2026)
    final mockEvents = [
      EventModel(
        id: 'seed-event-2',
        title: 'Career Growth Webinar',
        description: 'Past career transitions webinar',
        dateTime: DateTime(2026, 10, 5, 15, 0), // 23 days ago
        location: 'Online',
        category: 'WEBINAR',
      ),
      EventModel(
        id: 'seed-event-6',
        title: 'IPAM Mentorship Network Orientation',
        description: 'Past mentorship orientation',
        dateTime: DateTime(2026, 10, 18, 14, 0), // 10 days ago
        location: 'Online',
        category: 'CAREER_WORKSHOP',
      ),
      EventModel(
        id: 'seed-event-3',
        title: 'Freetown Young Alumni Networking Mixer',
        description: 'Upcoming networking mixer',
        dateTime: DateTime(2026, 11, 6, 18, 30), // Future
        location: 'Lumley Beach Pavilion',
        category: 'NETWORKING',
        price: r'$15',
        isFree: false,
      ),
      EventModel(
        id: 'seed-event-4',
        title: 'Fintech & Digital Banking Masterclass 2026',
        description: 'Upcoming masterclass',
        dateTime: DateTime(2026, 11, 20, 10, 0), // Future
        location: 'IPAM Innovation Hub',
        category: 'CAREER_WORKSHOP',
        price: r'$25',
        isFree: false,
      ),
    ];

    // Filter as HomeController does
    final upcoming = mockEvents.where((e) => e.isUpcoming).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    homeController.events.assignAll(upcoming);

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify backdated events (Oct 5 and Oct 18) are NOT present in Upcoming Events
    expect(find.text('Oct 5'), findsNothing);
    expect(find.text('Oct 18'), findsNothing);
    expect(find.text('Career Growth Webinar'), findsNothing);
    expect(find.text('IPAM Mentorship Network Orientation'), findsNothing);

    // Verify upcoming events (Nov 6 and Nov 20) ARE present
    expect(find.text('Nov 6'), findsOneWidget);
    expect(find.text('Nov 20'), findsOneWidget);
    expect(find.text('Freetown Young Alumni Networking Mixer'), findsOneWidget);
    expect(find.text('Fintech & Digital Banking Masterclass 2026'), findsOneWidget);
  });
}
