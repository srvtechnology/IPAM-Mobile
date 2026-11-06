import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class CampusBannerWidget extends StatelessWidget {
  final VoidCallback? onDirectionsTap;

  const CampusBannerWidget({
    super.key,
    this.onDirectionsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
        boxShadow: AppColors.cardShadow(context),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campus Hero Area
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? null : AppColors.card(context),
                gradient: isDark
                    ? const LinearGradient(
                        colors: [
                          Color(0xFF131D31),
                          Color(0xFF0F172A),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.goldWarm : AppColors.goldLight,
                      borderRadius: BorderRadius.circular(14),
                      border: isDark ? null : Border.all(color: AppColors.goldWarm.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: isDark ? AppColors.charcoal : AppColors.goldWarm,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Tower Hill, Freetown',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.charcoal : AppColors.goldWarm,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Visit IPAM Tower Hill Freetown',
                    style: GoogleFonts.libreCaslonText(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'The epicenter of administrative governance and finance education.',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppColors.textSecondary(context),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Footer Strip
            InkWell(
              onTap: onDirectionsTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  border: Border(
                    top: BorderSide(
                      color: AppColors.cardBorder(context),
                      width: 1.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.school_outlined,
                            color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'University of Sierra Leone',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Directions & Hours',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
