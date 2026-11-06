import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class QuickActionGridWidget extends StatelessWidget {
  final VoidCallback? onDigitalIdTap;
  final VoidCallback? onDirectoryTap;
  final VoidCallback? onCareersTap;
  final VoidCallback? onGivingTap;
  final String? careerBadgeText;
  final String? directoryBadgeText;

  const QuickActionGridWidget({
    super.key,
    this.onDigitalIdTap,
    this.onDirectoryTap,
    this.onCareersTap,
    this.onGivingTap,
    this.careerBadgeText,
    this.directoryBadgeText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final careerBadge = (careerBadgeText != null && careerBadgeText!.isNotEmpty)
        ? careerBadgeText!
        : '3 New';
    final directoryBadge =
        (directoryBadgeText != null && directoryBadgeText!.isNotEmpty)
            ? directoryBadgeText!
            : '15k+';

    return Row(
      children: [
        // Column 1
        Expanded(
          child: Column(
            children: [
              _buildActionCard(
                context: context,
                icon: Icons.badge_outlined,
                iconColor:
                    isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                iconBg: AppColors.tealPillBg(context),
                badgeWidget: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.tealPillBg(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.tealPillBorder(context), width: 0.8),
                  ),
                  child: Text(
                    'Active',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tealPillText(context),
                    ),
                  ),
                ),
                title: 'My Digital ID',
                subtitle: 'Tap to show QR card',
                onTap: onDigitalIdTap,
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context: context,
                icon: Icons.business_center_outlined,
                iconColor: AppColors.orangePillText(context),
                iconBg: AppColors.orangePillBg(context),
                badgeWidget: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.orangePillBg(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.orangePillBorder(context), width: 0.8),
                  ),
                  child: Text(
                    careerBadge,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.orangePillText(context),
                    ),
                  ),
                ),
                title: 'Career Portal',
                subtitle: 'Vacancies posted today',
                onTap: onCareersTap,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Column 2
        Expanded(
          child: Column(
            children: [
              _buildActionCard(
                context: context,
                icon: Icons.person_search_outlined,
                iconColor:
                    isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                iconBg: AppColors.tealPillBg(context),
                badgeWidget: Text(
                  directoryBadge,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                title: 'Directory',
                subtitle: 'Find classmates &\npeers',
                onTap: onDirectoryTap,
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context: context,
                icon: Icons.volunteer_activism_outlined,
                iconColor:
                    isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                iconBg: AppColors.tealPillBg(context),
                badgeWidget: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.textSecondary(context),
                  size: 18,
                ),
                title: 'Giving & Dues',
                subtitle: 'Support IPAM Fund',
                onTap: onGivingTap,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required Widget badgeWidget,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 130,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
          boxShadow: AppColors.cardShadow(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Icon & Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                ),
                badgeWidget,
              ],
            ),
            // Title & Subtitle
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.libreCaslonText(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppColors.textSecondary(context),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
