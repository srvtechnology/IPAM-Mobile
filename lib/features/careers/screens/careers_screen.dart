import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/careers_controller.dart';
import '../models/career_job_model.dart';
import '../widgets/career_header_widget.dart';
import '../widgets/career_banner_widget.dart';
import '../widgets/career_job_card_widget.dart';
import '../widgets/career_support_card_widget.dart';
import '../widgets/career_applications_view.dart';
import '../widgets/career_my_postings_view.dart';
import '../widgets/post_vacancy_bottom_sheet.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class CareersScreen extends GetView<CareersController> {
  const CareersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CareersController>()) {
      Get.put(CareersController());
    }

    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.loadJobs,
          color: AppColors.emeraldDeep,
          child: SingleChildScrollView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // 1. Institutional Top Bar & Title
              CareerHeaderWidget(
                onNotificationTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                onProfileTap: () {
                  if (Get.isRegistered<DashboardController>()) {
                    Get.find<DashboardController>().changeTab(4);
                  }
                },
              ),
              const SizedBox(height: 18),

              // 2. Segmented Sub-Tabs: All Jobs (6) | Applications (4) | My Postings (2)
              _buildSegmentedTabs(context, isDark),
              const SizedBox(height: 16),

              // 3. In-Place Tab Content Switcher
              Obx(() {
                final activeTab = controller.activeTab.value;

                if (activeTab == 'Applications') {
                  return CareerApplicationsView(
                    showAppBar: false,
                    onBack: () => controller.switchTab('All Jobs'),
                  );
                } else if (activeTab == 'My Postings') {
                  return CareerMyPostingsView(
                    showAppBar: false,
                    onBack: () => controller.switchTab('All Jobs'),
                    onPostNewJob: () => _showPostVacancySheet(context),
                  );
                }

                return _buildAllJobsContent(context, isDark);
              }),
            ],
          ),
        ),
      ),
    ),
  );
  }

  /// All Jobs Content View: Search, Category Chips, Recruiter Banner, Job Openings, Support Card
  Widget _buildAllJobsContent(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar & Filter Button
        _buildSearchBar(context, isDark),
        const SizedBox(height: 14),

        // Horizontal Category Filter Chips
        _buildCategoryChips(context, isDark),
        const SizedBox(height: 16),

        // "Hiring Alumni Talent?" Recruiter & Founder Network Banner
        Obx(
          () => CareerBannerWidget(
            myPostingsCount: controller.myPostingsCount,
            onPostVacancy: () => _showPostVacancySheet(context),
            onMyPostings: () => controller.switchTab('My Postings'),
          ),
        ),
        const SizedBox(height: 22),

        // Section Header: "Verified Job Openings" [6 Active] ... USL REGISTRY BACKED
        _buildSectionHeader(context, isDark),
        const SizedBox(height: 14),

        // Verified Job Cards List
        Obx(() {
          final jobs = controller.filteredJobs;

          if (jobs.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.card(context),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.cardBorder(context)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business_center_outlined,
                    size: 48,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No Vacancies Found',
                    style: GoogleFonts.libreCaslonText(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Try adjusting your keywords or category filters.',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      color: AppColors.textSecondary(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.clearSearch();
                      controller.selectCategory('All Roles');
                      controller.switchTab('All Jobs');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emeraldDeep,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Reset All Filters'),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: jobs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final job = jobs[index];
              return CareerJobCardWidget(
                job: job,
                onApply: () => controller.applyJob(job),
                onBookmark: () => controller.toggleBookmark(job),
                onViewDetails: () => _showJobDetailsSheet(context, job),
              );
            },
          );
        }),
        const SizedBox(height: 24),

        // Alumni Career Support Card
        CareerSupportCardWidget(
          onConnectMentor: () => _showMentorSheet(context),
        ),
      ],
    );
  }

  /// Segmented Sub-Tabs: All Jobs (6) | Applications (4) | My Postings (2)
  Widget _buildSegmentedTabs(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Obx(
        () => Row(
          children: [
            // Tab 1: All Jobs (6)
            Expanded(
              child: _buildSubTabItem(
                context,
                title: 'All Jobs',
                count: controller.allJobsCount,
                badgeBg: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                badgeTextColor: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                isSelected: controller.activeTab.value == 'All Jobs',
                onTap: () => controller.switchTab('All Jobs'),
                isDark: isDark,
              ),
            ),
            // Tab 2: Applications (4)
            Expanded(
              child: _buildSubTabItem(
                context,
                title: 'Applications',
                count: controller.appliedCount,
                badgeBg: isDark ? const Color(0xFF451A03) : const Color(0xFFFEF3C7),
                badgeTextColor: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
                isSelected: controller.activeTab.value == 'Applications',
                onTap: () => controller.switchTab('Applications'),
                isDark: isDark,
              ),
            ),
            // Tab 3: My Postings (2)
            Expanded(
              child: _buildSubTabItem(
                context,
                title: 'My Postings',
                count: controller.myPostingsCount,
                badgeBg: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF),
                badgeTextColor: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                isSelected: controller.activeTab.value == 'My Postings',
                onTap: () => controller.switchTab('My Postings'),
                isDark: isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubTabItem(
    BuildContext context, {
    required String title,
    required int count,
    required Color badgeBg,
    required Color badgeTextColor,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF0F172A) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? (isDark ? Colors.white : AppColors.charcoal)
                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6.5, vertical: 2),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: badgeTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Search Bar with Prefix Search Icon, Hint Text & Suffix Sliders Filter Button
  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
              boxShadow: AppColors.cardShadow(context),
            ),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: AppColors.textPrimary(context),
              ),
              decoration: InputDecoration(
                hintText: 'Search role, company, skills, location...',
                hintStyle: GoogleFonts.manrope(
                  fontSize: 12.5,
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  size: 20,
                ),
                suffixIcon: Obx(() {
                  if (controller.searchQuery.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: controller.clearSearch,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  );
                }),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Filter Button
        InkWell(
          onTap: () => _showFilterSheet(context),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
              boxShadow: AppColors.cardShadow(context),
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 22,
              color: isDark ? Colors.white : AppColors.charcoal,
            ),
          ),
        ),
      ],
    );
  }

  /// Horizontal Category Filter Chips
  Widget _buildCategoryChips(BuildContext context, bool isDark) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = controller.categories[index];
          return Obx(() {
            final isSelected = controller.selectedCategory.value == cat;
            return GestureDetector(
              onTap: () => controller.selectCategory(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? AppColors.darkTealPillBg : AppColors.emeraldDeep)
                      : (isDark ? const Color(0xFF1E293B) : Colors.white),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? (isDark ? AppColors.darkTealPillBorder : AppColors.emeraldDeep)
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    width: 1.1,
                  ),
                  boxShadow: isSelected
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                ),
                child: Center(
                  child: Text(
                    cat,
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? (isDark ? AppColors.darkTealPillText : Colors.white)
                          : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  /// Section Header: Verified Job Openings [6 Active] ... USL REGISTRY BACKED
  Widget _buildSectionHeader(BuildContext context, bool isDark) {
    return Row(
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  'Verified Job Openings',
                  style: GoogleFonts.libreCaslonText(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    '${controller.filteredJobs.length} Active',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          'USL REGISTRY BACKED',
          style: GoogleFonts.manrope(
            fontSize: 9.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  /// Job Details Full Screen
  void _showJobDetailsSheet(BuildContext context, CareerJobModel job) {
    Get.toNamed(Routes.JOB_DETAILS, arguments: job);
  }

  /// Post a Vacancy Bottom Sheet
  void _showPostVacancySheet(BuildContext context) {
    showPostVacancyBottomSheet(context, controller);
  }

  /// Filter Bottom Sheet
  void _showFilterSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.cardBorder(context), width: 1.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Filter Career Opportunities',
              style: GoogleFonts.libreCaslonText(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Employment Mode',
              style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All Modes'),
                  selected: true,
                  onSelected: (_) {},
                  selectedColor: AppColors.emeraldDeep.withValues(alpha: 0.15),
                ),
                FilterChip(
                  label: const Text('Hybrid Only'),
                  selected: false,
                  onSelected: (_) {
                    controller.onSearchChanged('Hybrid');
                    Get.back();
                  },
                ),
                FilterChip(
                  label: const Text('Freetown On-Site'),
                  selected: false,
                  onSelected: (_) {
                    controller.onSearchChanged('Freetown');
                    Get.back();
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emeraldDeep,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Get.back(),
                child: const Text('Apply Filters', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Mentor Connection Bottom Sheet
  void _showMentorSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.cardBorder(context), width: 1.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'IPAM Executive Mentorship',
              style: GoogleFonts.libreCaslonText(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Matched senior alumni review your CV and provide referrals to hiring managers at Orange, Ministry of Finance, and banking partners.',
              style: GoogleFonts.manrope(
                fontSize: 12.5,
                color: AppColors.textSecondary(context),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emeraldDeep,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'Mentor Request Sent! 🤝',
                    'An executive alumni advisor has been notified to review your profile.',
                    backgroundColor: AppColors.emeraldDeep,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 3),
                  );
                },
                child: const Text('Request Executive Review', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
