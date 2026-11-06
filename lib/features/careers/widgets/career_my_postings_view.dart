import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/careers_controller.dart';
import '../models/career_posting_model.dart';
import 'post_vacancy_bottom_sheet.dart';

class CareerMyPostingsView extends GetView<CareersController> {
  final VoidCallback? onBack;
  final VoidCallback? onPostNewJob;
  final bool showAppBar;

  const CareerMyPostingsView({
    super.key,
    this.onBack,
    this.onPostNewJob,
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

        // 2. Badge: USL ALUMNI EMPLOYER PORTAL
        _buildPortalBadge(context, isDark),
        const SizedBox(height: 10),

        // 3. Hero Row: My Posted Jobs + [ + Post New Job ]
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'My Posted Jobs',
                style: GoogleFonts.libreCaslonText(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.charcoal,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: onPostNewJob ?? () => _showPostJobDialog(context, isDark),
              icon: const Icon(Icons.add, size: 16),
              label: Text(
                'Post New Job',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF044E3D) : AppColors.emeraldDeep,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // 4. Subtitle
        Text(
          'Requisitions posted under your verified alumni profile. Manage applications and recruit IPAM graduates.',
          style: GoogleFonts.manrope(
            fontSize: 12.5,
            color: AppColors.textSecondary(context),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 16),

        // 5. 3 Stats Cards: TOTAL POSTED | ACTIVE OPEN | APPLICANTS
        _buildStatsCards(context, isDark),
        const SizedBox(height: 16),

        // 6. Filter Pills: All Postings (2) | Active (2) | Paused (0) | Filled (0)
        _buildFilterPills(context, isDark),
        const SizedBox(height: 16),

        // 7. Postings List
        Obx(() {
          final postings = controller.filteredPostings;

          if (postings.isEmpty) {
            final isFiltering = controller.selectedPostingFilter.value != 'All Postings';
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
                    Icons.business_center_outlined,
                    size: 44,
                    color: AppColors.textTertiary(context),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isFiltering ? 'No Postings in this category' : 'No Requisitions Posted Yet',
                    style: GoogleFonts.libreCaslonText(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isFiltering
                        ? 'Try selecting a different status filter above.'
                        : 'Post a new requisition under your verified alumni profile to recruit qualified IPAM graduates.',
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
                      onPressed: onPostNewJob ?? () => _showPostJobDialog(context, isDark),
                      icon: const Icon(Icons.add, size: 16),
                      label: Text(
                        'Post a New Vacancy',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF044E3D) : AppColors.emeraldDeep,
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
            itemCount: postings.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              return _buildPostingCard(context, postings[index], isDark);
            },
          );
        }),
        if (showAppBar) ...[
          const SizedBox(height: 24),
          // 8. Back to Alumni Career Portal Link (matching Screenshot 3 bottom)
          Center(
            child: TextButton.icon(
              onPressed: onBack ?? () => controller.switchTab('All Jobs'),
              icon: const Icon(Icons.arrow_back, size: 16, color: Color(0xFF059669)),
              label: Text(
                'Back to Alumni Career Portal',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF059669),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ] else ...[
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  /// Top App Bar matching Screenshot 1
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
                'My Posted Jobs',
                style: GoogleFonts.libreCaslonText(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'USL ALUMNI EMPLOYER PORTAL',
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
              'Share Employer Portal',
              'Employer portal requisition link copied to clipboard.',
              snackPosition: SnackPosition.TOP,
            );
          },
        ),
      ],
    );
  }

  /// Portal Badge: USL ALUMNI EMPLOYER PORTAL
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
            'USL ALUMNI EMPLOYER PORTAL',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
              color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
            ),
          ),
        ],
      ),
    );
  }

  /// 3 Stats Cards: TOTAL POSTED | ACTIVE OPEN | APPLICANTS
  Widget _buildStatsCards(BuildContext context, bool isDark) {
    return Obx(
      () => Row(
        children: [
          // TOTAL POSTED (2 roles)
          Expanded(
            child: _buildStatItem(
              context,
              isDark: isDark,
              title: 'TOTAL POSTED',
              value: '${controller.totalPostedCount}',
              unit: 'roles',
              valueColor: isDark ? Colors.white : AppColors.charcoal,
            ),
          ),
          const SizedBox(width: 10),

          // ACTIVE OPEN (2 live)
          Expanded(
            child: _buildStatItem(
              context,
              isDark: isDark,
              title: 'ACTIVE OPEN',
              value: '${controller.activeOpenCount}',
              unit: 'live',
              valueColor: const Color(0xFF059669),
            ),
          ),
          const SizedBox(width: 10),

          // APPLICANTS (4 candidates)
          Expanded(
            child: _buildStatItem(
              context,
              isDark: isDark,
              title: 'APPLICANTS',
              value: '${controller.totalCandidatesCount}',
              unit: 'candidates',
              valueColor: const Color(0xFFD97706),
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
    required String unit,
    required Color valueColor,
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
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: AppColors.textTertiary(context),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: GoogleFonts.libreCaslonText(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                unit,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Filter Pills: All Postings (2) | Active (2) | Paused (0) | Filled (0)
  Widget _buildFilterPills(BuildContext context, bool isDark) {
    return Obx(() {
      final selected = controller.selectedPostingFilter.value;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            _buildFilterPillItem(
              context,
              title: 'All Postings (${controller.totalPostedCount})',
              isSelected: selected == 'All Postings',
              onTap: () => controller.selectPostingFilter('All Postings'),
              isDark: isDark,
            ),
            const SizedBox(width: 8),
            _buildFilterPillItem(
              context,
              title: 'Active (${controller.myPostingsActiveCount})',
              isSelected: selected == 'Active',
              onTap: () => controller.selectPostingFilter('Active'),
              isDark: isDark,
            ),
            const SizedBox(width: 8),
            _buildFilterPillItem(
              context,
              title: 'Paused (${controller.myPostingsPausedCount})',
              isSelected: selected == 'Paused',
              onTap: () => controller.selectPostingFilter('Paused'),
              isDark: isDark,
            ),
            const SizedBox(width: 8),
            _buildFilterPillItem(
              context,
              title: 'Filled (${controller.myPostingsFilledCount})',
              isSelected: selected == 'Filled',
              onTap: () => controller.selectPostingFilter('Filled'),
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

  /// Posted Job Card matching Screenshot 1 & 3
  Widget _buildPostingCard(BuildContext context, CareerPostingModel post, bool isDark) {
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
          // Row 1: Logo + Category & Date + ACTIVE status badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: post.logoBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  post.logoText,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: post.logoTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Category & Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: post.category,
                            style: GoogleFonts.manrope(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: const Color(0xFF059669),
                            ),
                          ),
                          TextSpan(
                            text: ' • ${post.postedDate}',
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
                      post.title,
                      style: GoogleFonts.libreCaslonText(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.charcoal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post.company,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AppColors.textSecondary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // ACTIVE status pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
                  ),
                ),
                child: Text(
                  post.status.toUpperCase(),
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Info Grid (Location, Salary, Deadline, Priority)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder(context)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.location_on_outlined,
                        iconColor: const Color(0xFF059669),
                        text: post.location,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.payments_outlined,
                        iconColor: const Color(0xFF059669),
                        text: post.salary,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.calendar_today_outlined,
                        iconColor: const Color(0xFF64748B),
                        text: post.deadline,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.verified_user_outlined,
                        iconColor: const Color(0xFF059669),
                        text: post.priorityBadge,
                        isDark: isDark,
                        textColor: const Color(0xFF059669),
                        isBold: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Status Control Row: Status: [Active] [Paused] [Filled]  (Eye) View   (Trash)
          Row(
            children: [
              Text(
                'Status: ',
                style: GoogleFonts.manrope(
                  fontSize: 11.5,
                  color: AppColors.textSecondary(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              // Segmented Status Pills
              _buildStatusPill(
                context,
                title: 'Active',
                isSelected: post.status == 'Active',
                onTap: () => controller.updatePostingStatus(post.id, 'Active'),
                isDark: isDark,
              ),
              const SizedBox(width: 4),
              _buildStatusPill(
                context,
                title: 'Paused',
                isSelected: post.status == 'Paused',
                onTap: () => controller.updatePostingStatus(post.id, 'Paused'),
                isDark: isDark,
              ),
              const SizedBox(width: 4),
              _buildStatusPill(
                context,
                title: 'Filled',
                isSelected: post.status == 'Filled',
                onTap: () => controller.updatePostingStatus(post.id, 'Filled'),
                isDark: isDark,
              ),
              const Spacer(),
              // View Button
              InkWell(
                onTap: () => _showJobPostingPreview(context, post, isDark),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        size: 16,
                        color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'View',
                        style: GoogleFonts.manrope(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // Trash Button
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _confirmDeletePosting(context, post),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Footer: Review Candidates dropdown row
          Obx(() {
            final isExpanded = controller.expandedPostingId.value == post.id;

            return Column(
              children: [
                InkWell(
                  onTap: () => controller.togglePostingCandidates(post.id),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.groups_outlined,
                              size: 18,
                              color: Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${post.applicantsCount} ${post.applicantsCount == 1 ? 'Applicant' : 'Applicants'}',
                              style: GoogleFonts.manrope(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.charcoal,
                              ),
                            ),
                            if (post.hasNewApplicants) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'New',
                                  style: GoogleFonts.manrope(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF2563EB),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Review Candidates',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Expanded candidate list
                if (isExpanded) ...[
                  const SizedBox(height: 10),
                  ...post.applicants.map((candidate) => Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.cardBorder(context)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: candidate.avatarUrl.startsWith('http')
                                  ? NetworkImage(candidate.avatarUrl)
                                  : null,
                              backgroundColor: isDark
                                  ? const Color(0xFF065F46)
                                  : const Color(0xFF059669),
                              child: !candidate.avatarUrl.startsWith('http')
                                  ? Text(
                                      candidate.name.isNotEmpty
                                          ? candidate.name[0].toUpperCase()
                                          : 'C',
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    candidate.name,
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : AppColors.charcoal,
                                    ),
                                  ),
                                  Text(
                                    '${candidate.degree} • ${candidate.graduationClass}',
                                    style: GoogleFonts.manrope(
                                      fontSize: 10.5,
                                      color: AppColors.textSecondary(context),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                candidate.status,
                                style: GoogleFonts.manrope(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF059669),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required Color iconColor,
    required String text,
    required bool isDark,
    Color? textColor,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: textColor ?? (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusPill(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white : const Color(0xFF0F172A))
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 10.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? (isDark ? const Color(0xFF0F172A) : Colors.white)
                : AppColors.textSecondary(context),
          ),
        ),
      ),
    );
  }

  void _showJobPostingPreview(BuildContext context, CareerPostingModel post, bool isDark) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                  color: AppColors.textTertiary(context).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              post.title,
              style: GoogleFonts.libreCaslonText(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${post.company} • ${post.location}',
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: AppColors.textSecondary(context),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Compensation: ${post.salary}',
              style: GoogleFonts.manrope(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF059669),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Application Deadline: ${post.deadline}',
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: AppColors.textSecondary(context),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emeraldDeep,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeletePosting(BuildContext context, CareerPostingModel post) {
    Get.defaultDialog(
      title: 'Archive Requisition?',
      middleText: 'Are you sure you want to archive "${post.title}"? Candidates will no longer be able to submit applications.',
      textConfirm: 'Archive',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFDC2626),
      cancelTextColor: AppColors.textPrimary(context),
      onConfirm: () {
        Get.back();
        controller.deletePosting(post.id);
      },
    );
  }

  void _showPostJobDialog(BuildContext context, bool isDark) {
    showPostVacancyBottomSheet(context, controller);
  }
}
