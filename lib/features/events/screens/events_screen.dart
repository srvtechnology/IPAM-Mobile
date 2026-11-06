import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/events_controller.dart';
import '../models/event_model.dart';
import '../widgets/events_header_widget.dart';
import '../widgets/events_subtabs_widget.dart';
import '../widgets/events_filter_bar_widget.dart';
import '../widgets/events_flagship_card_widget.dart';
import '../widgets/events_gathering_card_widget.dart';
import '../widgets/events_organizer_banner_widget.dart';
import '../widgets/event_ticket_card_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/network/auth_storage_service.dart';
import '../../../routes/app_pages.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class EventsScreen extends GetView<EventsController> {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<EventsController>()) {
      Get.put(EventsController());
    }

    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.emeraldDeep,
          onRefresh: controller.loadEvents,
          child: SingleChildScrollView(
            controller: controller.scrollController..addListener(() {}),
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Institutional Header Bar & Sub-title & Stat Pills
                EventsHeaderWidget(
                  onNotificationTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                  onProfileTap: () {
                    if (Get.isRegistered<DashboardController>()) {
                      Get.find<DashboardController>().changeTab(4);
                    }
                  },
                ),
                const SizedBox(height: 18),

                // 2. Segmented Sub-Tabs: Upcoming Events (5) | My Tickets (2) [New]
                Obx(
                  () => EventsSubtabsWidget(
                    activeTab: controller.activeTab.value,
                    upcomingCount: controller.upcomingEventsCount,
                    ticketsCount: controller.myTicketsCount,
                    onTabChanged: controller.switchTab,
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Tab Body
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.emeraldDeep),
                      ),
                    );
                  }

                  if (controller.activeTab.value == 'My Tickets') {
                    return _buildMyTicketsView(context, isDark);
                  }

                  return _buildUpcomingEventsView(context, isDark);
                }),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// View for Upcoming Events Tab
  Widget _buildUpcomingEventsView(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Bar: Chapter Dropdown + Category Chips
        EventsFilterBarWidget(
          selectedChapter: controller.selectedChapter.value,
          selectedCategory: controller.selectedCategory.value,
          categories: controller.categories,
          onChapterTap: () => _showChapterSelector(context),
          onCategorySelected: controller.selectCategory,
        ),
        const SizedBox(height: 18),

        // Featured Flagship Event Hero Card
        if (controller.flagshipEvent != null) ...[
          EventsFlagshipCardWidget(
            event: controller.flagshipEvent!,
            onDetailsTap: () => Get.toNamed(Routes.EVENT_DETAILS, arguments: controller.flagshipEvent!),
            onBookmarkTap: () => controller.toggleBookmark(controller.flagshipEvent!),
            onShareTap: () => _showShareSheet(context, controller.flagshipEvent!),
          ),
          const SizedBox(height: 24),
        ],

        // Section Header: "Upcoming Gatherings" [4 listed]
        _buildSectionHeader(context, isDark),
        const SizedBox(height: 14),

        // List of Gatherings
        Builder(
          builder: (context) {
            final gatherings = controller.upcomingGatherings;

            if (gatherings.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.card(context),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.cardBorder(context)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_busy_outlined,
                      size: 48,
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No Gatherings Match Filters',
                      style: GoogleFonts.libreCaslonText(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Try resetting chapter or category filters.',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: AppColors.textSecondary(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        controller.selectChapter('All Chapters (12)');
                        controller.selectCategory('All Events');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emeraldDeep,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Reset All Filters'),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: gatherings.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final item = gatherings[index];
                return EventsGatheringCardWidget(
                  event: item,
                  onRsvpTap: () => Get.toNamed(Routes.EVENT_DETAILS, arguments: item),
                  onCardTap: () => Get.toNamed(Routes.EVENT_DETAILS, arguments: item),
                );
              },
            );
          },
        ),

        // Past & Concluded Gatherings Section (Archived)
        if (controller.pastGatherings.isNotEmpty) ...[
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Past & Concluded Gatherings',
                style: GoogleFonts.libreCaslonText(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
              Text(
                '${controller.pastGatherings.length} concluded',
                style: GoogleFonts.manrope(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.pastGatherings.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = controller.pastGatherings[index];
              return Opacity(
                opacity: 0.78,
                child: EventsGatheringCardWidget(
                  event: item,
                  onRsvpTap: () => Get.toNamed(Routes.EVENT_DETAILS, arguments: item),
                  onCardTap: () => Get.toNamed(Routes.EVENT_DETAILS, arguments: item),
                ),
              );
            },
          ),
        ],
        const SizedBox(height: 24),

        // Chapter Leaders & Organizers Banner Card
        EventsOrganizerBannerWidget(
          onSubmitProposal: () => _showSubmitProposalSheet(context),
        ),
      ],
    );
  }

  /// Section Header: Upcoming Gatherings ... 4 listed
  Widget _buildSectionHeader(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Upcoming Gatherings',
          style: GoogleFonts.libreCaslonText(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
        ),
        Text(
          '${controller.upcomingGatherings.length} listed',
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  /// View for My Tickets Tab
  Widget _buildMyTicketsView(BuildContext context, bool isDark) {
    final tickets = controller.myTickets;

    if (tickets.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder(context)),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.confirmation_number_outlined,
              size: 52,
              color: AppColors.emeraldDeep,
            ),
            const SizedBox(height: 14),
            Text(
              'No Active Tickets Yet',
              style: GoogleFonts.libreCaslonText(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'RSVP for upcoming galas, webinars, or mixers to issue your digital pass.',
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: AppColors.textSecondary(context),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () => controller.switchTab('Upcoming Events'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emeraldDeep,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Browse Events'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Confirmed Passes',
              style: GoogleFonts.libreCaslonText(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${tickets.length} Active',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tickets.length,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final ticket = tickets[index];
            return EventTicketCardWidget(
              event: ticket,
              onCardTap: () => Get.toNamed(Routes.EVENT_DETAILS, arguments: ticket),
              onCancelRsvp: () => controller.cancelTicket(ticket),
              onDownloadPass: () {
                Get.snackbar(
                  'Pass Saved',
                  'Digital Pass for "${ticket.title}" saved to your device.',
                  backgroundColor: AppColors.card(context),
                  colorText: AppColors.textPrimary(context),
                );
              },
            );
          },
        ),
      ],
    );
  }

  /// Chapter Selector Modal Sheet
  void _showChapterSelector(BuildContext context) {
    final isDark = AppColors.isDark(context);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
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
            Text(
              'Select Chapter / Region',
              style: GoogleFonts.libreCaslonText(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'View events organized by specific regional chapters or global stages.',
              style: GoogleFonts.manrope(
                fontSize: 12.5,
                color: AppColors.textSecondary(context),
              ),
            ),
            const SizedBox(height: 14),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.45,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.chapters.length,
                itemBuilder: (context, index) {
                  final chapter = controller.chapters[index];
                  final isSelected = controller.selectedChapter.value == chapter;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.apartment_rounded,
                      color: isSelected ? AppColors.emeraldDeep : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      size: 20,
                    ),
                    title: Text(
                      chapter,
                      style: GoogleFonts.manrope(
                        fontSize: 13.5,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? (isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep)
                            : AppColors.textPrimary(context),
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.emeraldDeep, size: 20)
                        : null,
                    onTap: () {
                      controller.selectChapter(chapter);
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }


  /// Submit Event Proposal Modal Sheet
  void _showSubmitProposalSheet(BuildContext context) {
    String selectedCategory = 'CAREER_WORKSHOP';
    String selectedFormat = 'HYBRID';
    final userEmail = Get.isRegistered<AuthStorageService>()
        ? (Get.find<AuthStorageService>().user?.email ?? '')
        : '';
    final emailController = TextEditingController(
      text: userEmail.isNotEmpty ? userEmail : 'alumni@ipam.edu.sl',
    );
    final cityController = TextEditingController(text: 'IPAM Innovation Hub, Freetown');
    final titleController = TextEditingController();
    final dateController = TextEditingController(text: 'Nov 2026');
    final attendanceController = TextEditingController(text: '50-100');
    final descController = TextEditingController();

    Get.bottomSheet(
      StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          return Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Submit Event Proposal',
                    style: GoogleFonts.libreCaslonText(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Host an official IPAM Alumni reunion, professional panel, or chapter gathering with Association support.',
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Event Title *',
                      hintText: 'e.g., Class of 2015 Ten-Year Gala',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedCategory,
                          decoration: const InputDecoration(labelText: 'Category'),
                          items: const [
                            DropdownMenuItem(value: 'CAREER_WORKSHOP', child: Text('Career Workshop')),
                            DropdownMenuItem(value: 'NETWORKING', child: Text('Networking')),
                            DropdownMenuItem(value: 'WEBINAR', child: Text('Webinar')),
                            DropdownMenuItem(value: 'GALA', child: Text('Gala')),
                            DropdownMenuItem(value: 'REGIONAL_MEETUP', child: Text('Regional Meetup')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setSheetState(() => selectedCategory = val);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedFormat,
                          decoration: const InputDecoration(labelText: 'Format'),
                          items: const [
                            DropdownMenuItem(value: 'HYBRID', child: Text('Hybrid')),
                            DropdownMenuItem(value: 'IN_PERSON', child: Text('In-Person')),
                            DropdownMenuItem(value: 'VIRTUAL', child: Text('Virtual')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setSheetState(() => selectedFormat = val);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: cityController,
                          decoration: const InputDecoration(labelText: 'Location / Venue *'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: 'Organizer Email *'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: dateController,
                          decoration: const InputDecoration(labelText: 'Proposed Date'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: attendanceController,
                          decoration: const InputDecoration(labelText: 'Expected Attendance'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Proposal Overview *',
                      hintText: 'Briefly describe your event goals, target cohort, and venue...',
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        final title = titleController.text.trim();
                        final email = emailController.text.trim();
                        final desc = descController.text.trim();
                        if (title.isEmpty) {
                          Get.snackbar(
                            'Missing Title',
                            'Please enter an event title.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }
                        if (email.isEmpty || !email.contains('@')) {
                          Get.snackbar(
                            'Invalid Email',
                            'Please enter a valid organizer email.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }
                        controller.submitProposal(
                          chapterName: cityController.text.trim(),
                          eventName: title,
                          proposedDate: dateController.text.trim(),
                          expectedAttendance: attendanceController.text.trim(),
                          description: desc.isNotEmpty ? desc : 'Alumni community proposed event',
                          category: selectedCategory,
                          format: selectedFormat,
                          organizerEmail: email,
                        );
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        foregroundColor: AppColors.charcoal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'Submit Event Proposal',
                        style: GoogleFonts.manrope(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  /// Share Event Sheet
  void _showShareSheet(BuildContext context, EventModel event) {
    Get.snackbar(
      'Invitation Link Copied',
      'Share link for "${event.title}" copied to clipboard.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.card(context),
      colorText: AppColors.textPrimary(context),
      icon: const Icon(Icons.link_rounded, color: AppColors.emeraldDeep),
      duration: const Duration(seconds: 2),
    );
  }
}
