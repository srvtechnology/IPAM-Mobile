import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event_model.dart';
import '../data/events_provider.dart';
import 'events_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/network/auth_storage_service.dart';
import '../../profile/controllers/profile_controller.dart';

class EventDetailsController extends GetxController {
  final EventsProvider _provider = EventsProvider();
  late Rx<EventModel> event;
  final selectedTierId = 'patron'.obs;
  final isBooking = false.obs;
  final isLoadingDetails = false.obs;
  final EventModel? initialEvent;

  EventDetailsController({this.initialEvent});

  @override
  void onInit() {
    super.onInit();
    final args = initialEvent ?? Get.arguments;
    if (args is EventModel) {
      event = Rx<EventModel>(args);
    } else if (args is String) {
      final defaultEvent = _provider.getCuratedEvents().firstWhere(
            (e) => e.id == args,
            orElse: () => _provider.getCuratedEvents().first,
          );
      event = Rx<EventModel>(defaultEvent);
    } else {
      final defaultEvent = _provider.getCuratedEvents().firstWhere(
            (e) => e.id == 'ev_webinar',
            orElse: () => _provider.getCuratedEvents().first,
          );
      event = Rx<EventModel>(defaultEvent);
    }

    // If event is already RSVP'd, match its tier if available
    if (event.value.isRsvp && event.value.ticketTier != null) {
      final match = event.value.admissionTiers.firstWhereOrNull(
        (t) => t.name.toLowerCase() == event.value.ticketTier!.toLowerCase(),
      );
      if (match != null) {
        selectedTierId.value = match.id;
      }
    }

    fetchEventDetails();
  }

  Future<void> fetchEventDetails() async {
    final eventId = event.value.id;
    if (eventId.isEmpty) return;

    try {
      isLoadingDetails.value = true;
      final dynamicEvent = await _provider.getEventDetails(eventId);
      if (dynamicEvent != null) {
        final isRsvp = event.value.isRsvp || dynamicEvent.isRsvp;
        final ticketCode = event.value.ticketCode ?? dynamicEvent.ticketCode;
        final ticketTier = event.value.ticketTier ?? dynamicEvent.ticketTier;
        final isBookmarked = event.value.isBookmarked || dynamicEvent.isBookmarked;

        event.value = dynamicEvent.copyWith(
          isRsvp: isRsvp,
          ticketCode: ticketCode,
          ticketTier: ticketTier,
          isBookmarked: isBookmarked,
        );

        if (isRsvp && ticketTier != null) {
          final match = event.value.admissionTiers.firstWhereOrNull(
            (t) => t.name.toLowerCase() == ticketTier.toLowerCase(),
          );
          if (match != null) {
            selectedTierId.value = match.id;
          }
        }
      }
    } catch (_) {
      // Retain initial event on network or timeout error
    } finally {
      isLoadingDetails.value = false;
    }
  }

  EventAdmissionTier get currentSelectedTier {
    return event.value.admissionTiers.firstWhere(
      (t) => t.id == selectedTierId.value,
      orElse: () => event.value.admissionTiers.first,
    );
  }

  void selectTier(String tierId) {
    selectedTierId.value = tierId;
  }

