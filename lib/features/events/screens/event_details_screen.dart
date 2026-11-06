import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/event_details_controller.dart';
import '../models/event_model.dart';
import '../../../core/theme/app_colors.dart';

class EventDetailsScreen extends GetView<EventDetailsController> {
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<EventDetailsController>()) {
      Get.put(EventDetailsController());
    }

    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top App Bar: Back arrow, Title, Subtitle, Share
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: _buildAppBar(context, isDark),
            ),

            // Scrollable Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.fetchEventDetails,
                color: const Color(0xFF044E3D),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Obx(() {
                  final event = controller.event.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Hero Header Banner Card
                      _buildHeroCard(context, isDark, event),
                      const SizedBox(height: 16),

                      // 3. 2x2 Grid of Event Meta Info Cards
                      _buildMetaGrid(context, isDark, event),
                      const SizedBox(height: 20),

                      // 4. Select Admission Tier (Step 1 of 2)
                      _buildTierSelection(context, isDark, event),
                      const SizedBox(height: 20),

                      // 5. Who is Attending?
                      _buildWhoIsAttending(context, isDark, event),
                      const SizedBox(height: 20),

                      // 6. Complimentary Alumni Parking
                      _buildParkingCard(context, isDark, event),
                      const SizedBox(height: 24),
                    ],
                  );
                }),
              ),
            ),
          ),

            // 7. Persistent Bottom Action Bar
            Obx(() {
              final event = controller.event.value;
              return _buildBottomBar(context, isDark, event);
            }),
          ],
        ),
      ),
    );
  }

  /// Top App Bar matching Screenshot 2
  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : AppColors.charcoal,
            size: 22,
          ),
          onPressed: () => Get.back(),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Event Details',
                style: GoogleFonts.libreCaslonText(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'IPAM USL • ALUMNI NETWORK',
                style: GoogleFonts.manrope(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: const Color(0xFFD97706),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.share_outlined,
            color: isDark ? Colors.white70 : const Color(0xFF475569),
            size: 21,
          ),
          onPressed: controller.shareEvent,
        ),
      ],
    );
  }

  /// Hero Header Card matching Screenshot 2
  Widget _buildHeroCard(BuildContext context, bool isDark, EventModel event) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF03382A),
            Color(0xFF01241B),
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
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: OFFICIAL IPAM USL ALUMNI EVENT ... EST. 1980
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF02271E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF044E3D)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFBBF24),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'OFFICIAL IPAM USL ALUMNI EVENT',
                          style: GoogleFonts.manrope(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: const Color(0xFFFBBF24),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'EST. 1980',
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Event Title
          Text(
            event.title,
            style: GoogleFonts.libreCaslonText(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle / Description
          Text(
            event.description,
            style: GoogleFonts.manrope(
              fontSize: 12.5,
              color: const Color(0xFFCBD5E1),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),

          // Badges Row: Registration Open • 58 Seats Remaining | ID VERIFIED ONLY
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                // Badge 1: Registration Open
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF044E3D),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF065F46)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        size: 14,
                        color: Color(0xFF34D399),
                      ),
                      const SizedBox(width: 6),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Registration Open ',
                              style: GoogleFonts.manrope(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: '• ${event.seatsRemaining} Seats Remaining',
                              style: GoogleFonts.manrope(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFBBF24),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Badge 2: ID VERIFIED ONLY
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF02271E),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF065F46)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_user_outlined,
                        size: 14,
                        color: Color(0xFF34D399),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'ID VERIFIED ONLY',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: const Color(0xFF34D399),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 2x2 Grid of Event Meta Info Cards matching Screenshot 2
  Widget _buildMetaGrid(BuildContext context, bool isDark, EventModel event) {
    return Column(
      children: [
        Row(
          children: [
            // Card 1: DATE & TIME
            Expanded(
              child: _buildMetaCard(
                context,
                isDark: isDark,
                icon: Icons.calendar_today_outlined,
                iconColor: const Color(0xFF059669),
                iconBg: const Color(0xFFE6F4EA),
                label: 'DATE & TIME',
                primaryText: event.dateMonth.isNotEmpty && event.dateDay.isNotEmpty
                    ? '${event.dateMonth} ${event.dateDay}, 2026'
                    : 'Monday, Oct 05, 2026',
                secondaryText: event.timeFormatted.contains('•')
                    ? event.timeFormatted.split('•').last.trim()
                    : '15:00 GMT',
              ),
            ),
            const SizedBox(width: 12),

            // Card 2: LOCATION
            Expanded(
              child: _buildMetaCard(
                context,
                isDark: isDark,
                icon: Icons.location_on_outlined,
                iconColor: const Color(0xFF059669),
                iconBg: const Color(0xFFE6F4EA),
                label: 'LOCATION',
                primaryText: event.location,
                secondaryText: event.venueType.isNotEmpty && event.venueType != event.location
                    ? event.venueType
                    : 'Zoom Online • Live Streamed',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Card 3: ADMISSION TICKET
            Expanded(
              child: _buildMetaCard(
                context,
                isDark: isDark,
                icon: Icons.confirmation_number_outlined,
                iconColor: const Color(0xFFD97706),
                iconBg: const Color(0xFFFEF3C7),
                label: 'ADMISSION TICKET',
                primaryText: event.price.isNotEmpty ? event.price : r'$0 USD / NLe 0',
                secondaryText: event.isFree ? 'Alumni Complimentary' : 'Standard Pass',
              ),
            ),
            const SizedBox(width: 12),

            // Card 4: DRESS CODE
            Expanded(
              child: _buildMetaCard(
                context,
                isDark: isDark,
                icon: Icons.checkroom_outlined,
                iconColor: const Color(0xFF059669),
                iconBg: const Color(0xFFE6F4EA),
                label: 'DRESS CODE',
                primaryText: event.dressCode,
                secondaryText: 'Business or Cultural Attire',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetaCard(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String primaryText,
    required String secondaryText,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder(context)),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: AppColors.textTertiary(context),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            primaryText,
            style: GoogleFonts.libreCaslonText(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            secondaryText,
            style: GoogleFonts.manrope(
              fontSize: 11,
              color: AppColors.textSecondary(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Select Admission Tier matching Screenshot 3
  Widget _buildTierSelection(BuildContext context, bool isDark, EventModel event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row: Select Admission Tier ... Step 1 of 2
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Select Admission Tier',
                style: GoogleFonts.libreCaslonText(
                  fontSize: 18.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Step 1 of 2',
              style: GoogleFonts.manrope(
                fontSize: 11.5,
                color: AppColors.textTertiary(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Admission Tiers Cards
        ...event.admissionTiers.map((tier) {
          return Obx(() {
            final isSelected = controller.selectedTierId.value == tier.id;

            return GestureDetector(
              onTap: () => controller.selectTier(tier.id),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? (isDark ? const Color(0xFF059669) : const Color(0xFF044E3D))
                        : AppColors.cardBorder(context),
                    width: isSelected ? 1.8 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF044E3D).withValues(alpha: isDark ? 0.3 : 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Radio button circle
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? const Color(0xFF044E3D) : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF044E3D)
                                : (isDark ? const Color(0xFF64748B) : const Color(0xFFCBD5E1)),
                            width: 1.5,
                          ),
                        ),
                        child: isSelected
                            ? const Center(
                                child: Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Tier Title & Description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  tier.name,
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (tier.badgeText.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                                  decoration: BoxDecoration(
                                    color: tier.isRecommended
                                        ? (isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA))
                                        : (isDark ? const Color(0xFF451A03) : const Color(0xFFFEF3C7)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    tier.badgeText,
                                    style: GoogleFonts.manrope(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: tier.isRecommended
                                          ? (isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D))
                                          : (isDark ? const Color(0xFFFBBF24) : const Color(0xFF92400E)),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tier.description,
                            style: GoogleFonts.manrope(
                              fontSize: 11.5,
                              color: AppColors.textSecondary(context),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${tier.priceUsd.toInt()}',
                          style: GoogleFonts.libreCaslonText(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: tier.priceUsd == 0
                                ? const Color(0xFF059669)
                                : AppColors.textPrimary(context),
                          ),
                        ),
                        Text(
                          'NLe ${tier.priceNle}',
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            color: AppColors.textTertiary(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        }),
      ],
    );
  }

  /// Who is Attending? Card matching Screenshot 3 & 4
  Widget _buildWhoIsAttending(BuildContext context, bool isDark, EventModel event) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder(context)),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Who is Attending? ... 320
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Who is Attending?',
                      style: GoogleFonts.libreCaslonText(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${event.rsvpCount > 0 ? event.rsvpCount : 320} Alumni Registered to date',
                      style: GoogleFonts.manrope(
                        fontSize: 11.5,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  const Icon(
                    Icons.people_alt_outlined,
                    size: 18,
                    color: Color(0xFF059669),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${event.rsvpCount > 0 ? event.rsvpCount : 320}',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF059669),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Attendees List
          ...event.attendees.map((att) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      att.name,
                      style: GoogleFonts.manrope(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 6,
                    child: Text(
                      att.role,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: att.isKeynote ? FontWeight.bold : FontWeight.w500,
                        color: att.isKeynote
                            ? const Color(0xFF059669)
                            : AppColors.textTertiary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Complimentary Alumni Parking Card matching Screenshot 4
  Widget _buildParkingCard(BuildContext context, bool isDark, EventModel event) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder(context)),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Bold P icon + Title
          Row(
            children: [
              Text(
                'P',
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF044E3D),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Complimentary Alumni Parking',
                  style: GoogleFonts.manrope(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            event.parkingInfo,
            style: GoogleFonts.manrope(
              fontSize: 11.5,
              color: AppColors.textSecondary(context),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),

          // Two Action Buttons: Open in Maps & Get Directions
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: controller.openMaps,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 17,
                          color: isDark ? Colors.white70 : const Color(0xFF334155),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Open in Maps',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF334155),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: controller.getDirections,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.directions_rounded,
                          size: 17,
                          color: Color(0xFF059669),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Get Directions',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Persistent Bottom Action Bar matching Screenshots 2, 3, 4
  Widget _buildBottomBar(BuildContext context, bool isDark, EventModel event) {
    final selectedTier = controller.currentSelectedTier;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        border: Border(
          top: BorderSide(
            color: AppColors.cardBorder(context),
            width: 1.2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left: Selected Tier label & price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedTier.name.toUpperCase(),
                  style: GoogleFonts.manrope(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: AppColors.textTertiary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '\$${selectedTier.priceUsd.toInt()} ',
                        style: GoogleFonts.libreCaslonText(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.charcoal,
                        ),
                      ),
                      TextSpan(
                        text: 'USD / NLe ${selectedTier.priceNle}',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Bookmark Button
          InkWell(
            onTap: controller.toggleBookmark,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Icon(
                event.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                size: 20,
                color: event.isBookmarked
                    ? const Color(0xFFD97706)
                    : (isDark ? Colors.white70 : const Color(0xFF475569)),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Main CTA Button
          ElevatedButton(
            onPressed: controller.isBooking.value ? null : () => controller.bookTicket(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF044E3D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: controller.isBooking.value
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        event.isRsvp ? 'Ticket Confirmed ✓' : 'Book Ticket',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_rounded, size: 16),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
