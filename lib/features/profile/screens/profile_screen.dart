import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/profile_card_widget.dart';
import '../widgets/alumni_profile_management_widget.dart';
import '../widgets/digital_pass_card_widget.dart';
import '../widgets/pass_actions_widget.dart';
import '../widgets/account_records_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_pages.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../events/controllers/events_controller.dart';
import '../../events/widgets/event_ticket_card_widget.dart';
import '../../careers/controllers/careers_controller.dart';
import '../../careers/widgets/career_job_card_widget.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController());
    }

    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: controller.scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Institutional Top Header Bar with Theme Toggle & Synchronized Pill
              Obx(
                () => ProfileHeaderWidget(
                  avatarUrl: controller.profile.value.avatarUrl,
                  userName: controller.profile.value.fullName,
                  onThemeToggle: controller.toggleTheme,
                  onNotificationTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Profile Card: Avatar, Verified Badge, 3-Column Metrics, Edit/Share Buttons
              Obx(
                () => ProfileCardWidget(
                  profile: controller.profile.value,
                  onEditProfile: () => _showEditProfileSheet(context),
                  onShareProfile: () => _showShareProfileSheet(context),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Digital Pass & ID Section Title & Official Credential Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.badge_rounded,
                          color: Color(0xFFF59E0B),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Digital Pass & ID',
                            style: GoogleFonts.libreCaslonText(
                              fontSize: 18.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.charcoal,
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
                      color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      'OFFICIAL CREDENTIAL',
                      style: GoogleFonts.manrope(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 4. Hero Digital Pass Card with EMV Chip, QR Code, Member ID & Certified Ribbon
              Obx(
                () => DigitalPassCardWidget(
                  profile: controller.profile.value,
                  onQrTap: () => Get.toNamed(Routes.VIRTUAL_PASS),
                ),
              ),
              const SizedBox(height: 14),

              // 5. Pass Action Buttons: View Full Pass, Scan QR, Wallet & PDF
              PassActionsWidget(
                onViewPass: () => Get.toNamed(Routes.VIRTUAL_PASS),
                onScanQr: () => Get.toNamed(Routes.QR_SCANNER),
                onAddToWallet: controller.addToWallet,
                onDownloadPdf: controller.downloadPdfPass,
              ),
              const SizedBox(height: 24),

              // 6. Account & Records Grouped List (8 interactive items) & Footer
              Obx(
                () => AccountRecordsWidget(
                  profile: controller.profile.value,
                  onAcademicTap: () => _showAcademicCredentialsSheet(context),
                  onDuesTap: () => _showMembershipDuesSheet(context),
                  onMentorshipTap: controller.toggleMentor,
                  onEventsTap: () => _showMyRegisteredEventsSheet(context),
                  onSavedJobsTap: () => _showSavedJobApplicationsSheet(context),
                  onPostedJobsTap: () {
                    if (Get.isRegistered<DashboardController>()) {
                      Get.find<DashboardController>().changeTab(2);
                      if (Get.isRegistered<CareersController>()) {
                        Get.find<CareersController>().switchTab('My Postings');
                      }
                    }
                  },
                  onSecurityTap: () => _showSecuritySettingsSheet(context),
                  onSignOutTap: () => _showSignOutDialog(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Modal Sheets and Interactive Dialogs ---

  void _showEditProfileSheet(BuildContext context) {
    Get.bottomSheet(
      AlumniProfileManagementWidget(
        controller: controller,
        onClose: () => Get.back(),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
    );
  }

  void _showShareProfileSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppColors.cardBorder(context)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Alumni Credential',
              style: GoogleFonts.libreCaslonText(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Share your verified graduate identity token or link.',
              style: GoogleFonts.manrope(
                fontSize: 12.5,
                color: AppColors.textSecondary(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.qr_code_2_rounded, size: 100, color: Color(0xFF022C22)),
            ),
            const SizedBox(height: 14),
            Text(
              controller.profile.value.memberId,
              style: GoogleFonts.spaceMono(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emeraldDeep,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.copy_rounded, color: Colors.white, size: 18),
                label: Text(
                  'Copy Profile Link',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'Link Copied',
                    'Alumni public verification URL copied to clipboard.',
                    backgroundColor: AppColors.card(context),
                    colorText: AppColors.textPrimary(context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMyRegisteredEventsSheet(BuildContext context) {
    controller.loadRegisteredEvents();
    final isDark = AppColors.isDark(context);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.82,
        ),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppColors.cardBorder(context)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Registered Events & Tickets',
                        style: GoogleFonts.libreCaslonText(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(() => Text(
                        '${controller.registeredTickets.length} confirmed bookings & admission passes',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppColors.textSecondary(context),
                        ),
                      )),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingTickets.value && controller.registeredTickets.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.emeraldDeep),
                  );
                }

                if (controller.registeredTickets.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.confirmation_number_outlined,
                              size: 40,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'No Registered Events Yet',
                            style: GoogleFonts.libreCaslonText(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Explore upcoming university summits, webinars, and reunions to book your official pass.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.manrope(
                              fontSize: 12.5,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.emeraldDeep,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.calendar_month_outlined, size: 16),
                            label: const Text('Browse Events Catalog'),
                            onPressed: () {
                              Get.back();
                              if (Get.isRegistered<DashboardController>()) {
                                Get.find<DashboardController>().changeTab(3);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.registeredTickets.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final ticket = controller.registeredTickets[index];
                    return EventTicketCardWidget(
                      event: ticket,
                      attendeeName: controller.profile.value.fullName,
                      onCardTap: () {
                        Get.back();
                        Get.toNamed(Routes.EVENT_DETAILS, arguments: ticket);
                      },
                      onDownloadPass: () {
                        Get.snackbar(
                          'Pass Ready',
                          'Digital Pass #${ticket.ticketCode ?? ticket.id} verified and stored offline.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.card(context),
                          colorText: AppColors.textPrimary(context),
                        );
                      },
                      onCancelRsvp: () async {
                        await controller.cancelTicket(ticket);
                      },
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emeraldDeep,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.event_seat_rounded, color: Colors.white, size: 18),
                label: Text(
                  'Open in Events Hub (My Tickets)',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Get.back();
                  final eventsCtrl = Get.isRegistered<EventsController>()
                      ? Get.find<EventsController>()
                      : Get.put(EventsController());
                  eventsCtrl.switchTab('My Tickets');
                  eventsCtrl.loadMyTickets();
                  if (Get.isRegistered<DashboardController>()) {
                    Get.find<DashboardController>().changeTab(3);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showAcademicCredentialsSheet(BuildContext context) {
    final p = controller.profile.value;
    final isDark = AppColors.isDark(context);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppColors.cardBorder(context)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Academic Credentials & Transcripts',
                  style: GoogleFonts.libreCaslonText(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailLine('Degree Program', p.degree, isDark),
            _buildDetailLine('Class & Graduation', 'Class of ${p.graduationYear}', isDark),
            _buildDetailLine('Institution', 'University of Sierra Leone (IPAM)', isDark),
            _buildDetailLine('Campus', p.campus, isDark),
            _buildDetailLine('Registrar Status', 'Archive Synchronized & Certified ✓', isDark, isHighlight: true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emeraldDeep,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.file_download_outlined, color: Colors.white, size: 18),
                label: Text(
                  'Request Official E-Transcript',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'Transcript Request Logged',
                    'A verified USL transcript request has been routed to the Registrar office.',
                    backgroundColor: AppColors.card(context),
                    colorText: AppColors.textPrimary(context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMembershipDuesSheet(BuildContext context) {
    final p = controller.profile.value;
    final isDark = AppColors.isDark(context);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppColors.cardBorder(context)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Membership Dues & Giving',
                  style: GoogleFonts.libreCaslonText(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailLine('Status', 'Active Donor • Giving Circle', isDark, isHighlight: true),
            _buildDetailLine('Annual Contribution', '\$${p.duesAmountPaid} USD', isDark),
            _buildDetailLine('Coverage Period', 'Jan 2026 – Dec 2026', isDark),
            _buildDetailLine('Receipt Number', 'IPAM-GIVE-2026-9041', isDark),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: BorderSide(color: AppColors.cardBorder(context)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: Icon(
                      Icons.volunteer_activism_outlined,
                      size: 18,
                      color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                    ),
                    label: Text(
                      'Giving Center',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                      Get.toNamed(Routes.GIVING);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emeraldDeep,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 18),
                    label: Text(
                      'Tax Receipt',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        'Receipt Downloaded',
                        'Annual Dues contribution receipt saved to downloads.',
                        backgroundColor: AppColors.card(context),
                        colorText: AppColors.textPrimary(context),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSecuritySettingsSheet(BuildContext context) {
    final isDark = AppColors.isDark(context);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppColors.cardBorder(context)),
        ),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Security & Preferences',
                    style: GoogleFonts.libreCaslonText(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Theme Mode Toggle Switch
              SwitchListTile(
                title: Text(
                  'Dark Theme Mode',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                subtitle: Text(
                  'Toggle between light and dark visual interfaces.',
                  style: GoogleFonts.manrope(
                    fontSize: 11.5,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                secondary: Icon(
                  controller.isDarkMode.value ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: const Color(0xFFF59E0B),
                ),
                value: controller.isDarkMode.value,
                activeTrackColor: AppColors.jadeAccent,
                onChanged: (_) => controller.toggleTheme(),
              ),
              Divider(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),

              // Biometric Auth
              SwitchListTile(
                title: Text(
                  'Biometric Authentication',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                subtitle: Text(
                  'Unlock digital pass via Face ID / Touch ID.',
                  style: GoogleFonts.manrope(
                    fontSize: 11.5,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                secondary: const Icon(
                  Icons.fingerprint_rounded,
                  color: Color(0xFF10B981),
                ),
                value: controller.profile.value.biometricAuthEnabled,
                activeTrackColor: AppColors.jadeAccent,
                onChanged: controller.toggleBiometrics,
              ),
              Divider(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),

              // Directory Visibility
              SwitchListTile(
                title: Text(
                  'Alumni Directory Visibility',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                subtitle: Text(
                  'Show contact details to verified graduates.',
                  style: GoogleFonts.manrope(
                    fontSize: 11.5,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                secondary: const Icon(
                  Icons.visibility_outlined,
                  color: Color(0xFF60A5FA),
                ),
                value: controller.profile.value.directoryVisibilityEnabled,
                activeTrackColor: AppColors.jadeAccent,
                onChanged: controller.toggleDirectoryVisibility,
              ),
              Divider(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),

              // Change Password Tile
              ListTile(
                title: Text(
                  'Change Password',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                subtitle: Text(
                  'Update account security credentials.',
                  style: GoogleFonts.manrope(
                    fontSize: 11.5,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                leading: const Icon(
                  Icons.lock_reset_rounded,
                  color: Color(0xFFF59E0B),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                onTap: () {
                  Get.back();
                  _showChangePasswordDialog(context);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final curCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final isDark = AppColors.isDark(context);

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.card(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Change Password',
          style: GoogleFonts.libreCaslonText(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Password',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: curCtrl,
                obscureText: true,
                style: GoogleFonts.manrope(color: AppColors.textPrimary(context)),
                decoration: _inputDecoration(context, 'Enter current password'),
                validator: (v) => v == null || v.isEmpty ? 'Current password is required' : null,
              ),
              const SizedBox(height: 14),
              Text(
                'New Password',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: newCtrl,
                obscureText: true,
                style: GoogleFonts.manrope(color: AppColors.textPrimary(context)),
                decoration: _inputDecoration(context, 'At least 8 chars with Aa, 1, @'),
                validator: Validators.strongPassword,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emeraldDeep,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final success = await controller.changePassword(
                  currentPassword: curCtrl.text,
                  newPassword: newCtrl.text,
                );
                if (success) {
                  Get.back();
                }
              }
            },
            child: Text(
              'Update Password',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.card(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Sign Out',
          style: GoogleFonts.libreCaslonText(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
        ),
        content: Text(
          'Are you sure you want to disconnect your session on this mobile device?',
          style: GoogleFonts.manrope(
            fontSize: 13,
            color: AppColors.textSecondary(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: Text(
              'Sign Out',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }


  InputDecoration _inputDecoration(BuildContext context, String hint) {
    final isDark = AppColors.isDark(context);
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.manrope(
        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
        fontSize: 13,
      ),
      filled: true,
      fillColor: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
      ),
    );
  }

  Widget _buildDetailLine(String label, String value, bool isDark, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: isHighlight
                  ? const Color(0xFF10B981)
                  : (isDark ? Colors.white : AppColors.charcoal),
            ),
          ),
        ],
      ),
    );
  }

  void _showSavedJobApplicationsSheet(BuildContext context) {
    final careersCtrl = Get.isRegistered<CareersController>()
        ? Get.find<CareersController>()
        : Get.put(CareersController());
    careersCtrl.loadJobs();

    final isDark = AppColors.isDark(context);
    final activeSubTab = 0.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppColors.cardBorder(context)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saved Jobs & Applications',
                        style: GoogleFonts.libreCaslonText(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Obx(() => Text(
                        '${careersCtrl.savedJobsCount} saved bookmarks • ${careersCtrl.appliedCount} active applications',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppColors.textSecondary(context),
                        ),
                      )),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Segmented Sub-Tab Switcher
            Obx(
              () => Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => activeSubTab.value = 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: activeSubTab.value == 0
                                ? (isDark ? const Color(0xFF0F172A) : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: activeSubTab.value == 0
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                                      blurRadius: 4,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.bookmark_rounded,
                                  size: 14,
                                  color: activeSubTab.value == 0
                                      ? AppColors.goldWarm
                                      : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Saved (${careersCtrl.savedJobsCount})',
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: activeSubTab.value == 0 ? FontWeight.bold : FontWeight.w600,
                                      color: activeSubTab.value == 0
                                          ? AppColors.textPrimary(context)
                                          : AppColors.textSecondary(context),
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
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => activeSubTab.value = 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: activeSubTab.value == 1
                                ? (isDark ? const Color(0xFF0F172A) : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: activeSubTab.value == 1
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                                      blurRadius: 4,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.assignment_outlined,
                                  size: 14,
                                  color: activeSubTab.value == 1
                                      ? AppColors.jadeAccent
                                      : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Applied (${careersCtrl.appliedCount})',
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: activeSubTab.value == 1 ? FontWeight.bold : FontWeight.w600,
                                      color: activeSubTab.value == 1
                                          ? AppColors.textPrimary(context)
                                          : AppColors.textSecondary(context),
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
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Content List
            Expanded(
              child: Obx(() {
                if (careersCtrl.isLoading.value && careersCtrl.allJobs.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.emeraldDeep),
                  );
                }

                if (activeSubTab.value == 0) {
                  final saved = careersCtrl.savedJobs.isNotEmpty
                      ? careersCtrl.savedJobs
                      : careersCtrl.allJobs.where((j) => j.isBookmarked || careersCtrl.savedJobIds.contains(j.id)).toList();

                  if (saved.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bookmark_border_rounded,
                            size: 48,
                            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Saved Jobs Yet',
                            style: GoogleFonts.libreCaslonText(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'Tap the bookmark icon on any job card in Careers to save openings here for later review.',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                color: AppColors.textSecondary(context),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: saved.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, idx) {
                      final job = saved[idx];
                      return CareerJobCardWidget(
                        job: job,
                        onApply: () => careersCtrl.applyJob(job),
                        onBookmark: () => careersCtrl.toggleBookmark(job),
                        onViewDetails: () {
                          Get.back();
                          if (Get.isRegistered<DashboardController>()) {
                            Get.find<DashboardController>().changeTab(2);
                          }
                        },
                      );
                    },
                  );
                } else {
                  final apps = careersCtrl.applications;
                  if (apps.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.work_outline_rounded,
                            size: 48,
                            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Submitted Applications',
                            style: GoogleFonts.libreCaslonText(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'Apply with your IPAM profile directly to verified openings in the Careers portal.',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                color: AppColors.textSecondary(context),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: apps.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, idx) {
                      final app = apps[idx];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.emeraldDeep.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.business_rounded,
                                color: AppColors.emeraldDeep,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    app.title,
                                    style: GoogleFonts.manrope(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary(context),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${app.company} • ${app.appliedDate}',
                                    style: GoogleFonts.manrope(
                                      fontSize: 11.5,
                                      color: AppColors.textSecondary(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                app.status,
                                style: GoogleFonts.manrope(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF10B981),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              }),
            ),
            const SizedBox(height: 12),

            // Button to Explore All Careers
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  if (Get.isRegistered<DashboardController>()) {
                    Get.find<DashboardController>().changeTab(2);
                  }
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: Text(
                  'Explore All Careers & Openings',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emeraldDeep,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
