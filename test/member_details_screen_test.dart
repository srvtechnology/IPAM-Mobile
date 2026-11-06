import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/features/directory/controllers/member_details_controller.dart';
import 'package:ipam_mobile/features/directory/screens/member_details_screen.dart';

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
  @override
  String? userAgent;
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

class _MockHttpHeaders implements HttpHeaders {
  @override
  List<String>? operator [](String name) => null;
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  void clear() {}
  @override
  void noFolding(String name) {}
  @override
  void remove(String name, Object value) {}
  @override
  void removeAll(String name) {}
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  void forEach(void Function(String name, List<String> values) action) {}
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

class _MockHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  @override
  final HttpHeaders headers = _MockHttpHeaders();
  @override
  int statusCode = 200;
  @override
  int contentLength = _transparentImage.length;
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
    return Stream.value(_transparentImage).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
  @override
  Future<Socket> detachSocket() => throw UnimplementedError();
  @override
  List<Cookie> get cookies => [];
  @override
  bool get isRedirect => false;
  @override
  String get reasonPhrase => 'OK';
  @override
  List<RedirectInfo> get redirects => [];
  @override
  Future<HttpClientResponse> redirect([String? method, Uri? url, bool? followLoops]) =>
      throw UnimplementedError();
  @override
  X509Certificate? get certificate => null;
  @override
  HttpConnectionInfo? get connectionInfo => null;
  @override
  bool get persistentConnection => true;
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  tearDown(() {
    Get.reset();
  });

  group('Directory Member Details Screen Tests', () {
    testWidgets('MemberDetailsScreen renders all components cleanly from attached images',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final controller = MemberDetailsController();
      Get.put(controller);

      await tester.pumpWidget(
        GetMaterialApp(
          home: const MemberDetailsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // 1. App Bar Title and Subtitle
      expect(find.text('Directory Member Details'), findsOneWidget);
      expect(find.text('IPAM USL • DIRECTORY'), findsOneWidget);

      // 2. Action Ribbon
      expect(find.text('REGISTRAR CONFIRMED'), findsOneWidget);

      // 3. Hero Card details for Prof. Aminata Bangura
      expect(find.text('Prof. Aminata Bangura, Ph.D., FCPA'), findsOneWidget);
      expect(
        find.text('President, Alumni Association & Professor of Public Governance'),
        findsOneWidget,
      );
      expect(
        find.text('Institute of Public Administration and Management • USL'),
        findsOneWidget,
      );
      expect(find.text('Class of 1998'), findsOneWidget);
      expect(find.text('Freetown (Tower Hill)'), findsOneWidget);
      expect(find.text('USL/IPAM/94/0821'), findsOneWidget);
      expect(
        find.text('USL Registrar Authenticated • Verified Alumnus'),
        findsOneWidget,
      );

      // 4. Action Buttons (Direct Message commented out)
      expect(find.text('Mentorship'), findsOneWidget);
      expect(find.text('Connect to Executive Network'), findsOneWidget);

      // 5. 4 Metrics Cards (2x2)
      expect(find.text('26+ Years'), findsOneWidget);
      expect(find.text('Alumni Seniority'), findsOneWidget);
      expect(find.text('Executive'), findsOneWidget);
      expect(find.text('Council Leadership'), findsOneWidget);
      expect(find.text('50+ Fellows'), findsOneWidget);
      expect(find.text('Students Mentored'), findsOneWidget);
      expect(find.text('Life Member'), findsOneWidget);
      expect(find.text('Giving Circle Patron'), findsOneWidget);

      // 6. Tabs
      expect(find.text('Overview & Bio'), findsOneWidget);
      expect(find.text('Credentials'), findsOneWidget);
      expect(find.text('Career & Governance'), findsOneWidget);
      expect(find.text('Mentorship (3)'), findsOneWidget);

      // 7. Overview & Bio Content
      expect(find.text('PRESIDENTIAL ADDRESS'), findsOneWidget);
      expect(find.text('Executive Biography'), findsOneWidget);
      expect(find.text('Office & Official Contact'), findsOneWidget);
      expect(find.text('a.bangura@ipam.usl.edu.sl'), findsOneWidget);
      expect(find.text('Authenticated'), findsOneWidget);
      expect(find.text('Secretariat Office, IPAM Tower Hill'), findsOneWidget);
      expect(find.text('Tue & Thu 14:00 GMT'), findsOneWidget);
      expect(find.text('linkedin.com/in/prof-aminata-bangura'), findsOneWidget);
    });

    testWidgets('Tapping tabs switches content views reactively', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final controller = MemberDetailsController();
      Get.put(controller);

      await tester.pumpWidget(
        GetMaterialApp(
          home: const MemberDetailsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Credentials tab
      await tester.ensureVisible(find.text('Credentials'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Credentials'));
      await tester.pumpAndSettle();
      expect(find.text('Academic Degrees & Honours'), findsOneWidget);
      expect(find.text('USL Registrar Archive Certificate'), findsOneWidget);

      // Tap Career & Governance tab
      await tester.ensureVisible(find.text('Career & Governance'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Career & Governance'));
      await tester.pumpAndSettle();
      expect(find.text('Governance & Civic Leadership'), findsOneWidget);

      // Tap Mentorship tab
      await tester.ensureVisible(find.text('Mentorship (3)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mentorship (3)'));
      await tester.pumpAndSettle();
      expect(find.text('Mentorship Fellowship'), findsOneWidget);
      expect(find.text('3 SLOTS OPEN'), findsOneWidget);
    });

    testWidgets('Connect button toggles connected state', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final controller = MemberDetailsController();
      Get.put(controller);

      await tester.pumpWidget(
        GetMaterialApp(
          home: const MemberDetailsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Connect to Executive Network'), findsOneWidget);

      // Tap Connect
      await tester.tap(find.text('Connect to Executive Network'));
      await tester.pumpAndSettle();

      expect(find.text('Connected to Executive Network'), findsOneWidget);
      expect(controller.isConnected.value, isTrue);
    });
  });
}
