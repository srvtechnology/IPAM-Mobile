import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/giving_controller.dart';

class MembershipDuesWidget extends GetView<GivingController> {
  const MembershipDuesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Current Active Membership & Dues Card
        Obx(() {
          final status = controller.membershipStatus.value;
          final validDate = status.validUntil != null
              ? DateFormat('MMMM d, y').format(status.validUntil!)
              : 'January 1, 2027';

          return Container(
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
                        'Annual Membership Dues',
                        style: GoogleFonts.libreCaslonText(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.verifiedBg(context),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.tealPillBorder(context)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_rounded,
                              size: 13, color: AppColors.verifiedText(context)),
                          const SizedBox(width: 4),
                          Text(
                            'Active & Paid',
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.verifiedText(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorder(context)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('Annual Contribution',
                                style: GoogleFonts.manrope(
                                    fontSize: 12, color: AppColors.textSecondary(context))),
                          ),
                          const SizedBox(width: 8),
                          Text('\$${status.annualDuesPaid} USD',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.darkTealPillText
                                    : AppColors.emeraldDeep,
                              )),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('Privileges Valid Until',
                                style: GoogleFonts.manrope(
                                    fontSize: 12, color: AppColors.textSecondary(context))),
                          ),
                          const SizedBox(width: 8),
                          Text(validDate,
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary(context),
                              )),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('Auto-Renew Annual Dues',
                                style: GoogleFonts.manrope(
                                    fontSize: 12, color: AppColors.textSecondary(context))),
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: status.autoRenew,
                            activeThumbColor: AppColors.emeraldDarker,
                            onChanged: (val) => controller.toggleAutoRenew(val),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 22),

        // 2. Billing Cycle Toggle (Annual vs Lifetime)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'MEMBERSHIP TIERS & PRIVILEGES',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: AppColors.textSecondary(context),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Obx(
              () => Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    _buildCycleButton(
                      label: 'Annual',
                      isSelected: controller.selectedBillingCycle.value == 'ANNUAL',
                      onTap: () => controller.selectedBillingCycle.value = 'ANNUAL',
                    ),
                    _buildCycleButton(
                      label: 'Lifetime',
                      isSelected: controller.selectedBillingCycle.value == 'LIFETIME',
                      onTap: () => controller.selectedBillingCycle.value = 'LIFETIME',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 3. Tier Options Cards
        Obx(() {
          final tiers = controller.membershipStatus.value.availableTiers;
          final isLifetime = controller.selectedBillingCycle.value == 'LIFETIME';
          final currentTier = controller.membershipStatus.value.currentTier;

          return Column(
            children: tiers.map((tier) {
              final isCurrent = currentTier == tier.key;
              final price = isLifetime ? tier.lifetimePrice : tier.annualPrice;

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.card(context),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isCurrent
                        ? AppColors.emeraldDarker
                        : AppColors.cardBorder(context),
                    width: isCurrent ? 2 : 1.2,
                  ),
                  boxShadow: AppColors.cardShadow(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tier.name,
                                style: GoogleFonts.libreCaslonText(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isLifetime
                                    ? '\$$price One-Time Lifetime'
                                    : (price == 0 ? 'Complimentary' : '\$$price USD / Year'),
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.goldWarm
                                      : const Color(0xFFB45309),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.tealPillBg(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.tealPillBorder(context)),
                            ),
                            child: Text(
                              'Current Tier',
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.tealPillText(context),
                              ),
                            ),
                          )
                        else if (tier.isPopular)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.goldWarm : AppColors.goldLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Popular',
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.charcoal : AppColors.goldWarm,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    // Features List
                    Column(
                      children: tier.features.map((feat) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                size: 16,
                                color: isDark
                                    ? AppColors.darkTealPillText
                                    : AppColors.emeraldDeep,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  feat,
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    color: AppColors.textPrimary(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    if (!isCurrent)
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.emeraldDarker,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => controller.upgradeMembership(tier),
                          child: Text(
                            price == 0 ? 'Select Tier' : 'Upgrade to ${tier.name}',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildCycleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.emeraldDarker : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
