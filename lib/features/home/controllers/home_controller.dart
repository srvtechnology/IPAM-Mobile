import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/home_provider.dart';
import '../models/job_match_model.dart';
import '../models/council_leader_model.dart';
import '../../events/models/event_model.dart';
import '../../../core/network/auth_storage_service.dart';
import '../../../core/network/models/user_model.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../careers/controllers/careers_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final HomeProvider _provider;
  final AuthStorageService _authStorage;

  HomeController({HomeProvider? provider, AuthStorageService? authStorage})
    : _provider = provider ?? HomeProvider(),
      _authStorage =
          authStorage ??
          (Get.isRegistered<AuthStorageService>()
              ? Get.find<AuthStorageService>()
              : Get.put(AuthStorageService()));

  final jobs = <JobMatchModel>[].obs;
  final events = <EventModel>[].obs;
  final leaders = <CouncilLeaderModel>[].obs;
  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final directoryCount = '15k+'.obs;

  // Authenticated user with demo fallback matching screenshot
  UserModel get user {
    return _authStorage.user ??
        UserModel(
          id: 'usr_pranab',
          fullName: 'Pranabesh Sarkar',
          email: 'pranabesh.sarkar@alumni.ipam.edu',
          phone: '+232 76 998 877',
          graduationYear: 2020,
          degree: 'B.Sc',
          department: 'Computer Science',
          membershipNumber: 'IPAM-ALM-2020-0821',
          isVerified: true,
          hasDigitalCard: true,
          avatarUrl: null,
        );
  }

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  /// Dynamically loads all home screen data from providers / live APIs
  Future<void> loadHomeData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _provider.fetchLatestJobs(),
        _provider.fetchFeaturedEvents(),
        _provider.fetchCouncilLeaders(),
      ]);

      jobs.assignAll(results[0] as List<JobMatchModel>);
      final rawEvents = results[1] as List<EventModel>;
      final upcomingEvents = rawEvents.where((e) => e.isUpcoming).toList()
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
      events.assignAll(upcomingEvents);
      leaders.assignAll(results[2] as List<CouncilLeaderModel>);
    } catch (_) {
      jobs.assignAll(_provider.getLatestJobs());
      final fallbackEvents =
          _provider.getFeaturedEvents().where((e) => e.isUpcoming).toList()
            ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
      events.assignAll(fallbackEvents);
      leaders.assignAll(_provider.getCouncilLeaders());
    } finally {
      isLoading.value = false;
    }
  }

  /// Pull-to-refresh handler
  Future<void> refreshHomeData() async {
    isRefreshing.value = true;
    try {
      await loadHomeData();
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Redirection: Switches bottom navigation tab
  void navigateToTab(int tabIndex) {
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().changeTab(tabIndex);
    } else {
      Get.toNamed(Routes.DASHBOARD);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().changeTab(tabIndex);
        }
      });
    }
  }

  /// Redirection: Opens Virtual Pass / Digital ID screen
  void openDigitalPass() {
    Get.toNamed(Routes.VIRTUAL_PASS);
  }

  /// Redirection: Opens Event Details screen with specific event model
  void openEventDetails(EventModel event) {
    Get.toNamed(Routes.EVENT_DETAILS, arguments: event);
  }

  /// Redirection: Opens Member Details screen with specific alumnus model
  void openMemberDetails(CouncilLeaderModel leader) {
    Get.toNamed(Routes.MEMBER_DETAILS, arguments: leader.toAlumniModel());
  }

  /// Redirection & Interaction: Displays the leader bio with a link to full member profile
  void showLeaderBio(CouncilLeaderModel leader) {
    Get.bottomSheet(
      Builder(
        builder: (context) {
          final isDark = AppColors.isDark(context);
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border(
                top: BorderSide(
                  color: AppColors.cardBorder(context),
                  width: 1.5,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: leader.avatarUrl.startsWith('http')
                          ? NetworkImage(leader.avatarUrl)
                          : null,
                      backgroundColor: isDark
                          ? AppColors.emeraldDarker
                          : AppColors.jadeSoft,
                      child: !leader.avatarUrl.startsWith('http')
                          ? Text(
                              leader.name.isNotEmpty
                                  ? leader.name[0].toUpperCase()
                                  : 'A',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.emeraldDeep,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            leader.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          Text(
                            leader.role,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.darkTealPillText
                                  : AppColors.emeraldDeep,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            leader.classYear,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  leader.bio,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary(context),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary(context),
                          side: BorderSide(
                            color: AppColors.cardBorder(context),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => Get.back(),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tealPillBg(context),
                          foregroundColor: isDark
                              ? AppColors.darkTealPillText
                              : AppColors.emeraldDeep,
                          side: BorderSide(
                            color: AppColors.tealPillBorder(context),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Get.back();
                          openMemberDetails(leader);
                        },
                        icon: const Icon(Icons.person_search_rounded, size: 18),
                        label: const Text(
                          'View Full Profile',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  /// Redirection & Interaction: Opens Job Details full screen
  void openJobDetails(JobMatchModel job) {
    Get.toNamed(Routes.JOB_DETAILS, arguments: job.toCareerJob());
  }

  /// Redirection: Applies for a job and connects with CareersController
  Future<void> applyForJob(JobMatchModel job) async {
    if (job.originalJob != null && Get.isRegistered<CareersController>()) {
      await Get.find<CareersController>().applyJob(job.originalJob!);
    } else {
      Get.snackbar(
        'Application Submitted',
        'Your profile credentials have been routed to ${job.company} hiring committee.',
        backgroundColor: AppColors.emeraldDarker,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Redirection: Opens dedicated Giving & Dues page
  void openGivingAndDues() {
    Get.toNamed(Routes.GIVING);
  }

  /// Redirection: Displays Giving & Dues (redirects to dedicated Giving & Dues page)
  void showGivingAndDuesSheet() {
    openGivingAndDues();
  }

  /// Redirection: Displays Campus Directions & Visiting Hours sheet
  void showCampusDirectionsSheet() {
    Get.bottomSheet(
      Builder(
        builder: (context) {
          final isDark = AppColors.isDark(context);
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border(
                top: BorderSide(
                  color: AppColors.cardBorder(context),
                  width: 1.5,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.goldWarm
                            : AppColors.goldLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.school_rounded,
                          color: isDark
                              ? AppColors.charcoal
                              : AppColors.goldWarm,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'IPAM Tower Hill Campus',
                            style: GoogleFonts.libreCaslonText(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          Text(
                            'University of Sierra Leone • Freetown',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorder(context)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: isDark
                                ? AppColors.darkTealPillText
                                : AppColors.emeraldDeep,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'State Avenue, Tower Hill, Freetown, Sierra Leone',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 18,
                            color: isDark
                                ? AppColors.goldWarm
                                : const Color(0xFFB45309),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Mon–Fri: 8:00 AM – 6:00 PM • Sat: 9:00 AM – 2:00 PM',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                color: AppColors.textSecondary(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Located adjacent to the Parliament of Sierra Leone. Alumni Secretariat welcomes all visiting graduates for campus card renewals, networking visits, and archive access.',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: AppColors.textPrimary(context),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emeraldDarker,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text(
                      'Got It',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  /// Redirection: Displays Notifications screen
  void showNotificationsSheet() {
    Get.toNamed(Routes.NOTIFICATIONS);
  }
}
