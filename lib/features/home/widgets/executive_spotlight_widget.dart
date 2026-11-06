import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/council_leader_model.dart';
import '../../../core/theme/app_colors.dart';

class ExecutiveSpotlightWidget extends StatelessWidget {
  final List<CouncilLeaderModel> leaders;
  final VoidCallback? onAllLeadersTap;
  final ValueChanged<CouncilLeaderModel>? onReadBio;
  final ValueChanged<CouncilLeaderModel>? onLeaderTap;

  const ExecutiveSpotlightWidget({
    super.key,
    required this.leaders,
    this.onAllLeadersTap,
    this.onReadBio,
    this.onLeaderTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.military_tech_rounded,
                    color: isDark ? AppColors.goldWarm : const Color(0xFFB45309),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Executive Council Spotlight',
                      style: GoogleFonts.libreCaslonText(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: onAllLeadersTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'All Leaders',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Horizontal Leader Cards
        if (leaders.isEmpty)
          Container(
            height: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
            ),
            child: Text(
              'No council leaders featured at this time.',
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: AppColors.textSecondary(context),
              ),
            ),
          )
        else
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: leaders.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final leader = leaders[index];
                return _buildLeaderCard(context, leader);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildLeaderCard(BuildContext context, CouncilLeaderModel leader) {
    final isDark = AppColors.isDark(context);

    return InkWell(
      onTap: () => (onLeaderTap ?? onReadBio)?.call(leader),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 185,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
          boxShadow: AppColors.cardShadow(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Avatar with Gold Star Badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cardBorder(context), width: 2),
                    image: DecorationImage(
                      image: NetworkImage(leader.avatarUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppColors.goldWarm,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                ),
              ],
            ),
            // Name, Role & Class
            Column(
              children: [
                Text(
                  leader.name,
                  style: GoogleFonts.libreCaslonText(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  leader.role,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  leader.classYear,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    color: AppColors.textSecondary(context),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            // Read Bio Button
            SizedBox(
              width: double.infinity,
              height: 34,
              child: InkWell(
                onTap: () => onReadBio?.call(leader),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.tealPillBg(context),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColors.tealPillBorder(context), width: 0.8),
                  ),
                  child: Center(
                    child: Text(
                      'Read Bio',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
