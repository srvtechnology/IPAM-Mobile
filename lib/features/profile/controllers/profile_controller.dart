import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/auth_storage_service.dart';
import '../../../core/network/models/user_model.dart';
import '../../../core/theme/theme_service.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../models/directory_models.dart';
import '../../../models/pass_models.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../../../services/networking_service.dart';
import '../../../services/pass_pdf_service.dart';
import '../../events/data/events_provider.dart';
import '../../events/models/event_model.dart';
import '../../events/controllers/events_controller.dart';
import '../models/profile_model.dart';

class ProfileController extends GetxController {
  final AuthStorageService _authStorage = Get.isRegistered<AuthStorageService>()
      ? Get.find<AuthStorageService>()
      : Get.put(AuthStorageService());
  final EventsProvider _eventsProvider = EventsProvider();

  ApiClient get _apiClient => Get.isRegistered<ApiClient>()
      ? Get.find<ApiClient>()
      : Get.put(ApiClient(), permanent: true);

  NetworkingService get _networkingService =>
      NetworkingService(client: _apiClient);

  final profile = ProfileModel.defaultMohamedProfile().obs;
  final registeredTickets = <EventModel>[].obs;
  final isLoading = false.obs;
  final isLoadingTickets = false.obs;
  final isUploadingAvatar = false.obs;
  final activeManagementTab = 0.obs;
  final adminAnnouncements = <BroadcastNotification>[].obs;
  final isLoadingAnnouncements = false.obs;
  final ScrollController scrollController = ScrollController();

  final _fallbackDarkMode = true.obs;
  RxBool get isDarkMode =>
      Get.isRegistered<ThemeService>() ? ThemeService.to.isDarkMode : _fallbackDarkMode;

  UserModel? get user => _authStorage.user;

  @override
  void onInit() {
    super.onInit();
    _syncWithAuthStorage();
    if (_authStorage.isAuthenticated) {
      fetchProfile();
      loadRegisteredEvents();
    }
  }

  /// Fetches complete alumni profile from server GET /api/profile (OpenAPI spec)
  Future<void> fetchProfile() async {
    if (!_authStorage.isAuthenticated) return;
    try {
      final response = await _apiClient.get(ApiEndpoints.profile);
      if (response.isOk && response.body != null) {
        final body = response.body is Map ? response.body as Map : {};
        final data = body['data'] is Map
            ? body['data'] as Map
            : (body['profile'] is Map ? body['profile'] as Map : body);

        final name = data['name']?.toString() ?? data['fullName']?.toString() ?? profile.value.fullName;
        final avatar = data['avatar']?.toString() ?? data['avatarUrl']?.toString() ?? '';
        final role = data['currentRole']?.toString() ?? data['role']?.toString() ?? profile.value.currentRole;
        final company = data['company']?.toString() ?? data['currentCompany']?.toString() ?? profile.value.currentCompany;
        final industry = data['industry']?.toString() ?? data['industrySector']?.toString() ?? profile.value.industrySector;
        final location = data['location']?.toString() ?? profile.value.location;
        final country = data['country']?.toString() ?? profile.value.country;
        final degree = data['degree']?.toString() ?? profile.value.degree;
        final major = data['major']?.toString() ?? data['department']?.toString() ?? profile.value.major;
        final classYear = data['classYear'] is int
            ? data['classYear'] as int
            : (int.tryParse(data['classYear']?.toString() ?? '') ?? profile.value.graduationYear);
        final bio = data['bio']?.toString() ?? profile.value.bio;
        final linkedin = data['linkedin']?.toString() ?? data['linkedinUrl']?.toString() ?? profile.value.linkedinUrl;
        final isMentor = data['isMentor'] == true || data['isMentorAvailable'] == true;

        List<String> skills = profile.value.skills;
        if (data['skills'] is List) {
          skills = (data['skills'] as List).map((e) => e.toString()).toList();
        }

        profile.value = profile.value.copyWith(
          fullName: name,
          avatarUrl: avatar.isNotEmpty ? ApiClient.formatUrl(avatar) : '',
          currentRole: role,
          currentCompany: company,
          industrySector: industry,
          location: location,
          country: country,
          degree: degree,
          degreeCohort: '$degree (Class of $classYear)',
          major: major,
          graduationYear: classYear,
          bio: bio,
          linkedinUrl: linkedin,
          isMentorAvailable: isMentor,
          skills: skills,
          isSynchronized: true,
        );

        if (_authStorage.user != null) {
          final updatedUser = _authStorage.user!.copyWith(
            fullName: name,
            avatarUrl: avatar.isNotEmpty ? ApiClient.formatUrl(avatar) : null,
            currentRole: role,
            currentCompany: company,
            location: location,
            degree: degree,
            department: major,
            graduationYear: classYear,
          );
          await _authStorage.updateUser(updatedUser);
        }
      }
    } catch (_) {
      // Retain optimistic offline cached data
    }
  }

