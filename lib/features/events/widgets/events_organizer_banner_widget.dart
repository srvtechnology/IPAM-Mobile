import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class EventsOrganizerBannerWidget extends StatelessWidget {
  final VoidCallback? onSubmitProposal;

  const EventsOrganizerBannerWidget({
    super.key,
    this.onSubmitProposal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF03382A),
            Color(0xFF02271E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFF065F46),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Tag & Icon Row
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF064E3B).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.event_available_rounded,
                    color: Color(0xFFF59E0B),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'CHAPTER LEADERS & ORGANIZERS',
                  style: GoogleFonts.manrope(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppColors.goldHighlight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2. Title
          Text(
            'Hosting a Regional Chapter Meetup?',
            style: GoogleFonts.libreCaslonText(
              fontSize: 19.5,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),

          // 3. Subtitle / Description
          Text(
            'Apply for official IPAM Alumni Association sponsorship, registrar email outreach, and verified registry promotion for your city or cohort reunion.',
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: const Color(0xFFCBD5E1),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // 4. Action Button: + Submit Event Proposal
          InkWell(
            onTap: onSubmitProposal,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add_circle_outline_rounded,
                    color: AppColors.charcoal,
                    size: 18,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'Submit Event Proposal',
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.charcoal,
                    ),
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