  void toggleBookmark() {
    final updated = event.value.copyWith(isBookmarked: !event.value.isBookmarked);
    event.value = updated;

    if (Get.isRegistered<EventsController>()) {
      Get.find<EventsController>().toggleBookmark(event.value);
    } else if (Get.context != null) {
      Get.snackbar(
        updated.isBookmarked ? 'Event Saved' : 'Event Removed',
        updated.isBookmarked
            ? 'Saved "${event.value.title}" to your bookmarked events.'
            : 'Removed from bookmarks.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.card(Get.context!),
        colorText: AppColors.textPrimary(Get.context!),
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> bookTicket(BuildContext context) async {
    if (event.value.isRsvp) {
      _showTicketPassSheet(context);
      return;
    }

    isBooking.value = true;
    try {
      final tier = currentSelectedTier;
      final authStorage = Get.isRegistered<AuthStorageService>()
          ? Get.find<AuthStorageService>()
          : Get.put(AuthStorageService(), permanent: true);

      final user = authStorage.user;

      final booking = await _provider.registerForEvent(
        event.value.id,
        ticketCount: 1,
        attendeeName: user?.fullName,
        attendeeEmail: user?.email,
        attendeePhone: user?.phone,
        notes: 'Alumni Pass Reservation - ${tier.name}',
        paymentMethod: tier.priceUsd == 0 ? 'FREE' : 'CARD',
      );

      final bookingRef = booking?.bookingReference ??
          'BK-EVT-${1000 + DateTime.now().millisecondsSinceEpoch % 9000}';

      final updated = event.value.copyWith(
        isRsvp: true,
        rsvpCount: event.value.rsvpCount + 1,
        ticketCode: bookingRef,
        ticketTier: tier.name,
      );
      event.value = updated;

      // Synchronize with main events controller
      if (Get.isRegistered<EventsController>()) {
        final eventsCtrl = Get.find<EventsController>();
        final idx = eventsCtrl.eventsList.indexWhere((e) => e.id == updated.id);
        if (idx != -1) {
          eventsCtrl.eventsList[idx] = updated;
        }
        if (!eventsCtrl.myTicketsList.any((t) => t.id == updated.id || t.ticketCode == updated.ticketCode)) {
          eventsCtrl.myTicketsList.add(updated);
        }
        await eventsCtrl.loadMyTickets();
      }

      // Synchronize with ProfileController
      if (Get.isRegistered<ProfileController>()) {
        final profileCtrl = Get.find<ProfileController>();
        if (!profileCtrl.registeredTickets.any((t) => t.id == updated.id || (updated.ticketCode != null && t.ticketCode == updated.ticketCode))) {
          profileCtrl.registeredTickets.insert(0, updated);
          profileCtrl.profile.value = profileCtrl.profile.value.copyWith(
            registeredEventsCount: profileCtrl.registeredTickets.length,
          );
        }
        await profileCtrl.loadRegisteredEvents();
      }

      if (context.mounted) {
        _showConfirmationModal(context, updated, tier);
      }
    } finally {
      isBooking.value = false;
    }
  }

  void openMaps() {
    if (Get.context != null) {
      Get.snackbar(
        'Opening Maps',
        'Navigating to ${event.value.location}...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.card(Get.context!),
        colorText: AppColors.textPrimary(Get.context!),
        icon: const Icon(Icons.map_outlined, color: Color(0xFF059669)),
        duration: const Duration(seconds: 2),
      );
    }
  }

  void getDirections() {
    if (Get.context != null) {
      Get.snackbar(
        'Get Directions',
        'Locating the best route to ${event.value.venueType.isNotEmpty ? event.value.venueType : event.value.location}...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF044E3D),
        colorText: Colors.white,
        icon: const Icon(Icons.directions_rounded, color: Color(0xFF34D399)),
        duration: const Duration(seconds: 2),
      );
    }
  }

  void shareEvent() {
    if (Get.context != null) {
      Get.snackbar(
        'Invitation Link Copied',
        'Share link for "${event.value.title}" copied to clipboard.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.card(Get.context!),
        colorText: AppColors.textPrimary(Get.context!),
        icon: const Icon(Icons.link_rounded, color: Color(0xFF059669)),
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _showConfirmationModal(
    BuildContext context,
    EventModel ev,
    EventAdmissionTier tier,
  ) {
    final isDark = AppColors.isDark(context);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: AppColors.cardBorder(context), width: 1.5),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Success Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF059669),
                  size: 38,
                ),
              ),
              const SizedBox(height: 14),

              Text(
                'Ticket Confirmed! 🎉',
                style: GoogleFonts.libreCaslonText(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your admission pass has been registered under your verified alumni profile and added to My Tickets.',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: AppColors.textSecondary(context),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),

              // Digital Pass Ticket Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF059669).withValues(alpha: 0.3),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'OFFICIAL DIGITAL PASS',
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: const Color(0xFF059669),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            ev.ticketCode ?? 'IPAM-PASS-CONFIRMED',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Text(
                      ev.title,
                      style: GoogleFonts.libreCaslonText(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              tier.name,
                              style: GoogleFonts.manrope(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF92400E),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            tier.priceFormatted,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(color: AppColors.cardBorder(context)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'Done',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        if (Get.isRegistered<EventsController>()) {
                          Get.find<EventsController>().switchTab('My Tickets');
                        }
                        Get.back(); // Return to Events screen with My Tickets tab active
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF044E3D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Text(
                        'View in My Tickets',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showTicketPassSheet(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final ev = event.value;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: AppColors.cardBorder(context), width: 1.5),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Admission Pass',
                    style: GoogleFonts.libreCaslonText(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F4EA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Text(
                      'VERIFIED',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF044E3D),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Show this pass at security check or venue entrance.',
                style: GoogleFonts.manrope(
                  fontSize: 12.5,
                  color: AppColors.textSecondary(context),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder(context)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.qr_code_2_rounded,
                      size: 110,
                      color: isDark ? Colors.white : AppColors.charcoal,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ev.ticketCode ?? 'IPAM-VIRT-3209',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: const Color(0xFF059669),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ev.ticketTier ?? 'Patron Sponsor Pass',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF044E3D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
