import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/core/network/auth_storage_service.dart';
import 'package:ipam_mobile/features/profile/controllers/profile_controller.dart';
import 'package:ipam_mobile/features/profile/models/profile_model.dart';
import 'package:ipam_mobile/features/profile/screens/profile_screen.dart';
import 'package:ipam_mobile/features/profile/widgets/digital_pass_card_widget.dart';
import 'package:ipam_mobile/features/profile/widgets/alumni_profile_management_widget.dart';
import 'package:ipam_mobile/features/profile/widgets/profile_avatar_view.dart';

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

  setUp(() {
    Get.reset();
    Get.put(AuthStorageService());
    Get.put(ProfileController());
  });

  group('Profile & ID Pass Tests', () {
    test('ProfileModel initializes with Mohamed S. Bangura credentials', () {
      final model = ProfileModel.defaultMohamedProfile();
      expect(model.fullName, 'Mohamed S. Bangura');
      expect(model.degree, 'B.Sc. Banking & Finance');
      expect(model.graduationYear, 2016);
      expect(model.yearsAlumni, 10);
      expect(model.givingCircle, 'Active');
      expect(model.cohortRole, 'Mentor');
      expect(model.memberId, 'IPAM-ALUM-2016-8841');
      expect(model.isSynchronized, isTrue);
    });

    test('ProfileController toggles mentorship, biometrics, and directory settings', () {
      final controller = Get.find<ProfileController>();
      expect(controller.profile.value.isMentorAvailable, isTrue);

      controller.toggleMentor();
      expect(controller.profile.value.isMentorAvailable, isFalse);

      controller.toggleBiometrics(false);
      expect(controller.profile.value.biometricAuthEnabled, isFalse);

      controller.toggleDirectoryVisibility(false);
      expect(controller.profile.value.directoryVisibilityEnabled, isFalse);
    });

    testWidgets('ProfileScreen renders all redesigned UI elements cleanly', (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        GetMaterialApp(
          home: const ProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Top Bar & Synchronized pill
      expect(find.text('IPAM Alumni'), findsOneWidget);
      expect(find.text('USL • TOWER HILL'), findsOneWidget);
      expect(find.text('USL REGISTRAR ARCHIVES • SYNCHRONIZED'), findsOneWidget);
      expect(find.text('Verified'), findsOneWidget);

      // Profile Card
      expect(find.text('Mohamed S. Bangura'), findsWidgets);
      expect(find.text('B.Sc. Banking & Finance (Class of 2016)'), findsOneWidget);
      expect(find.text('Senior Financial Analyst at Central Bank of Sierra Leone'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('Years Alumni'), findsOneWidget);
      expect(find.text('Active'), findsWidgets);
      expect(find.text('Giving Circle'), findsOneWidget);
      expect(find.text('Mentor'), findsOneWidget);
      expect(find.text('Final Year Cohort'), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Share Profile'), findsOneWidget);

      // Digital Pass Section
      expect(find.text('Digital Pass & ID'), findsOneWidget);
      expect(find.text('OFFICIAL CREDENTIAL'), findsOneWidget);
      expect(find.text('UNIVERSITY OF SIERRA LEONE'), findsOneWidget);
      expect(find.text('IPAM • Tower Hill Campus'), findsOneWidget);
      expect(find.text('ALUMNI ASSOCIATION GLOBAL PASS'), findsOneWidget);
      expect(find.text('GRADUATE CREDENTIAL'), findsOneWidget);
      expect(find.text('IPAM-ALUM-2016-8841'), findsOneWidget);
      expect(find.text('DEC 2028'), findsOneWidget);
      expect(find.text('SCAN TO VERIFY'), findsOneWidget);
      expect(find.text('USL REGISTRAR ARCHIVE CERTIFIED'), findsOneWidget);
      expect(find.text('SECURE • SHA-256'), findsOneWidget);

      // Pass Action Buttons
      expect(find.text('Add to Wallet'), findsOneWidget);
      expect(find.text('Offline PDF Pass'), findsOneWidget);

      // Account & Records
      expect(find.text('Account & Records'), findsOneWidget);
      expect(find.text('7 sections'), findsOneWidget);
      expect(find.text('Academic Credentials & Transcripts'), findsOneWidget);
      expect(find.text('Membership Dues & Giving'), findsOneWidget);
      expect(find.text('Mentorship Preferences'), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);
    });

    testWidgets('DigitalPassCardWidget 3D flips between front and back on double tap', (tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Front side is visible initially
      expect(find.text('GRADUATE CREDENTIAL'), findsOneWidget);
      expect(find.text('AUTHORIZED REGISTRAR SIGNATURE'), findsNothing);

      // Perform double tap on the pass card
      final cardFinder = find.byType(DigitalPassCardWidget);
      expect(cardFinder, findsOneWidget);
      await tester.ensureVisible(cardFinder);
      await tester.pumpAndSettle();

      await tester.tap(cardFinder);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(cardFinder);
      await tester.pumpAndSettle();

      // Back side is now visible
      expect(find.text('AUTHORIZED REGISTRAR SIGNATURE'), findsOneWidget);
      expect(find.text('Prof. E. C. Palmer, Registrar'), findsOneWidget);
      expect(find.text('SECURITY TRACK 1 // USL-ALUMNI-CARD-SYS'), findsOneWidget);

      // Double tap again to flip back to front side
      await tester.tap(cardFinder);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(cardFinder);
      await tester.pumpAndSettle();

      // Front side is restored
      expect(find.text('GRADUATE CREDENTIAL'), findsOneWidget);
      expect(find.text('AUTHORIZED REGISTRAR SIGNATURE'), findsNothing);
    });

    testWidgets('Tapping My Registered Events & Tickets opens bottom sheet with registered passes', (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final eventsTileFinder = find.text('My Registered Events & Tickets');
      expect(eventsTileFinder, findsOneWidget);

      await tester.ensureVisible(eventsTileFinder);
      await tester.pumpAndSettle();
      await tester.tap(eventsTileFinder);
      await tester.pumpAndSettle();

      // Verify the bottom sheet opened with title and CTA button
      expect(find.text('My Registered Events & Tickets'), findsWidgets);
      expect(find.text('Open in Events Hub (My Tickets)'), findsOneWidget);
    });

    testWidgets('Tapping Saved Job Applications opens bottom sheet with saved jobs and applications', (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final savedTileFinder = find.text('Saved Job Applications');
      expect(savedTileFinder, findsOneWidget);

      await tester.ensureVisible(savedTileFinder);
      await tester.pumpAndSettle();
      await tester.tap(savedTileFinder);
      await tester.pumpAndSettle();

      // Verify the bottom sheet opened
      expect(find.text('Saved Jobs & Applications'), findsOneWidget);
      expect(find.text('Explore All Careers & Openings'), findsOneWidget);
    });

    testWidgets('Tapping Edit Profile opens Alumni Profile Management matching web portal UI', (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: ProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final editButton = find.text('Edit Profile');
      expect(editButton, findsOneWidget);
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      // Verify Alumni Profile Management modal opened
      expect(find.byType(AlumniProfileManagementWidget), findsOneWidget);
      expect(find.text('Alumni Profile Management'), findsOneWidget);
      expect(find.text('Profile Photo (Base64 System)'), findsOneWidget);
      expect(find.text('Upload New Photo'), findsOneWidget);
      expect(find.text('ACADEMIC & GRADUATE IDENTITY'), findsOneWidget);
      expect(find.text('CAREER & PROFESSIONAL INFORMATION'), findsOneWidget);
      expect(find.text('Open to Mentoring Younger Alumni & IPAM Students'), findsOneWidget);
      expect(find.text('SKILLS & FUNCTIONAL COMPETENCIES'), findsOneWidget);
      expect(find.text('Quick add suggestions:'), findsOneWidget);
      expect(find.text('Alumni Biography & Professional Statement'), findsOneWidget);
      expect(find.text('Save Profile Changes'), findsOneWidget);
    });

    testWidgets('AlumniProfileManagementWidget allows adding quick suggestions and saving profile', (tester) async {
      tester.view.physicalSize = const Size(500, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final controller = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: AlumniProfileManagementWidget(controller: controller),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on a quick suggestion (e.g. "+ Public Policy")
      final publicPolicySuggestion = find.text('Public Policy');
      expect(publicPolicySuggestion, findsOneWidget);
      await tester.ensureVisible(publicPolicySuggestion);
      await tester.pumpAndSettle();
      await tester.tap(publicPolicySuggestion);
      await tester.pumpAndSettle();

      // Tap Save Profile Changes
      final saveBtn = find.text('Save Profile Changes');
      await tester.ensureVisible(saveBtn);
      await tester.pumpAndSettle();
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      // Verify skills updated in controller
      expect(controller.profile.value.skills.contains('Public Policy'), isTrue);
    });

    testWidgets('ProfileAvatarView renders initial letter fallback and camera badge correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileAvatarView(
              avatarUrl: '',
              name: 'David Sesay',
              size: 80,
              showCameraBadge: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should display initial letter "D" on fallback
      expect(find.text('D'), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);
    });

    testWidgets('AlumniProfileManagementWidget renders cleanly in both Light and Dark themes', (tester) async {
      tester.view.physicalSize = const Size(500, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final controller = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());

      // 1. Test Light Theme
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.light(),
          themeMode: ThemeMode.light,
          home: Scaffold(
            body: AlumniProfileManagementWidget(controller: controller),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Alumni Profile Management'), findsOneWidget);
      expect(find.text('Profile Photo (Base64 System)'), findsOneWidget);
      expect(find.text('Save Profile Changes'), findsOneWidget);

      // Verify separate theme toggle button is NOT present in modal header (uses global theming)
      final themeBtn = find.byWidgetPredicate(
        (w) => w is IconButton && (w.tooltip == 'Switch to Light Theme' || w.tooltip == 'Switch to Dark Theme'),
      );
      expect(themeBtn, findsNothing);

      // 2. Test Dark Theme via global theming
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          home: Scaffold(
            body: AlumniProfileManagementWidget(controller: controller),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Alumni Profile Management'), findsOneWidget);
      expect(find.text('Profile Photo (Base64 System)'), findsOneWidget);
      expect(find.text('Save Profile Changes'), findsOneWidget);
    });

    testWidgets('ProfileAvatarView extracts 1st letter of username / email prefix / name', (tester) async {
      // 1. Username as email: "pranabesh.sarkar@alumni.ipam.edu" -> "P"
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileAvatarView(
              avatarUrl: '',
              name: 'Pranabesh Sarkar',
              username: 'pranabesh.sarkar@alumni.ipam.edu',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('P'), findsOneWidget);

      // 2. Username with '@' handle prefix: "@sarkar" -> "S"
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileAvatarView(
              avatarUrl: '',
              name: 'Pranabesh Sarkar',
              username: '@sarkar',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('S'), findsOneWidget);

      // 3. Fallback when avatarUrl is 'null' or 'undefined' string
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileAvatarView(
              avatarUrl: 'null',
              name: 'Mohamed Bangura',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('M'), findsOneWidget);

      // 4. Fallback to 'A' when name and username are completely empty
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileAvatarView(
              avatarUrl: '',
              name: '',
              username: '',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('A'), findsOneWidget);
    });

    test('ProfileController updateFullProfile builds OpenAPI ProfileUpdateRequest and updates state', () async {
      final controller = Get.find<ProfileController>();
      final authStorage = Get.find<AuthStorageService>();

      final success = await controller.updateFullProfile(
        fullName: 'Pranabesh Sarkar',
        graduationYear: 2020,
        degree: 'B.Sc. Computer Science',
        major: 'Software Systems',
        currentRole: 'Lead Architect',
        currentCompany: 'USL Innovation Labs',
        industrySector: 'Information Technology',
        country: 'Sierra Leone',
        city: 'Freetown',
        linkedinUrl: 'https://linkedin.com/in/pranabesh',
        isMentor: true,
        skills: ['Flutter', 'Systems Architecture', 'Cloud Infrastructure'],
        bio: 'Senior engineer driving technological modernization across Sierra Leone.',
      );

      expect(success, isTrue);
      expect(controller.profile.value.fullName, 'Pranabesh Sarkar');
      expect(controller.profile.value.graduationYear, 2020);
      expect(controller.profile.value.degree, 'B.Sc. Computer Science');
      expect(controller.profile.value.currentRole, 'Lead Architect');
      expect(controller.profile.value.currentCompany, 'USL Innovation Labs');
      expect(controller.profile.value.industrySector, 'Information Technology');
      expect(controller.profile.value.location, 'Freetown, Sierra Leone');
      expect(controller.profile.value.isMentorAvailable, isTrue);
      expect(controller.profile.value.skills, contains('Flutter'));
      expect(controller.profile.value.bio, contains('Senior engineer'));

      // Verify AuthStorageService was updated
      if (authStorage.user != null) {
        expect(authStorage.user!.fullName, 'Pranabesh Sarkar');
        expect(authStorage.user!.graduationYear, 2020);
        expect(authStorage.user!.currentRole, 'Lead Architect');
      }
    });
  });
}
