import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/giving_controller.dart';
import '../models/donation_record.dart';

class GivingLedgerWidget extends GetView<GivingController> {
  const GivingLedgerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tax Summary Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder(context)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.receipt_long_rounded,
                size: 26,
                color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tax-Deductible Contribution Ledger',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'All gifts made to USL IPAM Endowment are eligible for educational tax write-offs.',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AppColors.textSecondary(context),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // List Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'MY GIVING HISTORY',
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: AppColors.textSecondary(context),
              ),
            ),
            Obx(
              () => Text(
                '${controller.myDonations.length} Contributions',
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

        // Donations List
        Obx(() {
          final list = controller.myDonations;
          if (list.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.card(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder(context)),
              ),
              child: Column(
                children: [
                  Icon(Icons.volunteer_activism_outlined,
                      size: 36, color: AppColors.textSecondary(context)),
                  const SizedBox(height: 8),
                  Text(
                    'No donations recorded yet.',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your contributions to IPAM endowment funds will appear here.',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final record = list[index];
              return _buildDonationCard(context, record);
            },
          );
        }),
      ],
    );
  }

  Widget _buildDonationCard(BuildContext context, DonationRecord record) {
    final isDark = AppColors.isDark(context);
    final dateStr = DateFormat('MMM d, y • h:mm a').format(record.createdAt);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
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
                  record.fund,
                  style: GoogleFonts.libreCaslonText(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '\$${record.amount.toStringAsFixed(0)} ${record.currency}',
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateStr,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: AppColors.textSecondary(context),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.tealPillBg(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  record.status,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.tealPillText(context),
                  ),
                ),
              ),
            ],
          ),
          if (record.message != null && record.message!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              '“${record.message}”',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: AppColors.textPrimary(context),
              ),
            ),
          ],
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ref: ${record.paymentRef ?? "DON-2026-9812"}',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: AppColors.textSecondary(context),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.snackbar(
                    'Receipt Downloaded',
                    'Tax receipt for ${record.fund} (\$${record.amount.toStringAsFixed(0)}) saved.',
                    backgroundColor: AppColors.emeraldDarker,
                    colorText: Colors.white,
                  );
                },
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    children: [
                      Icon(Icons.download_rounded,
                          size: 14,
                          color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep),
                      const SizedBox(width: 4),
                      Text(
                        'Tax Receipt',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
