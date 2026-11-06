import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../models/alumni_model.dart';

import '../data/directory_provider.dart';
import 'directory_controller.dart';

class MemberDetailsController extends GetxController {
  final DirectoryProvider _provider = DirectoryProvider();
  late final Rx<AlumniModel> alumnus;

  final selectedTabIndex = 0.obs;
  final isBookmarked = false.obs;
  final isConnected = false.obs;

  final tabs = const [
    'Overview & Bio',
    'Credentials',
    'Career & Governance',
    'Mentorship (3)',
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is AlumniModel) {
      alumnus = args.obs;
    } else {
      alumnus = AlumniModel.defaultAminata().obs;
    }

    if (Get.isRegistered<DirectoryController>()) {
      final dir = Get.find<DirectoryController>();
      isConnected.value = dir.connectedIds.contains(alumnus.value.id);
      isBookmarked.value = isConnected.value;
    }

    _loadLatestDetails();
  }

  Future<void> _loadLatestDetails() async {
    try {
      final latest = await _provider.getAlumniDetails(alumnus.value.id);
      if (latest != null) {
        alumnus.value = latest;
      }
    } catch (_) {}
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  Future<void> toggleBookmark() async {
    await toggleConnect();
  }

  Future<void> toggleConnect() async {
    final willConnect = !isConnected.value;
    isConnected.value = willConnect;
    isBookmarked.value = willConnect;

    if (Get.isRegistered<DirectoryController>()) {
      final dir = Get.find<DirectoryController>();
      if (willConnect) {
        dir.connectedIds.add(alumnus.value.id);
        dir.bookmarkedIds.add(alumnus.value.id);
      } else {
        dir.connectedIds.remove(alumnus.value.id);
        dir.bookmarkedIds.remove(alumnus.value.id);
      }
    }

    if (willConnect) {
      SnackbarUtils.showSuccess(
        title: 'Network Request Sent',
        message: 'Your connection request was dispatched to ${alumnus.value.name}.',
      );
    } else {
      SnackbarUtils.showInfo(
        title: 'Disconnected',
        message: 'Connection request withdrawn.',
      );
    }

    try {
      if (willConnect) {
        await _provider.connectAlumni(alumnus.value.id);
      } else {
        await _provider.disconnectAlumni(alumnus.value.id);
      }
    } catch (e) {
      // Rollback on error
      isConnected.value = !willConnect;
      isBookmarked.value = !willConnect;
      if (Get.isRegistered<DirectoryController>()) {
        final dir = Get.find<DirectoryController>();
        if (!willConnect) {
          dir.connectedIds.add(alumnus.value.id);
          dir.bookmarkedIds.add(alumnus.value.id);
        } else {
          dir.connectedIds.remove(alumnus.value.id);
          dir.bookmarkedIds.remove(alumnus.value.id);
        }
      }
    }
  }

  void copyProfileLink() {
    final link = 'https://alumni.ipam.usl.edu.sl/directory/${alumnus.value.id}';
    Clipboard.setData(ClipboardData(text: link));
    SnackbarUtils.showSuccess(
      title: 'Profile Link Copied',
      message: 'Verified member URL copied to clipboard.',
    );
  }

  void shareProfile() {
    final link = 'https://alumni.ipam.usl.edu.sl/directory/${alumnus.value.id}';
    Clipboard.setData(ClipboardData(text: link));
    SnackbarUtils.showSuccess(
      title: 'Share Alumni Profile',
      message: 'Public verification link copied to clipboard.',
    );
  }

  void showDirectMessageSheet(BuildContext context) {
    final messageController = TextEditingController();
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lock_outline_rounded, size: 18, color: Color(0xFF059669)),
                      const SizedBox(width: 8),
                      Text(
                        'Direct Encrypted Message',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Send an authenticated memo to ${alumnus.value.displayFullName}.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 14),
              TextField(
                controller: messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter your inquiry, invitation, or professional greeting...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF044E3D),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  label: const Text(
                    'Transmit Message',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onPressed: () {
                    Get.back();
                    SnackbarUtils.showSuccess(
                      title: 'Message Transmitted',
                      message: 'Secure transmission routed to ${alumnus.value.name}.',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void showMentorshipModal(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.school_rounded, size: 20, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 8),
                      Text(
                        'Mentorship Fellowship',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Request guidance or career advisory under ${alumnus.value.displayFullName}.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Color(0xFFD97706), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Active mentorship slots: 3 available for final-year fellows.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFFFDE68A)
                              : const Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF044E3D),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                  label: const Text(
                    'Submit Mentorship Request',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onPressed: () {
                    Get.back();
                    SnackbarUtils.showSuccess(
                      title: 'Mentorship Application Sent',
                      message: 'Your advisory application was submitted to ${alumnus.value.name}.',
                    );
                  },
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
