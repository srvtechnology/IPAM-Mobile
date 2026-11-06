import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class InspirationalQuoteWidget extends StatelessWidget {
  const InspirationalQuoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
        boxShadow: AppColors.cardShadow(context),
      ),
      child: Column(
        children: [
          // Gold Quotation Marks
          Text(
            '99',
            style: GoogleFonts.libreCaslonText(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.goldWarm : const Color(0xFFB45309),
              height: 0.9,
            ),
          ),
          const SizedBox(height: 10),
          // Quote Text
          Text(
            '"Connect. Empower. Excel. Uniting over 15,000 public servants, chartered accountants, and leaders worldwide."',
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: AppColors.textPrimary(context),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          // Institutional Seal Subtitle
          Text(
            'UNIVERSITY OF SIERRA LEONE • TOWER HILL',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: AppColors.textSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
