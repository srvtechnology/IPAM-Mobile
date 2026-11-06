import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/events_provider.dart';
import '../models/event_model.dart';
import '../../../models/event_models.dart';
import '../../../core/network/auth_storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../profile/controllers/profile_controller.dart';

class EventsController extends GetxController {
  final EventsProvider _provider = EventsProvider();

  final isLoading = false.obs;
  late final RxList<EventModel> eventsList = <EventModel>[..._provider.getCuratedEvents()].obs;
  late final RxList<EventModel> myTicketsList = <EventModel>[
    ..._provider.getCuratedEvents().where((e) => e.isRsvp),
  ].obs;
  final ScrollController scrollController = ScrollController();

  // Sub-tabs: 'Upcoming Events' or 'My Tickets'
  final activeTab = 'Upcoming Events'.obs;

  // Filter Chapter & Category
  final selectedChapter = 'All Chapters (12)'.obs;
  final selectedCategory = 'All Events'.obs;

  final categories = const [
    'All Events',
    'Virtual / Webinars',
    'Freetown & Local',
    'International Chapters',
  ];

  late final List<String> chapters;

  @override
  void onInit() {
    super.onInit();
    chapters = _provider.getChapterList();
    loadEvents();
  }

  Future<void> loadEvents() async {
    if (eventsList.isEmpty) {
      isLoading.value = true;
    }
    try {
      final list = await _provider.fetchEvents();
      if (list.isNotEmpty) {
        final syncedList = list.map((e) {
          final isTicket = myTicketsList.any((t) => t.id == e.id);
          if (isTicket) {
            final ticket = myTicketsList.firstWhere((t) => t.id == e.id);
            return e.copyWith(
              isRsvp: true,
              ticketCode: ticket.ticketCode,
              ticketTier: ticket.ticketTier,
            );
          }
          return e;
        }).toList();
        eventsList.assignAll(syncedList);
      }
      await loadMyTickets();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMyTickets() async {
    final authStorage = Get.isRegistered<AuthStorageService>() ? Get.find<AuthStorageService>() : null;
    if (authStorage != null && !authStorage.isAuthenticated) return;

    try {
      final tickets = await _provider.fetchMyRegistrations();
      myTicketsList.assignAll(tickets);

      // Synchronize RSVP status in main events list
      for (final ticket in tickets) {
        final idx = eventsList.indexWhere((e) => e.id == ticket.id || (ticket.ticketCode != null && e.ticketCode == ticket.ticketCode));
        if (idx != -1) {
          eventsList[idx] = eventsList[idx].copyWith(
            isRsvp: true,
            ticketCode: ticket.ticketCode,
            ticketTier: ticket.ticketTier,
          );
        }
      }
    } catch (_) {}
  }

  int get upcomingEventsCount => eventsList.where((e) => e.isUpcoming).length;
  int get myTicketsCount {
    final tickets = myTickets;
    return tickets.isNotEmpty ? tickets.length : eventsList.where((e) => e.isRsvp).length;
  }

  EventModel? get flagshipEvent {
    try {
      return eventsList.firstWhere((e) => e.isFeatured && e.isUpcoming);
    } catch (_) {
      try {
        return eventsList.firstWhere((e) => e.isFeatured);
      } catch (_) {
        return null;
      }
    }
  }

  List<EventModel> get upcomingGatherings {
    return filteredEvents
        .where((e) => !e.isFeatured && e.isUpcoming)
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  List<EventModel> get pastGatherings {
    return filteredEvents
        .where((e) => e.isPast)
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  List<EventModel> get myTickets {
    if (myTicketsList.isNotEmpty) {
      return myTicketsList;
    }
    return eventsList.where((e) => e.isRsvp).toList();
  }

  List<EventModel> get filteredEvents {
    return eventsList.where((event) {
      // 1. Chapter filter
      if (selectedChapter.value != 'All Chapters (12)') {
        final query = selectedChapter.value.toLowerCase();
        final matchesChapter = event.chapter.toLowerCase().contains(query) ||
            query.contains(event.chapter.toLowerCase());
        if (!matchesChapter) return false;
      }

      // 2. Category filter
      if (selectedCategory.value != 'All Events') {
        if (event.category != selectedCategory.value) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void switchTab(String tab) {
    activeTab.value = tab;
    if (tab == 'My Tickets') {
      loadMyTickets();
    }
  }

  void selectChapter(String chapter) {
    selectedChapter.value = chapter;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void toggleBookmark(EventModel event) {
    final index = eventsList.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      final updated = event.copyWith(isBookmarked: !event.isBookmarked);
      eventsList[index] = updated;

      if (Get.context != null) {
        Get.snackbar(
          updated.isBookmarked ? 'Event Saved' : 'Event Removed',
          updated.isBookmarked
              ? 'Saved "${event.title}" to your bookmarked events.'
              : 'Removed from bookmarks.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.card(Get.context!),
          colorText: AppColors.textPrimary(Get.context!),
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  Future<void> toggleRsvp(EventModel event) async {
    final newStatus = !event.isRsvp;
    final newCount = newStatus ? event.rsvpCount + 1 : (event.rsvpCount > 0 ? event.rsvpCount - 1 : 0);

    final index = eventsList.indexWhere((e) => e.id == event.id);
    var updated = event.copyWith(
      isRsvp: newStatus,
      rsvpCount: newCount,
      ticketCode: newStatus ? (event.ticketCode ?? 'BK-EVT-${1000 + (index != -1 ? index : 0)}') : null,
      ticketTier: newStatus ? (event.ticketTier ?? 'Standard Alumni Pass') : null,
    );
    if (index != -1) {
      eventsList[index] = updated;

      if (newStatus) {
        if (!myTicketsList.any((t) => t.id == updated.id)) {
          myTicketsList.add(updated);
        }
      } else {
        myTicketsList.removeWhere((t) => t.id == updated.id || (event.ticketCode != null && t.ticketCode == event.ticketCode));
      }
    }

    if (!newStatus && event.ticketCode != null) {
      await _provider.cancelRegistration(event.ticketCode!);
    } else if (newStatus) {
      final booking = await _provider.registerForEvent(event.id);
      if (booking != null) {
        final bookingModel = booking.toEventModel();
        final idx = myTicketsList.indexWhere((t) => t.id == event.id);
        if (idx != -1) {
          myTicketsList[idx] = bookingModel;
        }
      } else {
        await _provider.toggleRsvp(event.id, event.isRsvp);
      }
    }

    if (Get.isRegistered<ProfileController>()) {
      final profileCtrl = Get.find<ProfileController>();
      if (newStatus && !profileCtrl.registeredTickets.any((t) => t.id == updated.id || (updated.ticketCode != null && t.ticketCode == updated.ticketCode))) {
        profileCtrl.registeredTickets.insert(0, updated);
      } else if (!newStatus) {
        profileCtrl.registeredTickets.removeWhere((t) => t.id == updated.id || (event.ticketCode != null && t.ticketCode == event.ticketCode));
      }
      profileCtrl.profile.value = profileCtrl.profile.value.copyWith(
        registeredEventsCount: profileCtrl.registeredTickets.length,
      );
    }

    if (Get.context != null) {
      if (newStatus) {
        Get.snackbar(
          'RSVP Confirmed ✓',
          'Your pass for "${event.title}" has been issued to My Tickets.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF044E3D),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF34D399)),
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'RSVP Cancelled',
          'Your pass for this event has been cancelled.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.card(Get.context!),
          colorText: AppColors.textPrimary(Get.context!),
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  Future<void> cancelTicket(EventModel event, {bool callApi = true}) async {
    if (callApi && event.ticketCode != null) {
      await _provider.cancelRegistration(event.ticketCode!);
    }

    // Remove from myTicketsList and mark isRsvp false in eventsList
    myTicketsList.removeWhere((e) => e.id == event.id || (event.ticketCode != null && e.ticketCode == event.ticketCode));

    final idx = eventsList.indexWhere((e) => e.id == event.id);
    if (idx != -1) {
      eventsList[idx] = eventsList[idx].copyWith(
        isRsvp: false,
        ticketCode: null,
        rsvpCount: eventsList[idx].rsvpCount > 0 ? eventsList[idx].rsvpCount - 1 : 0,
      );
    }

    if (Get.isRegistered<ProfileController>()) {
      final profileCtrl = Get.find<ProfileController>();
      profileCtrl.registeredTickets.removeWhere((e) => e.id == event.id || (event.ticketCode != null && e.ticketCode == event.ticketCode));
      profileCtrl.profile.value = profileCtrl.profile.value.copyWith(
        registeredEventsCount: profileCtrl.registeredTickets.length,
      );
    }

    if (Get.context != null) {
      Get.snackbar(
        'Registration Cancelled',
        'Your ticket for "${event.title}" has been released.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.card(Get.context!),
        colorText: AppColors.textPrimary(Get.context!),
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<bool> submitProposal({
    required String chapterName,
    required String eventName,
    required String proposedDate,
    required String expectedAttendance,
    required String description,
    String category = 'CAREER_WORKSHOP',
    String format = 'HYBRID',
    String organizerEmail = 'alumni@ipam.edu.sl',
  }) async {
    final proposal = EventProposal(
      title: eventName,
      category: category,
      format: format,
      location: chapterName.isNotEmpty ? chapterName : 'IPAM Innovation Hub, Freetown',
      description: description,
      organizerEmail: organizerEmail,
      expectedAttendance: expectedAttendance,
      proposedDate: proposedDate,
    );

    final success = await _provider.submitProposal(proposal);

    if (Get.context != null) {
      Get.snackbar(
        'Proposal Submitted! 🎉',
        'Official sponsorship & outreach review scheduled with the USL Global Directorate.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF044E3D),
        colorText: Colors.white,
        icon: const Icon(Icons.verified, color: Color(0xFFFBBF24)),
        duration: const Duration(seconds: 4),
      );
    }
    return success;
  }
}
