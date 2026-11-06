import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/features/careers/controllers/careers_controller.dart';
import 'package:ipam_mobile/features/careers/screens/careers_screen.dart';

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
  setUp(() {
    HttpOverrides.global = _TestHttpOverrides();
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  group('CareersController Tests', () {
    test('Initializes with 6 total jobs, 4 applications, and 2 postings', () {
      final controller = CareersController();
      controller.onInit();

      expect(controller.allJobsCount, equals(6));
      expect(controller.appliedCount, equals(4));
      expect(controller.myPostingsCount, equals(2));
      expect(controller.filteredJobs.length, equals(6));
    });

    test('Filtering by Applications tab yields 4 jobs', () {
      final controller = CareersController();
      controller.onInit();

      controller.switchTab('Applications');
      expect(controller.filteredJobs.length, equals(4));
      for (final job in controller.filteredJobs) {
        expect(job.isApplied, isTrue);
      }
    });

    test('Filtering by My Postings tab yields 2 jobs', () {
      final controller = CareersController();
      controller.onInit();

      controller.switchTab('My Postings');
      expect(controller.filteredJobs.length, equals(2));
      for (final job in controller.filteredJobs) {
        expect(job.isMyPosting, isTrue);
      }
    });

    test('Filtering by category (Public Administration) filters jobs', () {
      final controller = CareersController();
      controller.onInit();

      controller.selectCategory('Public Administration');
      for (final job in controller.filteredJobs) {
        expect(job.category, equals('Public Administration'));
      }
    });

    test('Searching by keyword filters results accurately', () {
      final controller = CareersController();
      controller.onInit();

      controller.onSearchChanged('Backend');
      expect(controller.filteredJobs.length, equals(1));
      expect(controller.filteredJobs.first.title, contains('Backend'));
    });

    test('Applying to a job updates its applied state', () {
      final controller = CareersController();
      controller.onInit();

      final unapplied = controller.allJobs.firstWhere((j) => !j.isApplied);
      expect(unapplied.isApplied, isFalse);

      controller.applyJob(unapplied);
      final updated = controller.allJobs.firstWhere((j) => j.id == unapplied.id);
      expect(updated.isApplied, isTrue);
    });

    test('Toggling bookmark updates job state and saved collections', () {
      final controller = CareersController();
      controller.onInit();

      final job = controller.allJobs.first;
      final initialBookmark = job.isBookmarked;

      controller.toggleBookmark(job);
      final updated = controller.allJobs.firstWhere((j) => j.id == job.id);
      expect(updated.isBookmarked, equals(!initialBookmark));
      if (!initialBookmark) {
        expect(controller.savedJobIds.contains(job.id), isTrue);
      } else {
        expect(controller.savedJobIds.contains(job.id), isFalse);
      }
    });

    test('Filtering by Saved Jobs category shows only bookmarked jobs', () {
      final controller = CareersController();
      controller.onInit();

      controller.selectCategory('Saved Jobs');
      for (final j in controller.filteredJobs) {
        expect(j.isBookmarked || controller.savedJobIds.contains(j.id), isTrue);
      }
    });

    test('Posting a vacancy increases count and switches to My Postings', () {
      final controller = CareersController();
      controller.onInit();

      final initialPostings = controller.myPostingsCount;

      controller.addVacancy(
        title: 'Chief Compliance Officer',
        company: 'Salone FinTech Ltd',
        location: 'Freetown, Sierra Leone',
        salary: '\$2,500 - \$3,500 monthly',
        category: 'Finance & Banking',
      );

      expect(controller.myPostingsCount, equals(initialPostings + 1));
      expect(controller.activeTab.value, equals('My Postings'));
      expect(controller.filteredJobs.first.title, equals('Chief Compliance Officer'));
    });
  });

  group('CareersScreen Widget Tests', () {
    testWidgets('Renders Alumni Career Portal UI components cleanly', (tester) async {
      final controller = CareersController();
      Get.put(controller);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: CareersScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Header & Title
      expect(find.text('IPAM Alumni'), findsOneWidget);
      expect(find.text('USL • TOWER HILL'), findsOneWidget);
      expect(find.text('USL CAREER ADVANCEMENT SERVICE'), findsOneWidget);
      expect(find.text('Alumni Career Portal'), findsOneWidget);

      // Verify Segmented Tabs
      expect(find.text('All Jobs'), findsOneWidget);
      expect(find.text('Applications'), findsOneWidget);
      expect(find.text('My Postings'), findsOneWidget);

      // Verify Recruiter Banner
      expect(find.text('Hiring Alumni Talent?'), findsOneWidget);
      expect(find.text('Post a Vacancy'), findsOneWidget);

      // Verify Section Heading
      expect(find.text('Verified Job Openings'), findsOneWidget);
      expect(find.text('USL REGISTRY BACKED'), findsOneWidget);

      // Verify Job Cards
      expect(find.text('Orange Sierra Leone'), findsOneWidget);
      expect(find.text('Senior Backend Engineer'), findsOneWidget);
      expect(find.text('Applied with IPAM ID'), findsWidgets);

      // Verify Career Support Card
      expect(find.text('Alumni Career Support'), findsOneWidget);
      expect(find.text('Connect with a Career Mentor'), findsOneWidget);
    });

    testWidgets('Tapping Applications tab renders Applications view in-place below header and tabs, and tapping All Jobs restores view', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      Get.reset();
      final controller = Get.put(CareersController());

      await tester.pumpWidget(
        const GetMaterialApp(
          home: CareersScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Applications tab
      await tester.tap(find.text('Applications'));
      await tester.pumpAndSettle();

      // Verify Header & Segmented Tabs remain persistently visible
      expect(find.text('Alumni Career Portal'), findsOneWidget);
      expect(find.text('USL CAREER ADVANCEMENT SERVICE'), findsOneWidget);
      expect(find.text('All Jobs'), findsOneWidget);
      expect(find.text('Applications'), findsOneWidget);
      expect(find.text('My Postings'), findsOneWidget);

      // Verify Applications tab content rendered inline below tabs
      expect(find.text('EXECUTIVE PLACEMENT PORTAL'), findsOneWidget);
      expect(find.text('My Job Applications'), findsOneWidget);
      expect(find.text('TOTAL'), findsOneWidget);
      expect(find.text('REVIEW'), findsOneWidget);
      expect(find.text('ACTIVE'), findsOneWidget);
      expect(find.text('06'), findsOneWidget);
      expect(find.text('03'), findsOneWidget);
      expect(find.text('01'), findsOneWidget);

      // Verify application cards
      expect(find.text('Sierra Digital Payments (Alumni Founded)'), findsOneWidget);
      expect(find.text('Associate Operations & Risk Manager'), findsWidgets);
      expect(find.text('Under Review'), findsWidgets);
      expect(find.text('View Application Details & Notes'), findsWidgets);

      // Tap View Application Details & Notes to open dynamic modal
      await tester.tap(find.text('View Application Details & Notes').first);
      await tester.pumpAndSettle();

      // Verify dynamic modal sections render
      expect(find.text('Recruiter Remarks & Review Notes'), findsOneWidget);
      expect(find.text('Submitted Candidate Profile'), findsOneWidget);
      expect(find.text('Institutional Documents & Attachments'), findsOneWidget);
      expect(find.text('Dismiss'), findsOneWidget);

      // Close modal
      await tester.tap(find.text('Dismiss'));
      await tester.pumpAndSettle();

      // Tap All Jobs tab in the header
      await tester.tap(find.text('All Jobs'));
      await tester.pumpAndSettle();

      // Restored to All Jobs
      expect(controller.activeTab.value, equals('All Jobs'));
      expect(find.text('Verified Job Openings'), findsOneWidget);
      expect(find.text('Senior Backend Engineer'), findsOneWidget);
    });

    testWidgets('Tapping My Postings tab renders My Posted Jobs view in-place below header and tabs, and tapping All Jobs restores view', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      Get.reset();
      final controller = Get.put(CareersController());

      await tester.pumpWidget(
        const GetMaterialApp(
          home: CareersScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap My Postings tab
      await tester.tap(find.text('My Postings'));
      await tester.pumpAndSettle();

      // Verify Header & Segmented Tabs remain persistently visible
      expect(find.text('Alumni Career Portal'), findsOneWidget);
      expect(find.text('USL CAREER ADVANCEMENT SERVICE'), findsOneWidget);
      expect(find.text('All Jobs'), findsOneWidget);
      expect(find.text('Applications'), findsOneWidget);
      expect(find.text('My Postings'), findsOneWidget);

      // Verify My Postings view components rendered inline below tabs
      expect(find.text('My Posted Jobs'), findsWidgets);
      expect(find.text('USL ALUMNI EMPLOYER PORTAL'), findsWidgets);
      expect(find.text('Post New Job'), findsOneWidget);
      expect(find.text('TOTAL POSTED'), findsOneWidget);
      expect(find.text('ACTIVE OPEN'), findsOneWidget);
      expect(find.text('APPLICANTS'), findsOneWidget);
      expect(find.text('2'), findsWidgets);
      expect(find.text('4'), findsWidgets);

      // Verify posted job cards
      expect(find.text('Central Bank of Sierra Leone'), findsOneWidget);
      expect(find.text('BSL'), findsOneWidget);
      expect(find.text('SDP'), findsOneWidget);
      expect(find.text('Status: '), findsWidgets);
      expect(find.text('Review Candidates'), findsWidgets);

      // Tap All Jobs tab in the header
      await tester.tap(find.text('All Jobs'));
      await tester.pumpAndSettle();

      // Restored to All Jobs
      expect(controller.activeTab.value, equals('All Jobs'));
      expect(find.text('Verified Job Openings'), findsOneWidget);
      expect(find.text('Senior Backend Engineer'), findsOneWidget);
    });
  });
}
