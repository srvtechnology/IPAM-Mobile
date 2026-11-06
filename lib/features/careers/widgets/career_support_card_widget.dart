import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class CareerSupportCardWidget extends StatelessWidget {
  final VoidCallback? onConnectMentor;

  const CareerSupportCardWidget({
    super.key,
    this.onConnectMentor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Light bulb badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF064E3B)
                      : const Color(0xFFD1FAE5),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.lightbulb_rounded,
                    color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alumni Career Support',
                      style: GoogleFonts.libreCaslonText(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Request a complimentary resume critique or executive introduction from senior IPAM alumni mentors prior to submitting.',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Action Link
          InkWell(
            onTap: onConnectMentor,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'Connect with a Career Mentor',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
