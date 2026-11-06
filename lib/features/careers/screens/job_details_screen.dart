import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/job_details_controller.dart';
import '../models/career_job_model.dart';
import '../../../core/theme/app_colors.dart';

class JobDetailsScreen extends GetView<JobDetailsController> {
  const JobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<JobDetailsController>()) {
      Get.put(JobDetailsController());
    }

    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top App Bar: Back arrow, Title, Subtitle, Share
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: _buildAppBar(context, isDark),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Obx(() {
                  final job = controller.job.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Corporate Partner Direct Hiring Channel Banner Card (Image 2)
                      _buildDirectHiringBanner(context, isDark),
                      const SizedBox(height: 14),

                      // 3. Main Header Job Card (Image 2)
                      _buildMainJobCard(context, isDark, job),
                      const SizedBox(height: 16),

                      // 4. Alumni Insider Network Card (Image 3)
                      _buildAlumniInsiderCard(context, isDark, job),
                      const SizedBox(height: 22),

                      // 5. Overview & Impact Section (Image 3)
                      _buildSectionTitle(
                        context,
                        title: 'Overview & Impact',
                        icon: Icons.architecture_rounded,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),
                      _buildOverviewCard(context, isDark, job),
                      const SizedBox(height: 22),

                      // 6. Key Responsibilities Section (Image 4)
                      _buildSectionTitle(
                        context,
                        title: 'Key Responsibilities',
                        icon: Icons.task_alt_rounded,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),
                      _buildResponsibilitiesCard(context, isDark, job),
                      const SizedBox(height: 22),

                      // 7. Requirements & Qualifications Section (Image 4)
                      _buildSectionTitle(
                        context,
                        title: 'Requirements & Qualifications',
                        icon: Icons.verified_user_outlined,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),
                      _buildRequirementsCard(context, isDark, job),
                      const SizedBox(height: 22),

                      // 8. Benefits & Alumni Perks Section (Image 4)
                      _buildSectionTitle(
                        context,
                        title: 'Benefits & Alumni Perks',
                        icon: Icons.card_giftcard_rounded,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),
                      _buildBenefitsCard(context, isDark, job),
                      const SizedBox(height: 30),
                    ],
                  );
                }),
              ),
            ),

            // 9. Sticky Bottom Action Bar (Image 2, 3, 4)
            _buildStickyBottomBar(context, isDark),
          ],
        ),
      ),
    );
  }

  // --- 1. Top App Bar ---
  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
            size: 24,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Job Details',
                style: GoogleFonts.libreCaslonText(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'IPAM USL • ALUMNI NETWORK',
                style: GoogleFonts.manrope(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: controller.shareJob,
          icon: Icon(
            Icons.share_outlined,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
            size: 22,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  // --- 2. Corporate Partner Direct Hiring Channel Banner Card ---
  Widget _buildDirectHiringBanner(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_rounded,
            color: Color(0xFF10B981),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'IPAM Corporate Partner • Direct Hiring Channel',
              style: GoogleFonts.manrope(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF044E3D),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1728) : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? const Color(0xFF78350F) : const Color(0xFFFDE68A),
                width: 0.8,
              ),
            ),
            child: Text(
              'PRIORITY REVIEW',
              style: GoogleFonts.manrope(
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: const Color(0xFFD97706),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. Main Header Job Card ---
  Widget _buildMainJobCard(BuildContext context, bool isDark, CareerJobModel job) {
    final logoText = job.logoText.isNotEmpty
        ? job.logoText
        : (job.company.length > 4 ? job.company.substring(0, 4).toUpperCase() : job.company.toUpperCase());

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
        boxShadow: AppColors.cardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Logo & Category / Verified Partner
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0B132B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Center(
                  child: Text(
                    logoText,
                    style: GoogleFonts.libreCaslonText(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFFFBBF24) : AppColors.emeraldDeep,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            job.category.toUpperCase(),
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text('•', style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                        const SizedBox(width: 6),
                        Text(
                          'Verified Partner',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFF59E0B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.title,
                      style: GoogleFonts.libreCaslonText(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.company,
                      style: GoogleFonts.manrope(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Meta Info: Location, Stipend/Salary, Application Close Date
          _buildMetaRow(
            icon: Icons.location_on_outlined,
            text: '${job.location} • ${job.employmentType}',
            iconColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            textColor: AppColors.textSecondary(context),
          ),
          const SizedBox(height: 8),

          _buildMetaRow(
            icon: Icons.payments_outlined,
            text: job.salary.isNotEmpty ? job.salary : 'International Post USD Stipend',
            iconColor: const Color(0xFF10B981),
            textColor: isDark ? const Color(0xFF10B981) : const Color(0xFF044E3D),
            isBold: true,
          ),
          const SizedBox(height: 8),

          _buildMetaRow(
            icon: Icons.calendar_today_outlined,
            text: 'Applications close ${job.deadline.isNotEmpty ? job.deadline : 'Dec 15, 2026'}',
            iconColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            textColor: AppColors.textSecondary(context),
          ),
          const SizedBox(height: 16),

          // Badges Row: USL Alumni Preferred, Company Badge, Top Employer
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildBadgePill(
                context,
                icon: Icons.school_rounded,
                text: job.preferenceBadge.isNotEmpty ? job.preferenceBadge : 'USL Alumni Preferred',
                bgColor: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                borderColor: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
                textColor: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
              ),
              _buildBadgePill(
                context,
                icon: Icons.account_balance_wallet_outlined,
                text: job.companyBadge ?? 'Orange Money Core Team',
                bgColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderColor: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                textColor: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
              ),
              _buildBadgePill(
                context,
                icon: Icons.military_tech_rounded,
                text: 'Top Employer',
                bgColor: isDark ? const Color(0xFF451A03) : const Color(0xFFFEF3C7),
                borderColor: isDark ? const Color(0xFF78350F) : const Color(0xFFFDE68A),
                textColor: isDark ? const Color(0xFFF59E0B) : const Color(0xFFB45309),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 4. Alumni Insider Network Card (Image 3) ---
  Widget _buildAlumniInsiderCard(BuildContext context, bool isDark, CareerJobModel job) {
    final count = job.alumniCount > 0 ? job.alumniCount : 5;
    final otherCount = count > 1 ? count - 1 : 3;
    final leadName = (job.leadAlumniName != null && job.leadAlumniName!.isNotEmpty)
        ? job.leadAlumniName!
        : 'David Okoro';
    final leadRole = (job.leadAlumniRole != null && job.leadAlumniRole!.isNotEmpty)
        ? job.leadAlumniRole!
        : 'Class of 2010, Lead Consultant';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.group_rounded,
                    color: Color(0xFFF59E0B),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ALUMNI INSIDER NETWORK',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: isDark ? Colors.white : const Color(0xFF044E3D),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF064E3B) : const Color(0xFFA7F3D0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count Active',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF34D399) : const Color(0xFF022C22),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            '$count IPAM Alumni currently work here in ${job.category.isNotEmpty ? job.category : 'Tech & Engineering'}.',
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: isDark ? Colors.white.withValues(alpha: 0.95) : const Color(0xFF064E3B),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),

          // Lead alumni connection avatar & name
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: isDark ? const Color(0xFF065F46) : const Color(0xFF059669),
                child: Text(
                  '+1',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$leadName ($leadRole) & $otherCount ...',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Request Alumni Referral Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () => controller.requestReferral(context),
              icon: const Icon(Icons.handshake_outlined, size: 19),
              label: Text(
                'Request Alumni Referral',
                style: GoogleFonts.manrope(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 5. Overview & Impact Section ---
  Widget _buildOverviewCard(BuildContext context, bool isDark, CareerJobModel job) {
    final description = job.description.isNotEmpty
        ? job.description
        : 'Conduct empirical econometrics studies to evaluate infrastructural loans and microfinance equity funds for climate adaptation in West Africa.';
    final stat1 = job.statDailyTxns ?? '2.4M+';
    final stat2 = job.statUptime ?? '99.98%';
    final stat3 = job.statSecurity ?? 'Tier 1';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: AppColors.textSecondary(context),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),

          // 3 Metric Stat Boxes
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(stat1, 'Daily Txns', isDark),
                _buildVerticalDivider(isDark),
                _buildStatColumn(stat2, 'Uptime SLA', isDark),
                _buildVerticalDivider(isDark),
                _buildStatColumn(stat3, 'Bank Security', isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 6. Key Responsibilities Section (Image 4) ---
  Widget _buildResponsibilitiesCard(BuildContext context, bool isDark, CareerJobModel job) {
    final responsibilities = job.responsibilities.isNotEmpty
        ? job.responsibilities
        : (job.requirements.isNotEmpty
            ? job.requirements
            : [
                'Author policy reports and academic research papers on African economic integration.',
                'Coordinate with regional banking authorities and ministerial stakeholders.',
                'Formulate empirical econometric models to forecast trade liquidity and public debt trends.',
              ]);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
      ),
      child: Column(
        children: responsibilities
            .map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF10B981),
                        size: 19,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: AppColors.textPrimary(context),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  // --- 7. Requirements & Qualifications Section (Image 4) ---
  Widget _buildRequirementsCard(BuildContext context, bool isDark, CareerJobModel job) {
    final requirementsList = job.requirements.isNotEmpty
        ? job.requirements
        : [
            'Degree: M.Sc. or First Class B.Sc. from IPAM USL in Economics, Statistics, or Finance.',
            'Minimum 3+ years demonstrable analytical experience in financial sector modeling or policy analysis.',
            'Proficiency with R, Stata, Python, or SQL for empirical econometric modeling.',
          ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
      ),
      child: Column(
        children: requirementsList
            .map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF59E0B),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: AppColors.textPrimary(context),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  // --- 8. Benefits & Alumni Perks Section (Image 4) ---
  Widget _buildBenefitsCard(BuildContext context, bool isDark, CareerJobModel job) {
    final perks = job.benefits.isNotEmpty
        ? job.benefits.asMap().entries.map((entry) {
            final idx = entry.key;
            final text = entry.value;
            final icons = [
              Icons.workspace_premium_rounded,
              Icons.laptop_chromebook_rounded,
              Icons.flight_takeoff_rounded,
            ];
            final colors = [
              const Color(0xFF10B981),
              const Color(0xFF3B82F6),
              const Color(0xFFF59E0B),
            ];
            final title = text.contains(':')
                ? text.split(':').first.trim()
                : (text.length > 28 ? text.substring(0, 28) : text);
            final desc = text.contains(':')
                ? text.split(':').sublist(1).join(':').trim()
                : text;
            return {
              'icon': icons[idx % icons.length],
              'title': title,
              'desc': desc,
              'color': colors[idx % colors.length],
            };
          }).toList()
        : [
            {
              'icon': Icons.workspace_premium_rounded,
              'title': 'Multilateral Benefits',
              'desc': 'Tax-exempt international status, housing allowance, comprehensive global healthcare for alumni.',
              'color': const Color(0xFF10B981),
            },
            {
              'icon': Icons.laptop_chromebook_rounded,
              'title': 'Tech & Equipment Grant',
              'desc': 'Annual hardware allowance, professional development stipends, and USL library access.',
              'color': const Color(0xFF3B82F6),
            },
            {
              'icon': Icons.flight_takeoff_rounded,
              'title': 'Relocation Assistance',
              'desc': 'Full expatriate relocation stipend, visa sponsorship, and family resettlement allowance.',
              'color': const Color(0xFFF59E0B),
            },
          ];

    return Column(
      children: perks.map((perk) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card(context),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: (perk['color'] as Color).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  perk['icon'] as IconData,
                  color: perk['color'] as Color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      perk['title'] as String,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      perk['desc'] as String,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AppColors.textSecondary(context),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // --- 9. Sticky Bottom Action Bar (Image 2, 3, 4) ---
  Widget _buildStickyBottomBar(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        border: Border(
          top: BorderSide(color: AppColors.cardBorder(context), width: 1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Obx(() {
        final applied = controller.isApplied.value;
        final bookmarked = controller.isBookmarked.value;
        final submitting = controller.isSubmitting.value;

        return Row(
          children: [
            // Bookmark Icon Button
            InkWell(
              onTap: controller.toggleBookmark,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                  ),
                ),
                child: Icon(
                  bookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: bookmarked ? const Color(0xFFF59E0B) : (isDark ? Colors.white : const Color(0xFF475569)),
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Main Apply CTA Button
            Expanded(
              child: SizedBox(
                height: 48,
                child: applied
                    // Applied with IPAM ID ✓ State (Exact match to images 2, 3, 4)
                    ? Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF044E3D),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF10B981), width: 1.2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.done_all_rounded,
                              color: Color(0xFF34D399),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Applied with IPAM ID ✓',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    // Quick Apply State
                    : ElevatedButton.icon(
                        onPressed: submitting ? null : controller.apply,
                        icon: submitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.bolt_rounded, size: 20),
                        label: Text(
                          submitting ? 'Submitting...' : 'Quick Apply with Verified IPAM Profile',
                          style: GoogleFonts.manrope(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emeraldDeep,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // --- Helpers ---
  Widget _buildSectionTitle(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF10B981),
          size: 21,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.libreCaslonText(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
        ),
      ],
    );
  }

  Widget _buildMetaRow({
    required IconData icon,
    required String text,
    required Color iconColor,
    required Color textColor,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBadgePill(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String val, String label, bool isDark) {
    return Column(
      children: [
        Text(
          val,
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF10B981),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider(bool isDark) {
    return Container(
      width: 1,
      height: 28,
      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
    );
  }
}

