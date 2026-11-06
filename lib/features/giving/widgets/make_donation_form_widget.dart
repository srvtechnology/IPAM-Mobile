import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/giving_controller.dart';

class MakeDonationFormWidget extends GetView<GivingController> {
  const MakeDonationFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

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
          // Section Title
          Text(
            'Support an Endowment Fund',
            style: GoogleFonts.libreCaslonText(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Direct your philanthropic gift toward campus priorities and scholarships.',
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: AppColors.textSecondary(context),
            ),
          ),
          const SizedBox(height: 18),

          // 1. Target Fund Selector
          Text(
            'SELECT TARGET ENDOWMENT FUND',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: AppColors.textSecondary(context),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder(context)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.selectedFund.value,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  dropdownColor: AppColors.card(context),
                  items: controller.fundsList.map((fund) {
                    return DropdownMenuItem<String>(
                      value: fund,
                      child: Text(
                        fund,
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) controller.selectedFund.value = val;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 2. Donation Amount Presets + Custom
          Text(
            'SELECT GIFT AMOUNT (USD)',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: AppColors.textSecondary(context),
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            final selected = controller.selectedAmount.value;
            final isCustom = controller.isCustomAmount.value;

            return Row(
              children: controller.amountPresets.map((amount) {
                final isSelected = !isCustom && selected == amount;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () => controller.selectAmountPreset(amount),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.emeraldDarker
                              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.emeraldDarker
                                : AppColors.cardBorder(context),
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          '\$${amount.toStringAsFixed(0)}',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary(context),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 10),
          // Custom Amount Field
          TextField(
            controller: controller.customAmountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
            decoration: InputDecoration(
              hintText: 'Or enter custom amount in USD...',
              hintStyle: GoogleFonts.manrope(
                fontSize: 13,
                color: AppColors.textSecondary(context),
              ),
              prefixIcon: const Icon(Icons.attach_money_rounded, size: 20),
              filled: true,
              fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.cardBorder(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.cardBorder(context)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                  width: 1.5,
                ),
              ),
            ),
            onChanged: controller.setCustomAmount,
          ),
          const SizedBox(height: 20),

          // 3. Frequency: One-Time vs Monthly
          Text(
            'FREQUENCY',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: AppColors.textSecondary(context),
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            final freq = controller.selectedFrequency.value;
            return Row(
              children: [
                Expanded(
                  child: _buildFrequencyOption(
                    context: context,
                    label: 'One-Time Gift',
                    isSelected: freq == 'ONE_TIME',
                    onTap: () => controller.selectedFrequency.value = 'ONE_TIME',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildFrequencyOption(
                    context: context,
                    label: 'Monthly Giving',
                    isSelected: freq == 'MONTHLY',
                    onTap: () => controller.selectedFrequency.value = 'MONTHLY',
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 20),

          // 4. Payment Method
          Text(
            'PAYMENT METHOD',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: AppColors.textSecondary(context),
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            final method = controller.selectedPaymentMethod.value;
            const methods = [
              {'key': 'CARD', 'label': 'Credit / Debit', 'icon': Icons.credit_card_rounded},
              {'key': 'MOMO', 'label': 'Mobile Money', 'icon': Icons.phone_android_rounded},
              {'key': 'BANK', 'label': 'Bank Wire', 'icon': Icons.account_balance_rounded},
            ];

            return Row(
              children: methods.map((m) {
                final isSelected = method == m['key'];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: InkWell(
                      onTap: () => controller.selectedPaymentMethod.value = m['key'] as String,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.tealPillBg(context)
                              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.tealPillBorder(context)
                                : AppColors.cardBorder(context),
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              m['icon'] as IconData,
                              size: 18,
                              color: isSelected
                                  ? (isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep)
                                  : AppColors.textSecondary(context),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              m['label'] as String,
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? (isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep)
                                    : AppColors.textSecondary(context),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 16),

          // 5. Anonymous Donor Toggle
          Obx(
            () => InkWell(
              onTap: () => controller.isAnonymous.toggle(),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: controller.isAnonymous.value,
                        activeColor: AppColors.emeraldDarker,
                        onChanged: (v) => controller.isAnonymous.value = v ?? false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Keep my gift anonymous on public campaign feeds',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 6. Dedication Note
          TextField(
            controller: controller.messageController,
            maxLines: 2,
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: AppColors.textPrimary(context),
            ),
            decoration: InputDecoration(
              hintText: 'Add an optional dedication or tribute note...',
              hintStyle: GoogleFonts.manrope(
                fontSize: 12,
                color: AppColors.textSecondary(context),
              ),
              filled: true,
              fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.cardBorder(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.cardBorder(context)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),

          // 7. Submit Button
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emeraldDarker,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: controller.isSubmittingDonation.value
                    ? null
                    : controller.submitDonation,
                icon: controller.isSubmittingDonation.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.favorite_rounded, size: 18),
                label: Text(
                  controller.isSubmittingDonation.value
                      ? 'Processing Donation...'
                      : 'Donate \$${controller.selectedAmount.value.toStringAsFixed(0)} USD',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyOption({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = AppColors.isDark(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.tealPillBg(context)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.tealPillBorder(context)
                : AppColors.cardBorder(context),
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected
                ? (isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep)
                : AppColors.textSecondary(context),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
