import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/profile_model.dart';
import '../../../core/theme/app_colors.dart';

class AccountRecordsWidget extends StatelessWidget {
  final ProfileModel profile;
  final VoidCallback? onAcademicTap;
  final VoidCallback? onDuesTap;
  final VoidCallback? onMentorshipTap;
  final VoidCallback? onEventsTap;
  final VoidCallback? onSavedJobsTap;
  final VoidCallback? onPostedJobsTap;
  final VoidCallback? onSecurityTap;
  final VoidCallback? onSignOutTap;

  const AccountRecordsWidget({
    super.key,
    required this.profile,
    this.onAcademicTap,
    this.onDuesTap,
    this.onMentorshipTap,
    this.onEventsTap,
    this.onSavedJobsTap,
    this.onPostedJobsTap,
    this.onSecurityTap,
    this.onSignOutTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Section Header: Account & Records + 7 sections
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Account & Records',
                style: GoogleFonts.libreCaslonText(
                  fontSize: 19.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.charcoal,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '7 sections',
              style: GoogleFonts.manrope(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 2. Grouped Container
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
            boxShadow: AppColors.cardShadow(context),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // 1. Academic Credentials & Transcripts
              _buildTile(
                context,
                icon: Icons.school_outlined,
                iconBg: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                iconColor: const Color(0xFF10B981),
                title: 'Academic Credentials & Transcripts',
                subtitleWidget: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 13,
                      color: Color(0xFF10B981),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Verified by USL Registrar archives',
                        style: GoogleFonts.manrope(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                onTap: onAcademicTap,
              ),
              _buildDivider(isDark),

              // 2. Membership Dues & Giving
              _buildTile(
                context,
                icon: Icons.volunteer_activism_outlined,
                iconBg: isDark ? const Color(0xFF451A03) : const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFF59E0B),
                titleWidget: Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Membership Dues & Giving',
                        style: GoogleFonts.manrope(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.charcoal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        'ACTIVE',
                        style: GoogleFonts.manrope(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: 'Active Donor • \$${profile.duesAmountPaid} Annual Dues Paid',
                onTap: onDuesTap,
              ),
              _buildDivider(isDark),

              // 3. Mentorship Preferences
              _buildTile(
                context,
                icon: Icons.connect_without_contact_outlined,
                iconBg: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                iconColor: const Color(0xFF10B981),
                title: 'Mentorship Preferences',
                subtitle: profile.isMentorAvailable
                    ? 'Available as Mentor for final-year students'
                    : 'Mentorship currently paused',
                subtitleColor: profile.isMentorAvailable
                    ? const Color(0xFF10B981)
                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                onTap: onMentorshipTap,
              ),
              _buildDivider(isDark),

              // 4. My Registered Events & Tickets
              _buildTile(
                context,
                icon: Icons.confirmation_number_outlined,
                iconBg: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                iconColor: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                title: 'My Registered Events & Tickets',
                subtitle: '${profile.registeredEventsCount} upcoming summits & galas',
                trailingBadge: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${profile.registeredEventsCount}',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ),
                onTap: onEventsTap,
              ),
              _buildDivider(isDark),

              // 5. Saved Job Applications
              _buildTile(
                context,
                icon: Icons.work_history_outlined,
                iconBg: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                iconColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                title: 'Saved Job Applications',
                subtitle: '${profile.savedApplicationsCount} applications in review',
                trailingBadge: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${profile.savedApplicationsCount} active',
                    style: GoogleFonts.manrope(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ),
                onTap: onSavedJobsTap,
              ),
              _buildDivider(isDark),

              // 6. My Posted Jobs & Applicants
              _buildTile(
                context,
                icon: Icons.business_center_outlined,
                iconBg: isDark ? const Color(0xFF451A03) : const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFF59E0B),
                title: 'My Posted Jobs & Applicants',
                subtitle: '${profile.postedJobsCount} requisitions posted by you',
                subtitleColor: const Color(0xFFF59E0B),
                trailingBadge: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF451A03) : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${profile.postedJobsCount} roles',
                    style: GoogleFonts.manrope(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                ),
                onTap: onPostedJobsTap,
              ),
              _buildDivider(isDark),

              // 7. Security & Privacy Settings
              _buildTile(
                context,
                icon: Icons.shield_outlined,
                iconBg: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                iconColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                title: 'Security & Privacy Settings',
                subtitle: 'Biometric auth, Directory visibility',
                onTap: onSecurityTap,
              ),
              _buildDivider(isDark),

              // 8. Sign Out
              _buildTile(
                context,
                icon: Icons.logout_rounded,
                iconBg: isDark ? const Color(0xFF450A0A) : const Color(0xFFFEE2E2),
                iconColor: const Color(0xFFEF4444),
                title: 'Sign Out',
                titleColor: const Color(0xFFEF4444),
                subtitle: 'Disconnect session on this mobile device',
                chevronColor: const Color(0xFFEF4444),
                onTap: onSignOutTap,
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // 3. Institutional Footer
        Center(
          child: Column(
            children: [
              Text(
                'INSTITUTE OF PUBLIC ADMINISTRATION AND MANAGEMENT',
                style: GoogleFonts.manrope(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              Text(
                'University of Sierra Leone • Tower Hill, Freetown • Est. 1980',
                style: GoogleFonts.manrope(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    String? title,
    Widget? titleWidget,
    Color? titleColor,
    String? subtitle,
    Widget? subtitleWidget,
    Color? subtitleColor,
    Widget? trailingBadge,
    Color? chevronColor,
    VoidCallback? onTap,
  }) {
    final isDark = AppColors.isDark(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Leading Icon Container
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Middle Column: Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleWidget ??
                      Text(
                        title ?? '',
                        style: GoogleFonts.manrope(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: titleColor ??
                              (isDark ? Colors.white : AppColors.charcoal),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  const SizedBox(height: 3),
                  subtitleWidget ??
                      Text(
                        subtitle ?? '',
                        style: GoogleFonts.manrope(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: subtitleColor ??
                              (isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B)),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                ],
              ),
            ),

            // Trailing: Badge + Chevron
            if (trailingBadge != null) ...[
              trailingBadge,
              const SizedBox(width: 8),
            ],
            Icon(
              Icons.chevron_right_rounded,
              color: chevronColor ??
                  (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: double.infinity,
      height: 1,
      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
    );
  }
}
