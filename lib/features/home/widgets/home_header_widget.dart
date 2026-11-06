import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_service.dart';
import '../../profile/widgets/profile_avatar_view.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String? avatarUrl;
  final String? userName;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const HomeHeaderWidget({
    super.key,
    this.avatarUrl,
    this.userName,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo & Title
          Row(
            children: [
              // Shield / Crest Emblem
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.emeraldDarker,
                  border: Border.all(
                    color: AppColors.goldWarm.withValues(alpha: 0.8),
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
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'IPAM ',
                          style: GoogleFonts.libreCaslonText(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                          ),
                        ),
                        TextSpan(
                          text: 'Alumni',
                          style: GoogleFonts.libreCaslonText(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'USL • TOWER HILL',
                    style: GoogleFonts.manrope(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.goldWarm,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Actions: Theme Toggle + Notification Bell & Profile Avatar
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  color: isDark ? AppColors.goldHighlight : AppColors.charcoal,
                  size: 22,
                ),
                tooltip: isDark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
                onPressed: () {
                  if (Get.isRegistered<ThemeService>()) {
                    ThemeService.to.toggleTheme();
                  } else {
                    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                  }
                },
              ),
              InkWell(
                onTap: onNotificationTap,
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: isDark ? Colors.white70 : const Color(0xFF475569),
                        size: 24,
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: AppColors.goldWarm,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.background(context),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: onProfileTap,
                borderRadius: BorderRadius.circular(20),
                child: ProfileAvatarView(
                  avatarUrl: avatarUrl ?? '',
                  name: userName ?? 'Alumni',
                  username: userName,
                  size: 36,
                  borderWidth: 1.5,
                  borderColor: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