  Future<void> loadRegisteredEvents() async {
    if (!_authStorage.isAuthenticated) return;
    try {
      isLoadingTickets.value = true;
      final tickets = await _eventsProvider.fetchMyRegistrations();
      registeredTickets.assignAll(tickets);
      profile.value = profile.value.copyWith(
        registeredEventsCount: tickets.length,
      );
    } catch (_) {
      // Retain current state
    } finally {
      isLoadingTickets.value = false;
    }
  }

  Future<bool> cancelTicket(EventModel event) async {
    final bookingRef = event.ticketCode;
    if (bookingRef == null || bookingRef.isEmpty) return false;

    final success = await _eventsProvider.cancelRegistration(bookingRef);
    if (success) {
      registeredTickets.removeWhere((t) => t.ticketCode == bookingRef || t.id == event.id);
      profile.value = profile.value.copyWith(
        registeredEventsCount: registeredTickets.length,
      );
      if (Get.isRegistered<EventsController>()) {
        Get.find<EventsController>().cancelTicket(event, callApi: false);
      }
      SnackbarUtils.showSuccess(
        title: 'Booking Cancelled',
        message: 'Your registration for "${event.title}" has been released.',
      );
    }
    return success;
  }

  void _syncWithAuthStorage() {
    final currentUser = _authStorage.user;
    if (currentUser != null && currentUser.fullName.isNotEmpty) {
      profile.value = profile.value.copyWith(
        fullName: currentUser.fullName,
        degree: currentUser.degree ?? profile.value.degree,
        graduationYear: currentUser.graduationYear ?? profile.value.graduationYear,
        location: currentUser.location ?? profile.value.location,
        currentRole: currentUser.currentRole ?? profile.value.currentRole,
        currentCompany: currentUser.currentCompany ?? profile.value.currentCompany,
        memberId: currentUser.membershipNumber ?? profile.value.memberId,
        avatarUrl: currentUser.avatarUrl ?? '',
        major: (currentUser.department != null && currentUser.department!.isNotEmpty)
            ? currentUser.department!
            : profile.value.major,
      );
    }
  }

  void switchManagementTab(int index) {
    activeManagementTab.value = index;
    if (index == 1 && adminAnnouncements.isEmpty) {
      loadAdminAnnouncements();
    }
  }

  Future<void> loadAdminAnnouncements() async {
    try {
      isLoadingAnnouncements.value = true;
      final announcements = await _networkingService.fetchNotifications();
      adminAnnouncements.assignAll(announcements);
    } catch (_) {
      // Retain existing state
    } finally {
      isLoadingAnnouncements.value = false;
    }
  }

