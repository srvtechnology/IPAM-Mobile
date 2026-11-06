import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/career_job_model.dart';
import '../../../core/theme/app_colors.dart';

class CareerJobCardWidget extends StatelessWidget {
  final CareerJobModel job;
  final VoidCallback? onApply;
  final VoidCallback? onBookmark;
  final VoidCallback? onViewDetails;

  const CareerJobCardWidget({
    super.key,
    required this.job,
    this.onApply,
    this.onBookmark,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return InkWell(
      onTap: onViewDetails,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
          boxShadow: AppColors.cardShadow(context),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Row: Company Logo, Name & Verified Check, Bookmark Icon
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCompanyLogo(context),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            job.company,
                            style: GoogleFonts.manrope(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (job.isVerified) ...[
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.verified,
                            color: Color(0xFF059669),
                            size: 15,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      job.title,
                      style: GoogleFonts.libreCaslonText(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                onPressed: onBookmark,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  job.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: job.isBookmarked
                      ? AppColors.goldWarm
                      : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 2. Location
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 15,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  job.location,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3. Badges Row
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              // Full Time Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  job.employmentType,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                  ),
                ),
              ),

              // USL Alumni Preferred Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  job.preferenceBadge,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                  ),
                ),
              ),

              // Salary Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF451A03) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? const Color(0xFF78350F) : const Color(0xFFFDE68A),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  job.salary,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFFBBF24) : const Color(0xFF92400E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 4. Alumni Footer Row: Alumni count & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.people_outline_rounded,
                      size: 16,
                      color: isDark ? AppColors.darkTealPillText : const Color(0xFF059669),
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        '${job.alumniCount} alumni work here',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTealPillText : const Color(0xFF059669),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                job.deadline,
                style: GoogleFonts.manrope(
                  fontSize: 11.5,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 5. Action Row: Quick Apply / Applied Button & Eye Details Button
          Row(
            children: [
              Expanded(
                child: job.isApplied
                    ? Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
                            width: 1.2,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 18,
                              color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Applied with IPAM ID',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ElevatedButton(
                        onPressed: onApply,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emeraldDeep,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.bolt_rounded,
                              size: 18,
                              color: Color(0xFFFBBF24),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Quick Apply with IPAM Profile',
                                style: GoogleFonts.manrope(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              // Eye Button
              InkWell(
                onTap: onViewDetails,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.remove_red_eye_outlined,
                      size: 20,
                      color: isDark ? Colors.white : AppColors.emeraldDeep,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  Widget _buildCompanyLogo(BuildContext context) {
    switch (job.logoType) {
      case 'orange':
        return Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6600),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        );
      case 'ministry':
        return Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: const Center(
            child: Icon(
              Icons.account_balance_rounded,
              color: Color(0xFF044E3D),
              size: 24,
            ),
          ),
        );
      case 'sdp':
        return Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFA7F3D0)),
          ),
          child: Center(
            child: Text(
              'SDP',
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF044E3D),
              ),
            ),
          ),
        );
      case 'slcb':
        return Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF1E3A8A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'SLCB',
              style: GoogleFonts.manrope(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFFBBF24),
              ),
            ),
          ),
        );
      default:
        return Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: job.logoBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              job.logoText,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: job.logoTextColor,
              ),
            ),
          ),
        );
    }
  }
}
