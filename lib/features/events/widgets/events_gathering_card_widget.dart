import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event_model.dart';
import '../../../core/theme/app_colors.dart';

class EventsGatheringCardWidget extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onRsvpTap;
  final VoidCallback? onCardTap;

  const EventsGatheringCardWidget({
    super.key,
    required this.event,
    this.onRsvpTap,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return InkWell(
      onTap: onCardTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
          boxShadow: AppColors.cardShadow(context),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Header Row: Pill Badge, Registered Count, and Calendar Date Box
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: Pill Badge & Registered Count
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          event.badgeTag,
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          event.registeredText.isNotEmpty
                              ? event.registeredText
                              : '${event.rsvpCount}+ Registered',
                          style: GoogleFonts.manrope(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Right: Calendar Date Box (OCT / 05)
                Container(
                  width: 44,
                  height: 46,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        event.dateMonth,
                        style: GoogleFonts.manrope(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        event.dateDay,
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : AppColors.charcoal,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2. Title
            Text(
              event.title,
              style: GoogleFonts.libreCaslonText(
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),

            // 3. Subtitle / Description
            Text(
              event.description,
              style: GoogleFonts.manrope(
                fontSize: 12.5,
                color: AppColors.textSecondary(context),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),

            // 4. Time Line
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 15,
                  color: Color(0xFFF59E0B),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    event.timeFormatted,
                    style: GoogleFonts.manrope(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // 5. Venue / Stage Line
            Row(
              children: [
                Icon(
                  event.isFree ? Icons.desktop_windows_outlined : Icons.apartment_rounded,
                  size: 15,
                  color: const Color(0xFF059669),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    event.venueType.isNotEmpty ? event.venueType : event.location,
                    style: GoogleFonts.manrope(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 6. Bottom Row: Price & RSVP Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  event.price,
                  style: GoogleFonts.manrope(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTealPillText : const Color(0xFF044E3D),
                  ),
                ),
                InkWell(
                  onTap: onRsvpTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: event.isRsvp ? const Color(0xFF044E3D) : AppColors.emeraldDeep,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emeraldDeep.withValues(alpha: 0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 1.5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'RSVP',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