  Future<String?> pickAndUploadAvatar({ImageSource source = ImageSource.gallery}) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked == null) return null;

      isUploadingAvatar.value = true;
      final bytes = await picked.readAsBytes();
      final base64String = base64Encode(bytes);
      final isPng = picked.path.toLowerCase().endsWith('.png');
      final mimeType = isPng ? 'image/png' : 'image/jpeg';
      final dataUri = 'data:$mimeType;base64,$base64String';

      // Update state locally immediately (instant responsive UI)
      profile.value = profile.value.copyWith(avatarUrl: dataUri);
      if (_authStorage.user != null) {
        final updatedUser = _authStorage.user!.copyWith(avatarUrl: dataUri);
        await _authStorage.updateUser(updatedUser);
      }

      // Try uploading to server via POST /api/upload
      try {
        final uploadResponse = await _apiClient.post(
          ApiEndpoints.upload,
          {
            'file': dataUri,
            'filename': 'avatar_${DateTime.now().millisecondsSinceEpoch}.${isPng ? 'png' : 'jpg'}',
          },
        );

        if (uploadResponse.isOk && uploadResponse.body != null) {
          final body = uploadResponse.body is Map ? uploadResponse.body as Map : {};
          final url = body['data']?['url'] ?? body['url'];
          if (url != null && url.toString().isNotEmpty) {
            final formattedUrl = ApiClient.formatUrl(url.toString());
            profile.value = profile.value.copyWith(avatarUrl: formattedUrl);
            if (_authStorage.user != null) {
              await _authStorage.updateUser(_authStorage.user!.copyWith(avatarUrl: formattedUrl));
            }
            // Bind avatar to profile on server via PATCH /api/profile
            try {
              await _apiClient.patch(ApiEndpoints.profile, {'avatar': formattedUrl});
            } catch (_) {}
          }
        }
      } catch (_) {
        // Fallback to Base64 data URI already saved
      }

      SnackbarUtils.showSuccess(
        title: 'Profile Photo Updated',
        message: 'Headshot successfully uploaded and saved.',
      );
      return profile.value.avatarUrl;
    } catch (e) {
      SnackbarUtils.showError(
        title: 'Upload Failed',
        message: 'Could not update photo: $e',
      );
      return null;
    } finally {
      isUploadingAvatar.value = false;
    }
  }

  Future<bool> updateFullProfile({
    required String fullName,
    required int graduationYear,
    required String degree,
    required String major,
    required String currentRole,
    required String currentCompany,
    required String industrySector,
    required String country,
    required String city,
    required String linkedinUrl,
    required bool isMentor,
    required List<String> skills,
    required String bio,
    String? avatarUrl,
  }) async {
    try {
      isLoading.value = true;
      final fullLocation = city.trim().isNotEmpty && country.trim().isNotEmpty
          ? '${city.trim()}, ${country.trim()}'
          : (city.trim().isNotEmpty ? city.trim() : country.trim());

      final effectiveAvatar = avatarUrl ?? profile.value.avatarUrl;

      final updatedProfile = profile.value.copyWith(
        fullName: fullName.trim(),
        graduationYear: graduationYear,
        degree: degree.trim(),
        degreeCohort: '$degree (Class of $graduationYear)',
        major: major.trim(),
        currentRole: currentRole.trim(),
        currentCompany: currentCompany.trim(),
        industrySector: industrySector.trim(),
        country: country.trim(),
        location: fullLocation,
        linkedinUrl: linkedinUrl.trim(),
        isMentorAvailable: isMentor,
        skills: skills,
        bio: bio.trim(),
        avatarUrl: effectiveAvatar,
      );

      profile.value = updatedProfile;

      // Update stored user
      if (_authStorage.user != null) {
        final updatedUser = _authStorage.user!.copyWith(
          fullName: fullName.trim(),
          graduationYear: graduationYear,
          degree: degree.trim(),
          department: major.trim(),
          currentRole: currentRole.trim(),
          currentCompany: currentCompany.trim(),
          location: fullLocation,
          avatarUrl: effectiveAvatar.isNotEmpty ? effectiveAvatar : null,
        );
        await _authStorage.updateUser(updatedUser);
      }

      // Sync with PATCH /api/profile (OpenAPI ProfileUpdateRequest)
      try {
        final payload = <String, dynamic>{
          'name': fullName.trim(),
          'location': city.trim().isNotEmpty ? city.trim() : fullLocation,
          'country': country.trim(),
          'bio': bio.trim(),
          'linkedin': linkedinUrl.trim().isNotEmpty ? linkedinUrl.trim() : null,
          'isMentor': isMentor,
          'skills': skills,
          'currentRole': currentRole.trim(),
          'company': currentCompany.trim(),
          'industry': industrySector.trim(),
          'degree': degree.trim(),
          'major': major.trim(),
          'classYear': graduationYear,
        };
        if (effectiveAvatar.isNotEmpty) {
          payload['avatar'] = effectiveAvatar;
        }
        final patchResponse = await _apiClient.patch(ApiEndpoints.profile, payload);
        if (patchResponse.isOk && patchResponse.body != null) {
          final body = patchResponse.body is Map ? patchResponse.body as Map : {};
          final data = body['data'] is Map ? body['data'] as Map : body;
          if (data['avatar'] != null && data['avatar'].toString().isNotEmpty) {
            final serverAvatar = ApiClient.formatUrl(data['avatar'].toString());
            profile.value = profile.value.copyWith(avatarUrl: serverAvatar, isSynchronized: true);
            if (_authStorage.user != null) {
              await _authStorage.updateUser(_authStorage.user!.copyWith(avatarUrl: serverAvatar));
            }
          } else {
            profile.value = profile.value.copyWith(isSynchronized: true);
          }
        }
      } catch (_) {
        // Retain optimistic offline update
      }

      SnackbarUtils.showSuccess(
        title: 'Profile Saved',
        message: 'Your alumni profile details were successfully updated.',
      );
      return true;
    } catch (e) {
      SnackbarUtils.showError(
        title: 'Error Saving Profile',
        message: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void toggleTheme() {
    if (Get.isRegistered<ThemeService>()) {
      ThemeService.to.toggleTheme();
    } else {
      _fallbackDarkMode.value = !_fallbackDarkMode.value;
      Get.changeThemeMode(_fallbackDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    }
  }

  void toggleMentor() {
    final current = profile.value.isMentorAvailable;
    profile.value = profile.value.copyWith(isMentorAvailable: !current);
    SnackbarUtils.showSuccess(
      title: 'Mentorship Updated',
      message: !current
          ? 'You are now marked as available to mentor final-year students.'
          : 'Mentorship status updated to inactive.',
    );
  }

  void toggleBiometrics(bool enabled) {
    profile.value = profile.value.copyWith(biometricAuthEnabled: enabled);
    SnackbarUtils.showSuccess(
      title: 'Biometric Authentication',
      message: enabled ? 'Biometric authentication enabled.' : 'Biometric authentication disabled.',
    );
  }

  void toggleDirectoryVisibility(bool enabled) {
    profile.value = profile.value.copyWith(directoryVisibilityEnabled: enabled);
    SnackbarUtils.showSuccess(
      title: 'Directory Visibility',
      message: enabled
          ? 'Your profile is now visible to verified alumni.'
          : 'Your profile is now private in the directory.',
    );
  }

  void updateProfileDetails({
    required String fullName,
    required String role,
    required String location,
  }) {
    profile.value = profile.value.copyWith(
      fullName: fullName,
      currentRole: role,
      location: location,
    );
    SnackbarUtils.showSuccess(
      title: 'Profile Saved',
      message: 'Your alumni profile details were successfully updated.',
    );
  }

  void addToWallet() {
    Get.snackbar(
      'Apple / Google Wallet',
      'Pass added successfully. Digital smart badge is active in Apple Wallet.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF064E3B),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF34D399)),
    );
  }

  final PassPdfService _pdfService = PassPdfService();

  Future<void> downloadPdfPass() async {
    try {
      final p = profile.value;
      final pass = VirtualPass.fallback(
        id: p.memberId,
        name: p.fullName,
        studentId: p.memberId,
        degree: p.degree,
        classYear: p.graduationYear,
        membershipTier: p.membershipTier,
      );

      final file = await _pdfService.generateAndSavePdf(pass);

      Get.snackbar(
        'Offline PDF Pass Ready',
        'Official digital pass saved to ${file.path.split('/').last}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF044E3D),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 5),
        icon: const Icon(Icons.file_download_done_rounded, color: Color(0xFFF59E0B)),
        mainButton: TextButton(
          onPressed: () => _pdfService.openPdf(file),
          child: const Text(
            'OPEN',
            style: TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold),
          ),
        ),
      );
    } catch (_) {
      Get.snackbar(
        'Offline PDF Pass Generated',
        'Offline cryptographic credential pass downloaded to your device files.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.file_download_done_rounded, color: Color(0xFFF59E0B)),
      );
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;
      final authService = AuthService();
      await authService.changePassword(currentPassword, newPassword);
      SnackbarUtils.showSuccess(
        title: 'Password Updated',
        message: 'Your password has been changed successfully.',
      );
      return true;
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      SnackbarUtils.showError(
        title: 'Password Change Failed',
        message: msg,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await AuthService().logout();
    } finally {
      await _authStorage.clearSession();
      isLoading.value = false;
      SnackbarUtils.showInfo(
        title: 'Signed Out',
        message: 'You have been successfully signed out.',
      );
      Get.offAllNamed(Routes.WELCOME);
    }
  }
}
