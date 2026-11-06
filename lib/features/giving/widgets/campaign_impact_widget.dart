import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/giving_controller.dart';
import '../models/donation_record.dart';

class CampaignImpactWidget extends GetView<GivingController> {
  const CampaignImpactWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final percent = (controller.campaignRaised / controller.campaignGoal).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Campaign Goal Progress Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.card(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
            boxShadow: AppColors.cardShadow(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '2026 Endowment Campaign',
                      style: GoogleFonts.libreCaslonText(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(percent * 100).toStringAsFixed(0)}% Funded',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.goldWarm,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 10,
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.emeraldDarker),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Raised',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                      Text(
                        '\$${NumberFormat('#,###').format(controller.campaignRaised)} USD',
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Target Goal',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                      Text(
                        '\$${NumberFormat('#,###').format(controller.campaignGoal)} USD',
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 2. Recent Donors Feed
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'LIVE RECENT DONORS',
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: AppColors.textSecondary(context),
              ),
            ),
            Obx(
              () => Text(
                '${controller.recentDonations.length} Patrons',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Recent Donations Feed List
        Obx(() {
          final list = controller.recentDonations;
          if (list.isEmpty) {
            return const SizedBox();
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final record = list[index];
              return _buildDonorFeedItem(context, record);
            },
          );
        }),
      ],
    );
  }

  Widget _buildDonorFeedItem(BuildContext context, DonationRecord record) {
    final isDark = AppColors.isDark(context);
    final donorDisplay = record.isAnonymous ? 'Anonymous Donor' : record.donorName;
    final timeAgo = DateFormat('MMM d, y').format(record.createdAt);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.tealPillBg(context),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                record.isAnonymous
                    ? Icons.visibility_off_outlined
                    : Icons.person_rounded,
                size: 20,
                color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        donorDisplay,
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '\$${record.amount.toStringAsFixed(0)}',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${record.fund} • $timeAgo',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                if (record.message != null && record.message!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    '“${record.message}”',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
