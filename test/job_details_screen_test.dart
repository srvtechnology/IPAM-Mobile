import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/routes/app_pages.dart';
import 'package:ipam_mobile/features/careers/models/career_job_model.dart';
import 'package:ipam_mobile/features/careers/controllers/job_details_controller.dart';
import 'package:ipam_mobile/features/careers/screens/job_details_screen.dart';

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

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async {
    return _MockHttpClientResponse();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => HttpStatus.ok;
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
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  const testJob = CareerJobModel(
    id: 'test_job_1',
    title: 'Development Economics Research Associate',
    company: 'African Development Bank (AfDB)',
    companyBadge: 'Orange Money Core Team',
    location: "Abidjan, Côte d'Ivoire / Remote",
    employmentType: 'Full-Time',
    preferenceBadge: 'USL Alumni Preferred',
    salary: 'International Post USD Stipend',
    alumniCount: 5,
    deadline: 'Dec 15, 2026',
    category: 'Economics & Research',
    isVerified: true,
    logoType: 'afdb',
    logoText: 'AfDB',
    logoBgColor: Color(0xFF0F172A),
    description:
        'Conduct empirical econometrics studies to evaluate infrastructural loans and microfinance equity funds for climate adaptation in West Africa.',
    requirements: [
      'Degree: M.Sc. or First Class B.Sc. from IPAM USL in Economics, Statistics, or Finance.',
      'Proficiency with R, Stata, Python, or SQL for empirical econometric modeling.',
    ],
    responsibilities: [
      'Author policy reports and academic research papers on African economic integration.',
      'Coordinate with regional banking authorities and ministerial stakeholders.',
    ],
    benefits: [
      'Multilateral Benefits: Tax-exempt international status',
      'Tech & Equipment Grant: Annual hardware allowance',
    ],
  );

  Widget createTestWidget({ThemeMode themeMode = ThemeMode.dark, CareerJobModel? job}) {
    return GetMaterialApp(
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: Routes.JOB_DETAILS,
      getPages: [
        GetPage(
          name: Routes.JOB_DETAILS,
          page: () => const JobDetailsScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => JobDetailsController());
          }),
        ),
      ],
    );
  }

  group('JobDetailsScreen Tests', () {
    testWidgets('Renders all sections matching Image 2, 3, 4 designs in Dark Theme', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      Get.reset();
      Get.parameters = {};

      await tester.pumpWidget(createTestWidget(themeMode: ThemeMode.dark, job: testJob));
      await tester.pumpAndSettle();

      // Image 2 Elements
      expect(find.text('Job Details'), findsOneWidget);
      expect(find.text('IPAM USL • ALUMNI NETWORK'), findsOneWidget);
      expect(find.text('IPAM Corporate Partner • Direct Hiring Channel'), findsOneWidget);
      expect(find.text('PRIORITY REVIEW'), findsOneWidget);
      expect(find.text('ECONOMICS & RESEARCH'), findsOneWidget);
      expect(find.text('Verified Partner'), findsOneWidget);
      expect(find.text('Development Economics Research Associate'), findsOneWidget);
      expect(find.text('African Development Bank (AfDB)'), findsOneWidget);
      expect(find.text("Abidjan, Côte d'Ivoire / Remote • Full-Time"), findsOneWidget);
      expect(find.text('International Post USD Stipend'), findsOneWidget);
      expect(find.text('Applications close Dec 15, 2026'), findsOneWidget);
      expect(find.text('USL Alumni Preferred'), findsOneWidget);
      expect(find.text('Orange Money Core Team'), findsOneWidget);
      expect(find.text('Top Employer'), findsOneWidget);

      // Image 3 Elements
      expect(find.text('ALUMNI INSIDER NETWORK'), findsOneWidget);
      expect(find.text('5 Active'), findsOneWidget);
      expect(find.text('5 IPAM Alumni currently work here in Economics & Research.'), findsOneWidget);
      expect(find.text('Request Alumni Referral'), findsOneWidget);
      expect(find.text('Overview & Impact'), findsOneWidget);
      expect(find.text('2.4M+'), findsOneWidget);
      expect(find.text('Daily Txns'), findsOneWidget);
      expect(find.text('99.98%'), findsOneWidget);
      expect(find.text('Uptime SLA'), findsOneWidget);
      expect(find.text('Tier 1'), findsOneWidget);
      expect(find.text('Bank Security'), findsOneWidget);

      // Image 4 Elements
      expect(find.text('Key Responsibilities'), findsOneWidget);
      expect(find.text('Requirements & Qualifications'), findsOneWidget);
      expect(find.text('Benefits & Alumni Perks'), findsOneWidget);

      // Sticky Bottom Bar
      expect(find.text('Quick Apply with Verified IPAM Profile'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);
    });

    testWidgets('Renders properly in Light Theme', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      Get.reset();
      await tester.pumpWidget(createTestWidget(themeMode: ThemeMode.light, job: testJob));
      await tester.pumpAndSettle();

      expect(find.text('Job Details'), findsOneWidget);
      expect(find.text('IPAM Corporate Partner • Direct Hiring Channel'), findsOneWidget);
      expect(find.text('Quick Apply with Verified IPAM Profile'), findsOneWidget);
    });

    testWidgets('Tapping Apply button updates sticky bar to Applied with IPAM ID ✓', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      Get.reset();
      await tester.pumpWidget(createTestWidget(themeMode: ThemeMode.dark, job: testJob));
      await tester.pumpAndSettle();

      final applyBtn = find.text('Quick Apply with Verified IPAM Profile');
      expect(applyBtn, findsOneWidget);

      await tester.tap(applyBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // State is now applied
      expect(find.text('Applied with IPAM ID ✓'), findsOneWidget);
      expect(find.byIcon(Icons.done_all_rounded), findsOneWidget);
    });

    testWidgets('Tapping Bookmark toggles bookmark icon state', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      Get.reset();
      await tester.pumpWidget(createTestWidget(themeMode: ThemeMode.dark, job: testJob));
      await tester.pumpAndSettle();

      final bookmarkBtn = find.byIcon(Icons.bookmark_border_rounded);
      expect(bookmarkBtn, findsOneWidget);

      await tester.tap(bookmarkBtn);
      await tester.pump();
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
    });
  });
}

