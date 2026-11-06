import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/user_profile_card_widget.dart';
import '../widgets/quick_action_grid_widget.dart';
import '../widgets/global_reach_widget.dart';
import '../widgets/campus_banner_widget.dart';
import '../widgets/upcoming_events_section_widget.dart';
import '../widgets/latest_jobs_section_widget.dart';
import '../widgets/executive_spotlight_widget.dart';
import '../widgets/inspirational_quote_widget.dart';
import '../../../core/theme/app_colors.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<HomeController>()) {
      Get.put(HomeController());
    }

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshHomeData,
          color: AppColors.emeraldDarker,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header (IPAM Alumni crest, Dark/Light toggle, Bell, Profile Avatar)
                Obx(
                  () => HomeHeaderWidget(
                    avatarUrl: controller.user.avatarUrl,
                    userName: controller.user.fullName,
                    onNotificationTap: controller.showNotificationsSheet,
                    onProfileTap: () => controller.navigateToTab(4),
                  ),
                ),
                // Main Scrollable Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      // 2. User Greeting Card (Dynamic Hello, Class & Degree, Verified Badge, QR)
                      Obx(
                        () => UserProfileCardWidget(
                          user: controller.user,
                          onQrTap: controller.openDigitalPass,
                          onCardTap: () => controller.navigateToTab(4),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 3. Quick Action 2x2 Grid (Digital ID, Directory, Careers, Giving & Dues)
                      Obx(
                        () => QuickActionGridWidget(
                          onDigitalIdTap: controller.openDigitalPass,
                          onDirectoryTap: () => controller.navigateToTab(1),
                          onCareersTap: () => controller.navigateToTab(2),
                          onGivingTap: controller.openGivingAndDues,
                          careerBadgeText: '${controller.jobs.length} New',
                          directoryBadgeText: controller.directoryCount.value,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 4. Our Global Reach (15k+, 45+, $100k+)
                      const GlobalReachWidget(),
                      const SizedBox(height: 16),
                      // 5. Campus Banner (Visit IPAM Tower Hill Freetown & Directions Sheet)
                      CampusBannerWidget(
                        onDirectionsTap: controller.showCampusDirectionsSheet,
                      ),
                      const SizedBox(height: 24),
                      // 6. Upcoming Events (Dynamic events from EventsProvider / Live API)
                      Obx(
                        () => UpcomingEventsSectionWidget(
                          events: controller.events.toList(),
                          onViewAll: () => controller.navigateToTab(3),
                          onEventTap: controller.openEventDetails,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 7. Latest Job Matches (Dynamic jobs with accent bar, Apply & Sheet)
                      Obx(
                        () => LatestJobsSectionWidget(
                          jobs: controller.jobs.toList(),
                          onExplorePortal: () => controller.navigateToTab(2),
                          onApply: controller.applyForJob,
                          onJobTap: controller.openJobDetails,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 8. Executive Council Spotlight (Dynamic leaders, Read Bio & Profile)
                      Obx(
                        () => ExecutiveSpotlightWidget(
                          leaders: controller.leaders.toList(),
                          onAllLeadersTap: () => controller.navigateToTab(1),
                          onReadBio: controller.showLeaderBio,
                          onLeaderTap: controller.openMemberDetails,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 9. Inspirational Quote Card
                      const InspirationalQuoteWidget(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
