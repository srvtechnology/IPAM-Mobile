import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event_model.dart';
import '../../../core/theme/app_colors.dart';

class EventsFlagshipCardWidget extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onDetailsTap;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onShareTap;

  const EventsFlagshipCardWidget({
    super.key,
    required this.event,
    this.onDetailsTap,
    this.onBookmarkTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return InkWell(
      onTap: onDetailsTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
          boxShadow: AppColors.cardShadow(context),
        ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hero Image with Overlays
          Stack(
            children: [
              // Hero Image
              SizedBox(
                height: 190,
                width: double.infinity,
                child: Image.network(
                  event.imageUrl ??
                      'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=1200&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFF03382A),
                    child: const Center(
                      child: Icon(Icons.event, color: Colors.white54, size: 48),
                    ),
                  ),
                ),
              ),

              // Bottom Gradient overlay for readability of location tag
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 70,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),

              // Top-Left Badge: FEATURED FLAGSHIP EVENT
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        color: AppColors.charcoal,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        event.featuredTag ?? 'FEATURED FLAGSHIP EVENT',
                        style: GoogleFonts.manrope(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: AppColors.charcoal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Top-Right: Bookmark Icon in Amber / Translucent Circle
              Positioned(
                top: 14,
                right: 14,
                child: GestureDetector(
                  onTap: onBookmarkTap,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        event.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        color: const Color(0xFFF59E0B),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom-Left Location Tag
              Positioned(
                bottom: 12,
                left: 14,
                right: 14,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFFF59E0B),
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        event.location,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 2. Card Body Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date & Time + Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 17,
                            color: isDark ? AppColors.darkTealPillText : const Color(0xFF044E3D),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              event.timeFormatted,
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                                color: isDark ? AppColors.darkTealPillText : const Color(0xFF044E3D),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF451A03) : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? const Color(0xFF78350F) : const Color(0xFFFDE68A),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        event.price,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFFFBBF24) : const Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  event.title,
                  style: GoogleFonts.libreCaslonText(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),

                // Description
                Text(
                  event.description,
                  style: GoogleFonts.manrope(
                    fontSize: 12.5,
                    color: AppColors.textSecondary(context),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),

                // 3. Distinguished Keynote Speakers Highlight Box
                if (event.keynoteSpeakers.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DISTINGUISHED KEYNOTE SPEAKERS',
                          style: GoogleFonts.manrope(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          event.keynoteSpeakers.join('   •   '),
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 14),

                // 4. Registered Alumni Count & Pass Open Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event.registeredText.isNotEmpty
                          ? event.registeredText
                          : '${event.rsvpCount} Alumni Registered',
                      style: GoogleFonts.manrope(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTealPillText : const Color(0xFF044E3D),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.lock_open_rounded,
                          size: 15,
                          color: Color(0xFF059669),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Pass Open',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 5. Actions Row: View Event Details & RSVP + Share Button
                Row(
                  children: [
                    // Primary Action Button
                    Expanded(
                      child: InkWell(
                        onTap: onDetailsTap,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppColors.emeraldDeep,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.emeraldDeep.withValues(alpha: 0.28),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                event.isRsvp ? 'View Ticket & Details' : 'View Event Details & RSVP',
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 17,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Share Button
                    InkWell(
                      onTap: onShareTap,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            width: 1.2,
                          ),
                        ),
                        child: Icon(
                          Icons.share_outlined,
                          size: 19,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}
