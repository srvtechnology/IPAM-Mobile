import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../events/models/event_model.dart';
import '../../../core/theme/app_colors.dart';

class UpcomingEventsSectionWidget extends StatelessWidget {
  final List<EventModel> events;
  final VoidCallback? onViewAll;
  final ValueChanged<EventModel>? onEventTap;

  const UpcomingEventsSectionWidget({
    super.key,
    required this.events,
    this.onViewAll,
    this.onEventTap,
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
                    Icons.calendar_month_rounded,
                    color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Upcoming Events',
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
              onPressed: onViewAll,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View All',
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
        // Horizontal Event Cards List
        if (events.isEmpty)
          Container(
            height: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
            ),
            child: Text(
              'No upcoming institutional events scheduled.',
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: AppColors.textSecondary(context),
              ),
            ),
          )
        else
          SizedBox(
            height: 185,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: events.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final event = events[index];
                return _buildEventCard(context, event);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEventCard(BuildContext context, EventModel event) {
    final isDark = AppColors.isDark(context);
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final monthStr = months[event.dateTime.month - 1];

    String priceLabel = 'Free';
    if (!event.isFree && !event.category.contains('Virtual')) {
      if (event.price.contains(r'$15')) {
        priceLabel = r'$15';
      } else if (event.price.isNotEmpty) {
        priceLabel = event.price.split(' ').first;
      } else {
        priceLabel = r'$15';
      }
    }

    return InkWell(
      onTap: () => onEventTap?.call(event),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 285,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
          boxShadow: AppColors.cardShadow(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Category Pill & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tealPillBg(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.tealPillBorder(context), width: 0.8),
                    ),
                    child: Text(
                      event.category,
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.tealPillText(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$monthStr ${event.dateTime.day}',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.goldWarm : const Color(0xFFB45309),
                  ),
                ),
              ],
            ),
            // Title & Description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: GoogleFonts.libreCaslonText(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  event.description,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppColors.textSecondary(context),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            // Bottom Row: Location & Price Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        event.category.contains('Virtual')
                            ? Icons.videocam_outlined
                            : Icons.location_on_outlined,
                        color: AppColors.textSecondary(context),
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: AppColors.textSecondary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.tealPillBg(context),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.tealPillBorder(context), width: 0.8),
                  ),
                  child: Text(
                    priceLabel,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tealPillText(context),
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
