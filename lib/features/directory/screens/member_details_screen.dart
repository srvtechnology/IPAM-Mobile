import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/member_details_controller.dart';
import '../widgets/member_details_header_widget.dart';
import '../widgets/member_details_hero_widget.dart';
import '../widgets/member_details_actions_widget.dart';
import '../widgets/member_details_metrics_grid_widget.dart';
import '../widgets/member_details_tabs_widget.dart';
import '../widgets/member_details_tab_views.dart';

class MemberDetailsScreen extends GetView<MemberDetailsController> {
  const MemberDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<MemberDetailsController>()) {
      Get.put(MemberDetailsController());
    }

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Obx(() {
          final alumnus = controller.alumnus.value;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header with Back Button, Title/Subtitle, Share, Registrar Confirmed & Bookmark/Link
                MemberDetailsHeaderWidget(
                  isBookmarked: controller.isBookmarked.value,
                  onBack: () => Get.back(),
                  onShare: controller.shareProfile,
                  onBookmark: controller.toggleBookmark,
                  onCopyLink: controller.copyProfileLink,
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Hero Profile Card with Avatar, Verified Badge, Name, Role, Location & Credential Box
                      MemberDetailsHeroWidget(alumnus: alumnus),

                      const SizedBox(height: 16),

                      // 3. Action Buttons: Mentorship, Connect to Executive Network (Direct Message commented out)
                      MemberDetailsActionsWidget(
                        isConnected: controller.isConnected.value,
                        // onDirectMessage: () => controller.showDirectMessageSheet(context),
                        onMentorship: () => controller.showMentorshipModal(context),
                        onConnect: controller.toggleConnect,
                      ),

                      const SizedBox(height: 18),

                      // 4. 2x2 Metrics Grid (Alumni Seniority, Council Leadership, Students Mentored, Giving Circle)
                      MemberDetailsMetricsGridWidget(alumnus: alumnus),

                      const SizedBox(height: 18),

                      // 5. Horizontal Tab Pills: Overview & Bio, Credentials, Career & Governance, Mentorship
                      MemberDetailsTabsWidget(
                        tabs: controller.tabs,
                        selectedIndex: controller.selectedTabIndex.value,
                        onTabSelected: controller.selectTab,
                      ),

                      const SizedBox(height: 16),

                      // 6. Selected Tab Content View
                      IndexedStack(
                        index: controller.selectedTabIndex.value,
                        children: [
                          MemberOverviewBioView(alumnus: alumnus),
                          MemberCredentialsView(alumnus: alumnus),
                          MemberCareerGovernanceView(alumnus: alumnus),
                          MemberMentorshipView(alumnus: alumnus),
                        ],
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
