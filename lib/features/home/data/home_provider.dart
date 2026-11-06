import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../models/job_match_model.dart';
import '../models/council_leader_model.dart';
import '../../events/models/event_model.dart';
import '../../events/data/events_provider.dart';
import '../../careers/data/careers_provider.dart';
import '../../directory/data/directory_provider.dart';

class HomeProvider {
  final EventsProvider _eventsProvider;
  final CareersProvider _careersProvider;
  final DirectoryProvider _directoryProvider;
  final ApiClient _apiClient;

  HomeProvider({
    EventsProvider? eventsProvider,
    CareersProvider? careersProvider,
    DirectoryProvider? directoryProvider,
    ApiClient? apiClient,
  })  : _eventsProvider = eventsProvider ?? EventsProvider(),
        _careersProvider = careersProvider ?? CareersProvider(),
        _directoryProvider = directoryProvider ?? DirectoryProvider(),
        _apiClient = apiClient ??
            (Get.isRegistered<ApiClient>()
                ? Get.find<ApiClient>()
                : Get.put(ApiClient(), permanent: true));

  /// Dynamically fetches latest jobs from CareersProvider / live API
  Future<List<JobMatchModel>> fetchLatestJobs() async {
    try {
      final careerJobs = await _careersProvider.fetchJobs();
      if (careerJobs.isNotEmpty) {
        final colors = [
          const Color(0xFF059669),
          const Color(0xFFD97706),
          const Color(0xFF2563EB),
        ];
        return careerJobs.take(3).toList().asMap().entries.map((entry) {
          final idx = entry.key;
          final job = entry.value;
          return JobMatchModel.fromCareerJob(
            job,
            accentColor: colors[idx % colors.length],
          );
        }).toList();
      }
    } catch (_) {}
    return getLatestJobs();
  }

  /// Dynamically fetches featured events from EventsProvider / live API,
  /// strictly filtering out backdated events and ordering chronologically.
  Future<List<EventModel>> fetchFeaturedEvents() async {
    try {
      final events = await _eventsProvider.fetchEvents();
      if (events.isNotEmpty) {
        final upcomingEvents = events.where((e) => e.isUpcoming).toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
        if (upcomingEvents.isNotEmpty) {
          return upcomingEvents.take(5).toList();
        }
      }
    } catch (_) {}
    return getFeaturedEvents().where((e) => e.isUpcoming).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  /// Dynamically fetches executive council leaders from Leadership API (GET /api/leadership)
  /// with fallback to DirectoryProvider / live directory
  Future<List<CouncilLeaderModel>> fetchCouncilLeaders() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.leadership);
      if (response.isOk && response.body != null) {
        final body = response.body is Map ? Map<String, dynamic>.from(response.body) : <String, dynamic>{};
        final list = (body['data'] as List<dynamic>? ?? []);
        if (list.isNotEmpty) {
          return list
              .whereType<Map>()
              .map((e) => CouncilLeaderModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
      }
    } catch (_) {}

    try {
      final alumni = await _directoryProvider.fetchAlumni();
      final leaders = alumni.where((a) {
        return a.isExecutiveLeader ||
            a.category.toLowerCase().contains('executive') ||
            a.role.toLowerCase().contains('president') ||
            a.role.toLowerCase().contains('vp') ||
            a.badge.toLowerCase().contains('council');
      }).toList();

      if (leaders.isNotEmpty) {
        return leaders
            .take(5)
            .map((a) => CouncilLeaderModel.fromAlumni(a))
            .toList();
      }
    } catch (_) {}
    return getCouncilLeaders();
  }

  List<JobMatchModel> getLatestJobs() {
    return const [
      JobMatchModel(
        id: 'job_1',
        title: 'Senior Backend Engineer',
        company: 'Orange Sierra Leone',
        location: 'Hill Station HQ, Freetown (Hybrid)',
        employmentType: 'Full Time',
        accentColor: Color(0xFF059669),
        salary: '\$28,000 - \$36,000 USD / yr',
        description:
            'Orange Sierra Leone is seeking a Senior Backend Engineer to build robust fintech and telecom microservices.',
      ),
      JobMatchModel(
        id: 'job_2',
        title: 'Senior Policy Analyst - Fiscal Decentralisation',
        company: 'Ministry of Finance',
        location: 'George Street, Freetown',
        employmentType: 'Full Time',
        accentColor: Color(0xFFD97706),
        salary: 'NLe 180,000 - 240,000 / yr',
        description:
            'Conduct economic research, revenue mobilization assessments, and intergovernmental fiscal transfer reviews.',
      ),
    ];
  }

  List<EventModel> getFeaturedEvents() {
    return [
      EventModel(
        id: 'ev_1',
        title: 'Freetown Young Alumni Networking Mixer',
        description:
            'Connecting Recent Graduates (Classes 2018–2025) with Established Industry Leaders.',
        dateTime: DateTime(2026, 11, 6, 18, 0),
        location: 'Lumley Beach Pavilion',
        category: 'Featured Flagship Event',
        rsvpCount: 84,
        isRsvp: false,
        price: r'$15',
        isFree: false,
      ),
      EventModel(
        id: 'ev_2',
        title: 'Career & Cross-Border Mobility Masterclass',
        description:
            'Navigating border remote opportunities and pan-African executive career tracks.',
        dateTime: DateTime(2026, 11, 18, 16, 0),
        location: 'Global Virtual Hub',
        category: 'Free • Virtual',
        rsvpCount: 165,
        isRsvp: false,
        price: 'Free',
        isFree: true,
      ),
    ];
  }

  List<CouncilLeaderModel> getCouncilLeaders() {
    return const [
      CouncilLeaderModel(
        id: 'leader_1',
        name: 'Prof. Aminata Bangura',
        role: 'President, Alumni Association',
        classYear: 'Class of 1998',
        avatarUrl:
            'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=300&q=80',
        bio:
            'Leading institutional transformation and diaspora engagement for IPAM graduates across 40+ countries.',
      ),
      CouncilLeaderModel(
        id: 'leader_2',
        name: 'David Okoro',
        role: 'VP Outreach & Strategy',
        classYear: 'Class of 2010',
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
        bio:
            'Overseeing corporate partnerships, fintech innovation sponsorships, and young alumni mentorship pipelines.',
      ),
    ];
  }
}
