import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/careers_controller.dart';
import '../models/career_application_model.dart';

class CareerApplicationsView extends GetView<CareersController> {
  final VoidCallback? onBack;
  final bool showAppBar;

  const CareerApplicationsView({
    super.key,
    this.onBack,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showAppBar) ...[
          // 1. Top App Bar: Back arrow, Title, Subtitle, Share
          _buildTopBar(context, isDark),
          const SizedBox(height: 12),
        ],

        // 2. Badge: EXECUTIVE PLACEMENT PORTAL
        _buildPortalBadge(context, isDark),
        const SizedBox(height: 10),

        // 3. Hero Title & Subtitle
        Text(
          'My Job Applications',
          style: GoogleFonts.libreCaslonText(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.charcoal,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Track your active submissions, registrar credential verifications, and recruiter feedback.',
          style: GoogleFonts.manrope(
            fontSize: 12.5,
            color: AppColors.textSecondary(context),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 16),

        // 4. 3 Stats Cards: TOTAL (06 Submitted), REVIEW (03 In Review), ACTIVE (01 Interviewing)
        _buildStatsCards(context, isDark),
        const SizedBox(height: 16),

        // 5. Filter Pills: All (6) | Active (4) | Interviews (1) | Archived (0)
        _buildFilterPills(context, isDark),
        const SizedBox(height: 16),

        // 6. Application Cards List
        Obx(() {
          final apps = controller.filteredApplications;

          if (apps.isEmpty) {
            final isFiltering = controller.selectedApplicationFilter.value != 'All';
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.card(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder(context)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 44,
                    color: AppColors.textTertiary(context),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isFiltering ? 'No Applications in this category' : 'No Applications Submitted Yet',
                    style: GoogleFonts.libreCaslonText(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isFiltering
                        ? 'Try selecting a different filter tab above.'
                        : 'Explore verified job openings and submit your application with verified USL credentials.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      color: AppColors.textSecondary(context),
                      height: 1.4,
                    ),
                  ),
                  if (!isFiltering) ...[
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => controller.switchTab('All Jobs'),
                      icon: const Icon(Icons.search, size: 16),
                      label: Text(
                        'Browse Verified Openings',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emeraldDeep,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: apps.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              return _buildApplicationCard(context, apps[index], isDark);
            },
          );
        }),
        const SizedBox(height: 20),

        // 7. Career Advisory & Prep Teaser Card
        _buildAdvisoryTeaser(context, isDark),
        const SizedBox(height: 24),
      ],
    );
  }

  /// Top App Bar matching Screenshot 2
  Widget _buildTopBar(BuildContext context, bool isDark) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : AppColors.charcoal,
            size: 22,
          ),
          onPressed: onBack ?? () => controller.switchTab('All Jobs'),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Application Status',
                style: GoogleFonts.libreCaslonText(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'IPAM USL • ALUMNI NETWORK',
                style: GoogleFonts.manrope(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: const Color(0xFFD97706),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.share_outlined,
            color: isDark ? Colors.white70 : const Color(0xFF475569),
            size: 21,
          ),
          onPressed: () {
            Get.snackbar(
              'Share Applications Portfolio',
              'Link to your verified alumni profile copied to clipboard.',
              snackPosition: SnackPosition.TOP,
            );
          },
        ),
      ],
    );
  }

  /// Portal Badge: EXECUTIVE PLACEMENT PORTAL
  Widget _buildPortalBadge(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.business_center_rounded,
            size: 15,
            color: Color(0xFF059669),
          ),
          const SizedBox(width: 6),
          Text(
            'EXECUTIVE PLACEMENT PORTAL',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
              color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
            ),
          ),
        ],
      ),
    );
  }

  /// 3 Stats Cards: TOTAL | REVIEW | ACTIVE
  Widget _buildStatsCards(BuildContext context, bool isDark) {
    return Obx(
      () => Row(
        children: [
          // TOTAL (06 Submitted)
          Expanded(
            child: _buildStatItem(
              context,
              isDark: isDark,
              title: 'TOTAL',
              value: controller.applicationsTotalCount < 10
                  ? '0${controller.applicationsTotalCount}'
                  : '${controller.applicationsTotalCount}',
              subtitle: 'Submitted',
              valueColor: isDark ? Colors.white : AppColors.charcoal,
              icon: Icons.send_rounded,
              iconColor: const Color(0xFF059669),
            ),
          ),
          const SizedBox(width: 10),

          // REVIEW (03 In Review)
          Expanded(
            child: _buildStatItem(
              context,
              isDark: isDark,
              title: 'REVIEW',
              value: controller.applicationsReviewCount < 10
                  ? '0${controller.applicationsReviewCount}'
                  : '${controller.applicationsReviewCount}',
              subtitle: 'In Review',
              valueColor: const Color(0xFFD97706),
              icon: Icons.assignment_turned_in_outlined,
              iconColor: const Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(width: 10),

          // ACTIVE (01 Interviewing)
          Expanded(
            child: _buildStatItem(
              context,
              isDark: isDark,
              title: 'ACTIVE',
              value: controller.applicationsInterviewingCount < 10
                  ? '0${controller.applicationsInterviewingCount}'
                  : '${controller.applicationsInterviewingCount}',
              subtitle: 'Interviewing',
              valueColor: const Color(0xFF059669),
              icon: Icons.record_voice_over_outlined,
              iconColor: const Color(0xFF059669),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required bool isDark,
    required String title,
    required String value,
    required String subtitle,
    required Color valueColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder(context)),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: AppColors.textTertiary(context),
                ),
              ),
              Icon(icon, size: 16, color: iconColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.libreCaslonText(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.manrope(
              fontSize: 10.5,
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  /// Filter Pills: All (6) | Active (4) | Interviews (1) | Archived (0)
  Widget _buildFilterPills(BuildContext context, bool isDark) {
    return Obx(() {
      final selected = controller.selectedApplicationFilter.value;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            _buildFilterPillItem(
              context,
              title: 'All (${controller.applicationsTotalCount})',
              isSelected: selected == 'All',
              onTap: () => controller.selectApplicationFilter('All'),
              isDark: isDark,
            ),
            const SizedBox(width: 8),
            _buildFilterPillItem(
              context,
              title: 'Active (${controller.applicationsActiveCount})',
              isSelected: selected == 'Active',
              onTap: () => controller.selectApplicationFilter('Active'),
              isDark: isDark,
            ),
            const SizedBox(width: 8),
            _buildFilterPillItem(
              context,
              title: 'Interviews (${controller.applicationsInterviewingCount})',
              isSelected: selected == 'Interviews',
              onTap: () => controller.selectApplicationFilter('Interviews'),
              isDark: isDark,
            ),
            const SizedBox(width: 8),
            _buildFilterPillItem(
              context,
              title: 'Archived (${controller.applicationsArchivedCount})',
              isSelected: selected == 'Archived',
              onTap: () => controller.selectApplicationFilter('Archived'),
              isDark: isDark,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFilterPillItem(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF044E3D) : AppColors.emeraldDeep)
              : AppColors.card(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isDark ? const Color(0xFF059669) : AppColors.emeraldDeep)
                : AppColors.cardBorder(context),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
          ),
        ),
      ),
    );
  }

  /// Application Card matching Screenshot 2 & 4
  Widget _buildApplicationCard(BuildContext context, CareerApplicationModel app, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder(context)),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Logo + Category & Location + Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.public,
                  size: 24,
                  color: Color(0xFF059669),
                ),
              ),
              const SizedBox(width: 12),
              // Category & Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: app.category,
                            style: GoogleFonts.manrope(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: const Color(0xFFD97706),
                            ),
                          ),
                          TextSpan(
                            text: ' • ${app.location}',
                            style: GoogleFonts.manrope(
                              fontSize: 10.5,
                              color: AppColors.textTertiary(context),
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      app.company,
                      style: GoogleFonts.libreCaslonText(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.charcoal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: app.getStatusBgColor(context, isDark),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: app.getStatusBorderColor(context, isDark),
                  ),
                ),
                child: Text(
                  app.status,
                  style: GoogleFonts.manrope(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: app.getStatusTextColor(context, isDark),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Job Title
          Text(
            app.title,
            style: GoogleFonts.libreCaslonText(
              fontSize: 15.5,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),

          // Verification Tag
          Row(
            children: [
              const Icon(
                Icons.verified,
                size: 16,
                color: Color(0xFF059669),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${app.appliedDate} • Registrar Transcript Attached',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress Tracker Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder(context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: STAGE X OF Y ... Stage Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'STAGE ${app.currentStage} OF ${app.totalStages}',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: const Color(0xFF059669),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        app.stageName,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 5-Segmented Progress Bar
                Row(
                  children: List.generate(app.totalStages, (index) {
                    Color segColor;
                    if (index < app.currentStage - 1) {
                      segColor = const Color(0xFF059669); // completed
                    } else if (index == app.currentStage - 1) {
                      segColor = const Color(0xFF059669); // active stage
                    } else if (index == app.currentStage) {
                      segColor = const Color(0xFFF59E0B); // next upcoming
                    } else {
                      segColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
                    }

                    return Expanded(
                      child: Container(
                        height: 5,
                        margin: EdgeInsets.only(right: index == app.totalStages - 1 ? 0 : 4),
                        decoration: BoxDecoration(
                          color: segColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),

                // Notes / Checklist items
                if (app.notes.isNotEmpty)
                  ...app.notes.map((note) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.access_time_filled_rounded,
                                size: 14,
                                color: Color(0xFFF59E0B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                note,
                                style: GoogleFonts.manrope(
                                  fontSize: 11.5,
                                  height: 1.4,
                                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),

                if (app.checklist.isNotEmpty)
                  ...app.checklist.map((item) => Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Icon(
                                item.isCompleted
                                    ? Icons.check_circle_rounded
                                    : Icons.calendar_today_rounded,
                                size: 14,
                                color: item.isCompleted
                                    ? const Color(0xFF059669)
                                    : const Color(0xFFF59E0B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.text,
                                style: GoogleFonts.manrope(
                                  fontSize: 11.5,
                                  height: 1.4,
                                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Action Button: View Application Details & Notes ->
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () => _showApplicationDetailModal(context, app, isDark),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF044E3D) : AppColors.emeraldDeep,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Application Details & Notes',
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Career Advisory & Prep Teaser Card (Bottom of Screenshot 4)
  Widget _buildAdvisoryTeaser(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF022C22) : const Color(0xFF043A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF065F46) : const Color(0xFF044E3D),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.school_rounded,
              size: 22,
              color: Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CAREER ADVISORY & PREP',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: const Color(0xFFF59E0B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Book 1-on-1 interview practice with executive alumni mentors.',
                  style: GoogleFonts.manrope(
                    fontSize: 11.5,
                    color: const Color(0xFFF0FDF4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFFF0FDF4),
          ),
        ],
      ),
    );
  }

  /// Comprehensive Dynamic Application Detail & Notes Modal Sheet
  void _showApplicationDetailModal(BuildContext context, CareerApplicationModel app, bool isDark) {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(
              color: AppColors.cardBorder(context),
              width: 1.5,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary(context).withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Modal Header with Badges & Close
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Text(
                          app.category.toUpperCase(),
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ),

                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: app.getStatusBgColor(context, isDark),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: app.getStatusBorderColor(context, isDark),
                          ),
                        ),
                        child: Text(
                          app.status,
                          style: GoogleFonts.manrope(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: app.getStatusTextColor(context, isDark),
                          ),
                        ),
                      ),

                      // Match Score Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF064E3B).withValues(alpha: 0.4) : const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_rounded, size: 12, color: Color(0xFF059669)),
                            const SizedBox(width: 4),
                            Text(
                              '${app.matchScore}% Match',
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF059669),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Get.back(),
                  color: AppColors.textTertiary(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Job Title & Company
                    Text(
                      app.title,
                      style: GoogleFonts.libreCaslonText(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${app.company} • ${app.location}',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Reference Number Card with Copy
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.fingerprint_rounded,
                            size: 16,
                            color: Color(0xFF059669),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Ref: ${app.applicationRef}',
                              style: GoogleFonts.sourceCodePro(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary(context),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: app.applicationRef));
                              Get.snackbar(
                                'Copied to Clipboard',
                                'Reference ${app.applicationRef} copied',
                                snackPosition: SnackPosition.TOP,
                                duration: const Duration(seconds: 2),
                                margin: const EdgeInsets.all(16),
                                backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.black87,
                                colorText: Colors.white,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.copy_rounded,
                                size: 14,
                                color: AppColors.textTertiary(context),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 13,
                            color: AppColors.textTertiary(context),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            app.appliedDate,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section 1: Dynamic Recruitment Pipeline Stepper (STAGE X OF 5)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F1E1B) : const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? const Color(0xFF134E4A) : const Color(0xFFBBF7D0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'STAGE ${app.currentStage} OF ${app.totalStages}',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: AppColors.emeraldDeep,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  app.stageName,
                                  style: GoogleFonts.manrope(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // 5-Segment Progress Bar
                          Row(
                            children: List.generate(app.totalStages, (index) {
                              Color segColor;
                              if (index < app.currentStage - 1) {
                                segColor = const Color(0xFF059669); // completed
                              } else if (index == app.currentStage - 1) {
                                segColor = const Color(0xFF059669); // active stage
                              } else if (index == app.currentStage) {
                                segColor = const Color(0xFFF59E0B); // next stage
                              } else {
                                segColor = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
                              }

                              return Expanded(
                                child: Container(
                                  height: 5,
                                  margin: EdgeInsets.only(right: index == app.totalStages - 1 ? 0 : 4),
                                  decoration: BoxDecoration(
                                    color: segColor,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 12),

                          // Stepper checklist items
                          ...app.checklist.map((item) => Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      item.isCompleted
                                          ? Icons.check_circle_rounded
                                          : (item.isPending ? Icons.pending_rounded : Icons.radio_button_unchecked),
                                      size: 15,
                                      color: item.isCompleted
                                          ? const Color(0xFF059669)
                                          : (item.isPending ? const Color(0xFFF59E0B) : const Color(0xFF94A3B8)),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item.text,
                                        style: GoogleFonts.manrope(
                                          fontSize: 11.5,
                                          fontWeight: item.isCompleted || item.isPending
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section 2: Recruiter Remarks & Review Notes (From API)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.rate_review_rounded,
                                size: 16,
                                color: Color(0xFF059669),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Recruiter Remarks & Review Notes',
                                style: GoogleFonts.manrope(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (app.notes.isNotEmpty) ...[
                            ...app.notes.map((note) => Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.format_quote_rounded,
                                        size: 16,
                                        color: Color(0xFFF59E0B),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          note,
                                          style: GoogleFonts.manrope(
                                            fontSize: 12,
                                            height: 1.4,
                                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ] else ...[
                            Text(
                              'Your application is currently being evaluated by the hiring team. Recruiter feedback notes, assessment milestones, and interview schedules will appear here in real-time as your review progresses.',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                height: 1.45,
                                color: AppColors.textSecondary(context),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section 3: Submitted Candidate Profile Details (From API)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline_rounded,
                                size: 16,
                                color: AppColors.emeraldDeep,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Submitted Candidate Profile',
                                style: GoogleFonts.manrope(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildDetailRow(
                            context,
                            'Candidate Name',
                            app.candidateName ?? 'Verified Alumnus',
                            isDark,
                          ),
                          _buildDetailRow(
                            context,
                            'Academic Degree',
                            '${app.degree ?? 'B.Sc. Applied Degree'}${app.gradYear != null ? ' (Class of ${app.gradYear})' : ''}',
                            isDark,
                          ),
                          if (app.faculty != null && app.faculty!.isNotEmpty)
                            _buildDetailRow(
                              context,
                              'Faculty / Dept',
                              app.faculty!,
                              isDark,
                            ),
                          if (app.experienceYears != null)
                            _buildDetailRow(
                              context,
                              'Experience',
                              '${app.experienceYears} Years relevant industry experience',
                              isDark,
                            ),
                          if (app.candidateEmail != null && app.candidateEmail!.isNotEmpty)
                            _buildDetailRow(
                              context,
                              'Email',
                              app.candidateEmail!,
                              isDark,
                            ),
                          if (app.candidatePhone != null && app.candidatePhone!.isNotEmpty)
                            _buildDetailRow(
                              context,
                              'Phone',
                              app.candidatePhone!,
                              isDark,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section 4: Submitted Documents & Pitch (From API)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.folder_shared_outlined,
                                size: 16,
                                color: Color(0xFF059669),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Institutional Documents & Attachments',
                                style: GoogleFonts.manrope(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Registrar Verified Seal
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0F1E1B) : const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.verified_rounded, size: 18, color: Color(0xFF059669)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'USL Registrar Official Transcript',
                                        style: GoogleFonts.manrope(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? const Color(0xFFD1FAE5) : const Color(0xFF065F46),
                                        ),
                                      ),
                                      Text(
                                        'Digitally verified & sealed via IPAM USL secure alumni API.',
                                        style: GoogleFonts.manrope(
                                          fontSize: 11,
                                          color: isDark ? const Color(0xFFA7F3D0) : const Color(0xFF047857),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // CV Document Row
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0F172A) : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.picture_as_pdf_rounded, size: 18, color: Colors.redAccent),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    app.cvFileName ?? 'Alumni_Curriculum_Vitae.pdf',
                                    style: GoogleFonts.manrope(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary(context),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF059669).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Attached',
                                    style: GoogleFonts.manrope(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF059669),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Cover Note Pitch (if present)
                          if (app.coverNote != null && app.coverNote!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Candidate Cover Pitch',
                                    style: GoogleFonts.manrope(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textSecondary(context),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '"${app.coverNote}"',
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      height: 1.4,
                                      color: AppColors.textPrimary(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section 5: Scheduled Interview or Offer Banner (if present from API)
                    if (app.interviewDate != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF022C22) : const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? const Color(0xFF065F46) : const Color(0xFF6EE7B7),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month_rounded, size: 24, color: Color(0xFF059669)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Interview Confirmed',
                                    style: GoogleFonts.manrope(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF065F46),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Scheduled for ${app.interviewDate!.day}/${app.interviewDate!.month}/${app.interviewDate!.year} • Please review meeting invite sent to your verified email.',
                                    style: GoogleFonts.manrope(
                                      fontSize: 11.5,
                                      color: const Color(0xFF047857),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (app.offerSalary != null && app.offerSalary!.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? const Color(0xFF3730A3) : const Color(0xFFC7D2FE),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.workspace_premium_rounded, size: 24, color: Color(0xFF4F46E5)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Official Placement Offer Extended',
                                    style: GoogleFonts.manrope(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF3730A3),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Compensation: ${app.offerSalary} • Contract documentation transmitted for digital signature.',
                                    style: GoogleFonts.manrope(
                                      fontSize: 11.5,
                                      color: const Color(0xFF4338CA),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),

            // Action Button
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emeraldDeep,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: Text(
                  'Dismiss',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 11.5,
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
