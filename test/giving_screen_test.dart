import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/core/network/auth_storage_service.dart';
import 'package:ipam_mobile/core/network/models/user_model.dart';
import 'package:ipam_mobile/core/theme/app_theme.dart';
import 'package:ipam_mobile/features/giving/controllers/giving_controller.dart';
import 'package:ipam_mobile/features/giving/data/giving_provider.dart';
import 'package:ipam_mobile/features/giving/models/donation_record.dart';
import 'package:ipam_mobile/features/giving/models/membership_subscription_model.dart';
import 'package:ipam_mobile/features/giving/screens/giving_screen.dart';
import 'package:ipam_mobile/features/giving/widgets/make_donation_form_widget.dart';
import 'package:ipam_mobile/features/giving/widgets/membership_dues_widget.dart';
import 'package:ipam_mobile/features/giving/widgets/giving_ledger_widget.dart';
import 'package:ipam_mobile/features/giving/widgets/campaign_impact_widget.dart';
import 'package:ipam_mobile/routes/app_pages.dart';

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
  HttpClient createHttpClient(SecurityContext? context) => _MockHttpClient();
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

class _MockGivingProvider extends GivingProvider {
  @override
  Future<List<DonationRecord>> fetchRecentDonations() async {
    return DonationRecord.sampleDonations();
  }

  @override
  Future<List<DonationRecord>> fetchMyDonations() async {
    return DonationRecord.sampleDonations();
  }

  @override
  Future<MembershipStatus> fetchMembershipStatus() async {
    return MembershipStatus.sampleActivePatron();
  }

  @override
  Future<bool> upgradeMembershipTier({
    required String tier,
    required String billingCycle,
    String paymentMethod = 'CARD',
    String? paymentReference,
  }) async {
    return true;
  }

  @override
  Future<bool> toggleAutoRenew(bool enable) async {
    return enable;
  }
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
    Get.put(GivingController(provider: _MockGivingProvider()));
  });

  tearDown(() {
    HttpOverrides.global = null;
  });

  testWidgets('GivingScreen renders header, lifetime card, and 4 tabs', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.darkTheme,
        getPages: AppPages.routes,
        home: const GivingScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Subtitle
    expect(find.text('Giving & Dues'), findsOneWidget);
    expect(find.text('USL • IPAM Alumni Endowment & Privileges'), findsOneWidget);
    expect(find.text('LIFETIME CONTRIBUTIONS'), findsOneWidget);

    // Verify 4 Segmented Tabs
    expect(find.text('Make a Gift'), findsOneWidget);
    expect(find.text('Annual Dues'), findsOneWidget);
    expect(find.text('My Ledger'), findsOneWidget);
    expect(find.text('Impact Feed'), findsOneWidget);

    // Initial tab (Make a Gift) view is shown
    expect(find.byType(MakeDonationFormWidget), findsOneWidget);
    expect(find.text('SELECT TARGET ENDOWMENT FUND'), findsOneWidget);
    expect(find.text('SELECT GIFT AMOUNT (USD)'), findsOneWidget);
  });

  testWidgets('Make a Gift tab allows fund and preset amount selection and donation submission', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.darkTheme,
        getPages: AppPages.routes,
        home: const GivingScreen(),
      ),
    );
    await tester.pumpAndSettle();

    final controller = Get.find<GivingController>();

    // Tap preset amount $100
    await tester.tap(find.text('\$100'));
    await tester.pumpAndSettle();
    expect(controller.selectedAmount.value, equals(100.0));

    // Tap preset amount $250
    await tester.tap(find.text('\$250'));
    await tester.pumpAndSettle();
    expect(controller.selectedAmount.value, equals(250.0));

    // Switch frequency to Monthly
    await tester.tap(find.text('Monthly Giving'));
    await tester.pumpAndSettle();
    expect(controller.selectedFrequency.value, equals('MONTHLY'));

    // Submit Donation
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -350));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Donate \$250 USD'));
    await tester.pumpAndSettle();

    // Verify Confirmation Dialog
    expect(find.text('Thank You for Your Generosity!'), findsOneWidget);
    expect(find.text('View Giving Ledger'), findsOneWidget);

    // Tap 'View Giving Ledger' to dismiss and jump to My Ledger tab
    await tester.tap(find.text('View Giving Ledger'));
    await tester.pumpAndSettle();
    expect(find.text('Thank You for Your Generosity!'), findsNothing);
    expect(controller.selectedTabIndex.value, equals(2));
  });

  testWidgets('Annual Dues tab displays status, auto-renew, and tier upgrades', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.darkTheme,
        getPages: AppPages.routes,
        home: const GivingScreen(),
      ),
    );
    await tester.pumpAndSettle();

    final controller = Get.find<GivingController>();

    // Switch to Tab 1: Annual Dues
    await tester.tap(find.text('Annual Dues'));
    await tester.pumpAndSettle();

    expect(find.byType(MembershipDuesWidget), findsOneWidget);
    expect(find.text('Annual Membership Dues'), findsOneWidget);
    expect(find.text('\$150 USD'), findsWidgets);
    expect(find.text('Auto-Renew Annual Dues'), findsOneWidget);

    // Toggle auto-renew
    final initialAutoRenew = controller.membershipStatus.value.autoRenew;
    await tester.tap(find.byType(Switch));
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(controller.membershipStatus.value.autoRenew, equals(!initialAutoRenew));

    // Check Membership Tiers comparison
    expect(find.text('MEMBERSHIP TIERS & PRIVILEGES'), findsOneWidget);
    expect(find.text('Silver Lifetime Fellow'), findsOneWidget);
    expect(find.text('Gold University Patron'), findsOneWidget);
  });

  testWidgets('My Ledger tab displays donation history and tax notice', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.darkTheme,
        getPages: AppPages.routes,
        home: const GivingScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Switch to Tab 2: My Ledger
    await tester.tap(find.text('My Ledger'));
    await tester.pumpAndSettle();

    expect(find.byType(GivingLedgerWidget), findsOneWidget);
    expect(find.text('Tax-Deductible Contribution Ledger'), findsOneWidget);
    expect(find.text('MY GIVING HISTORY'), findsOneWidget);
    expect(find.text('Tax Receipt'), findsWidgets);
  });

  testWidgets('Impact Feed tab displays goal progress and live community donors', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.darkTheme,
        getPages: AppPages.routes,
        home: const GivingScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Switch to Tab 3: Impact Feed
    await tester.tap(find.text('Impact Feed'));
    await tester.pumpAndSettle();

    expect(find.byType(CampaignImpactWidget), findsOneWidget);
    expect(find.text('2026 Endowment Campaign'), findsOneWidget);
    expect(find.text('LIVE RECENT DONORS'), findsOneWidget);
  });
}
