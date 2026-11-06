import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_service.dart';
import '../../../core/network/auth_storage_service.dart';
import '../../profile/widgets/profile_avatar_view.dart';

class EventsHeaderWidget extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const EventsHeaderWidget({
    super.key,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeService = Get.isRegistered<ThemeService>() ? Get.find<ThemeService>() : null;
    final isDark = AppColors.isDark(context);
    final authUser = Get.isRegistered<AuthStorageService>()
        ? Get.find<AuthStorageService>().user
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Top Institutional Navigation Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: Crest & Title
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.emeraldDarker, AppColors.emeraldDeep],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: AppColors.goldWarm, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.emeraldDeep.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.school_rounded,
                      color: AppColors.goldLight,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IPAM Alumni',
                      style: GoogleFonts.libreCaslonText(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.charcoal,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'USL • TOWER HILL',
                      style: GoogleFonts.manrope(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: AppColors.goldWarm,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Right: Actions (Theme Toggle, Bell, Profile Avatar)
            Row(
              children: [
                // Theme Toggle
                if (themeService != null)
                  IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                      color: isDark ? Colors.white : AppColors.charcoal,
                      size: 22,
                    ),
                    tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                    onPressed: () => themeService.toggleTheme(),
                  ),
                // Notification Bell with Alert Dot
                IconButton(
                  onPressed: onNotificationTap,
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                        color: isDark ? Colors.white : AppColors.charcoal,
                        size: 24,
                      ),
                      Positioned(
                        top: -1,
                        right: -1,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.goldWarm,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                // Avatar with Verified Ring
                GestureDetector(
                  onTap: onProfileTap,
                  child: ProfileAvatarView(
                    avatarUrl: authUser?.avatarUrl ?? '',
                    name: authUser?.fullName ?? 'Alumni',
                    username: authUser?.email,
                    size: 36,
                    borderWidth: 1.8,
                    borderColor: isDark ? AppColors.darkTealPillText : AppColors.jadeAccent,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 18),

        // 2. USL Convocation & Events Badge + Global Directorate Subtext
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkTealPillBg : const Color(0xFFE6F4EA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkTealPillBorder : const Color(0xFFA7F3D0),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Color(0xFF059669),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 11,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'USL CONVOCATION & EVENTS',
                    style: GoogleFonts.manrope(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '• Global Directorate',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 3. Main Title: Alumni Gatherings & Summits
        Text(
          'Alumni Gatherings & Summits',
          style: GoogleFonts.libreCaslonText(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: AppColors.textPrimary(context),
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),

        // 4. Subtitle
        Text(
          'Connect with fellow alumni at worldwide galas, professional development webinars, and regional chapter meetups.',
          style: GoogleFonts.manrope(
            fontSize: 13,
            color: AppColors.textSecondary(context),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 14),

        // 5. Stats Row: 3 Upcoming | 12 Chapters | Free & Paid Passes
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              // 3 Upcoming Pill
              _buildStatPill(
                context,
                iconWidget: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
                label: '3 Upcoming',
                isDark: isDark,
              ),
              const SizedBox(width: 8),

              // 12 Chapters Pill
              _buildStatPill(
                context,
                iconWidget: const Icon(
                  Icons.public_rounded,
                  size: 14,
                  color: Color(0xFFF59E0B),
                ),
                label: '12 Chapters',
                isDark: isDark,
              ),
              const SizedBox(width: 8),

              // Free & Paid Passes Pill
              _buildStatPill(
                context,
                iconWidget: const Icon(
                  Icons.confirmation_number_outlined,
                  size: 14,
                  color: Color(0xFF059669),
                ),
                label: 'Free & Paid Passes',
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatPill(
    BuildContext context, {
    required Widget iconWidget,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}
