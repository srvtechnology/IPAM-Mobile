import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/core/network/auth_storage_service.dart';
import 'package:ipam_mobile/core/network/api_client.dart';
import 'package:ipam_mobile/core/theme/app_theme.dart';
import 'package:ipam_mobile/features/directory/controllers/directory_controller.dart';
import 'package:ipam_mobile/features/directory/screens/directory_screen.dart';
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
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _MockHttpHeaders implements HttpHeaders {
  final Map<String, List<Object>> _data = {};

  @override
  List<String>? operator [](String name) => _data[name]?.map((e) => e.toString()).toList();
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    _data.putIfAbsent(name, () => []).add(value);
  }
  @override
  void clear() => _data.clear();
  @override
  void forEach(void Function(String name, List<String> values) action) {}
  @override
  void noFolding(String name) {}
  @override
  void remove(String name, Object value) => _data[name]?.remove(value);
  @override
  void removeAll(String name) => _data.remove(name);
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) => _data[name] = [value];
  @override
  String? value(String name) => _data[name]?.firstOrNull?.toString();
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  setUp(() {
    HttpOverrides.global = _TestHttpOverrides();
    Get.reset();
  });

  tearDown(() {
    HttpOverrides.global = null;
    Get.reset();
  });

  testWidgets('DirectoryScreen renders header, search, chips, and alumni cards cleanly without GetX errors',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Get.put(AuthStorageService());
    Get.put(ApiClient());
    final dirController = DirectoryController();
    Get.put(dirController);

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const DirectoryScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top Bar Header
    expect(
      find.byWidgetPredicate(
        (widget) => widget is RichText && widget.text.toPlainText().contains('IPAM Alumni'),
      ),
      findsOneWidget,
    );
    expect(find.text('USL • TOWER HILL'), findsOneWidget);

    // 2. Verify Global Directory Banner
    expect(find.text('Global Directory'), findsOneWidget);
    expect(find.text('5,400+ Verified Members Worldwide'), findsOneWidget);
    expect(find.text('All Chapters'), findsOneWidget);

    // 3. Verify Filter Chips
    expect(find.text('All (5.4k)'), findsOneWidget);
    expect(find.text('Executive Council'), findsOneWidget);
    expect(find.text('Finance & Accounting'), findsOneWidget);
    expect(find.text('Public Admin'), findsOneWidget);

    // 4. Verify Results Counter
    expect(
      find.byWidgetPredicate(
        (widget) => widget is RichText && widget.text.toPlainText().contains('5 Alumni matches'),
      ),
      findsOneWidget,
    );

    // 5. Verify Alumni names from reference screenshots 2 & 3
    expect(find.text('Prof. Aminata Bangura, Ph.D.'), findsOneWidget);
    expect(find.text('David Okoro'), findsOneWidget);
    expect(find.text('Elena Rodriguez'), findsOneWidget);
    expect(find.text('Fatima Sesay'), findsOneWidget);

    // 6. Verify Badges and Action buttons
    expect(find.text('USL Verified'), findsWidgets);
    // Message option commented out from Directory
    expect(find.text('Connect'), findsWidgets);
  });

  testWidgets('DirectoryScreen search filtering updates results dynamically',
      (WidgetTester tester) async {
    Get.put(AuthStorageService());
    Get.put(ApiClient());
    final dirController = DirectoryController();
    Get.put(dirController);

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const DirectoryScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Type 'David' in search field
    await tester.enterText(find.byType(TextField), 'David');
    dirController.onSearchChanged('David');
    await tester.pumpAndSettle();

    expect(find.text('David Okoro'), findsOneWidget);
    expect(find.text('Prof. Aminata Bangura, Ph.D.'), findsNothing);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is RichText && widget.text.toPlainText().contains('1 Alumni matches'),
      ),
      findsOneWidget,
    );

    // Clear search
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();

    expect(find.text('David Okoro'), findsOneWidget);
    expect(find.text('Prof. Aminata Bangura, Ph.D.'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is RichText && widget.text.toPlainText().contains('5 Alumni matches'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('DirectoryScreen category chip tap filters list',
      (WidgetTester tester) async {
    Get.put(AuthStorageService());
    Get.put(ApiClient());
    final dirController = DirectoryController();
    Get.put(dirController);

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const DirectoryScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap 'Finance & Accounting'
    await tester.tap(find.text('Finance & Accounting'));
    await tester.pumpAndSettle();

    expect(find.text('Elena Rodriguez'), findsOneWidget);
    expect(find.text('Fatima Sesay'), findsOneWidget);
    expect(find.text('David Okoro'), findsNothing);
  });

  testWidgets('Tapping on a directory member card navigates to MemberDetailsScreen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    Get.put(AuthStorageService());
    Get.put(ApiClient());
    final dirController = DirectoryController();
    Get.put(dirController);

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        initialRoute: Routes.DIRECTORY,
        getPages: AppPages.routes,
      ),
    );
    await tester.pumpAndSettle();

    // Verify Prof. Aminata Bangura is displayed
    expect(find.text('Prof. Aminata Bangura, Ph.D.'), findsOneWidget);

    // Tap on the card for Prof. Aminata Bangura
    await tester.tap(find.text('Prof. Aminata Bangura, Ph.D.'));
    await tester.pumpAndSettle();

    // Verify we navigated to Member Details page
    expect(find.text('Directory Member Details'), findsOneWidget);
    expect(find.text('REGISTRAR CONFIRMED'), findsOneWidget);
    expect(find.text('Prof. Aminata Bangura, Ph.D., FCPA'), findsOneWidget);
  });
}
