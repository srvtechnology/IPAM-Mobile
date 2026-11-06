import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../models/alumni_model.dart';

class MemberDetailsMetricsGridWidget extends StatelessWidget {
  final AlumniModel alumnus;

  const MemberDetailsMetricsGridWidget({
    super.key,
    required this.alumnus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: Alumni Seniority & Council Leadership
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                icon: Icons.school_outlined,
                iconColor: const Color(0xFF059669),
                iconBgColor: const Color(0xFFE8F7EE),
                value: alumnus.displaySeniority,
                label: 'Alumni Seniority',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                context,
                icon: Icons.military_tech_outlined,
                iconColor: const Color(0xFFD97706),
                iconBgColor: const Color(0xFFFEF3C7),
                value: alumnus.displayCouncilRole,
                label: 'Council Leadership',
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Row 2: Students Mentored & Giving Circle Patron
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                icon: Icons.people_alt_outlined,
                iconColor: const Color(0xFF0891B2),
                iconBgColor: const Color(0xFFE0F2FE),
                value: alumnus.displayFellowsMentored,
                label: 'Students Mentored',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                context,
                icon: Icons.emoji_events_outlined,
                iconColor: const Color(0xFF059669),
                iconBgColor: const Color(0xFFE8F7EE),
                value: alumnus.displayMembershipType,
                label: 'Giving Circle Patron',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String label,
  }) {
    final isDark = AppColors.isDark(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context)),
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
          // Icon Container
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isDark ? iconColor.withValues(alpha: 0.2) : iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 19,
              color: isDark ? (iconColor == const Color(0xFF059669) ? const Color(0xFF34D399) : const Color(0xFFFBBF24)) : iconColor,
            ),
          ),

          const SizedBox(height: 12),

          // Value in Caslon serif bold
          Text(
            value,
            style: GoogleFonts.libreCaslonText(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.charcoal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 3),

          // Label
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
