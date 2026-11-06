import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_service.dart';
import '../../../core/network/auth_storage_service.dart';
import '../../profile/widgets/profile_avatar_view.dart';

class CareerHeaderWidget extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const CareerHeaderWidget({
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
                  width: 36,
                  height: 36,
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
                      size: 19,
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
                // Notification Bell with Badge
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

        // 2. USL Career Advancement Service Badge
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
              Icon(
                Icons.verified_outlined,
                color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                size: 15,
              ),
              const SizedBox(width: 6),
              Text(
                'USL CAREER ADVANCEMENT SERVICE',
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
        const SizedBox(height: 10),

        // 3. Main Title
        Text(
          'Alumni Career Portal',
          style: GoogleFonts.libreCaslonText(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.charcoal,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),

        // 4. Subtitle Description
        Text(
          'Exclusive opportunities curated for IPAM USL graduates worldwide, from Freetown to global capitals.',
          style: GoogleFonts.manrope(
            fontSize: 13,
            color: AppColors.textSecondary(context),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
