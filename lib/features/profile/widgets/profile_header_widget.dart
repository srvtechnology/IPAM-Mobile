import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_service.dart';
import 'profile_avatar_view.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onThemeToggle;
  final String? avatarUrl;
  final String? userName;

  const ProfileHeaderWidget({
    super.key,
    this.onNotificationTap,
    this.onThemeToggle,
    this.avatarUrl,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final themeService = Get.isRegistered<ThemeService>() ? ThemeService.to : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Institutional Top App Bar Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: Crest & Institution Name
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF022C22),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.6),
                      width: 1.5,
                    ),
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

            // Right: Theme Toggle + Bell with Dot + Avatar
            Row(
              children: [
                // Extra Theme Toggle Button
                IconButton(
                  icon: Icon(
                    isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                    color: isDark ? Colors.white : AppColors.charcoal,
                    size: 22,
                  ),
                  tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                  onPressed: onThemeToggle ?? () => themeService?.toggleTheme(),
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

                // Avatar with Emerald Ring
                ProfileAvatarView(
                  avatarUrl: avatarUrl ?? '',
                  name: userName ?? 'User',
                  size: 36,
                  borderWidth: 2.0,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 2. Synchronized Registrar Archives Banner Pill
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF042F2C).withValues(alpha: 0.5)
                : const Color(0xFFE6F4EA),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF065F46).withValues(alpha: 0.9)
                  : const Color(0xFFA7F3D0),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Shield Icon + Text
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          color: Color(0xFF022C22),
                          size: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'USL REGISTRAR ARCHIVES • SYNCHRONIZED',
                        style: GoogleFonts.manrope(
                          fontSize: 9.8,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                          color: isDark
                              ? const Color(0xFF34D399)
                              : const Color(0xFF044E3D),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Right: Verified Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF064E3B)
                      : const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF10B981).withValues(alpha: 0.4)
                        : const Color(0xFF6EE7B7),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  'Verified',
                  style: GoogleFonts.manrope(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFF34D399)
                        : const Color(0xFF044E3D),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
