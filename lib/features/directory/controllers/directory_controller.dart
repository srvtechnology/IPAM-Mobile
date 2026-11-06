import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/auth_storage_service.dart';
import '../data/directory_provider.dart';
import '../models/alumni_model.dart';

class DirectoryController extends GetxController {
  final DirectoryProvider _provider;

  DirectoryController({DirectoryProvider? provider})
      : _provider = provider ?? DirectoryProvider();

  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final alumniList = <AlumniModel>[].obs;
  final filteredList = <AlumniModel>[].obs;

  final categories = [
    'All (5.4k)',
    'Executive Council',
    'Finance & Accounting',
    'Public Admin',
    'Mentors',
  ];

  final selectedCategory = 'All (5.4k)'.obs;

  final chapters = [
    'All Chapters',
    'Sierra Leone',
    'United Kingdom',
    'West Africa',
  ];

  final selectedChapter = 'All Chapters'.obs;

  final bookmarkedIds = <String>{}.obs;
  final connectedIds = <String>{}.obs;
  final connectingId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAlumni();
    loadConnections();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadAlumni() async {
    isLoading.value = true;
    try {
      final list = await _provider.fetchAlumni(
        category: selectedCategory.value,
        chapter: selectedChapter.value,
      );
      alumniList.assignAll(list);
      _applyFilter();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadConnections() async {
    final authStorage = Get.isRegistered<AuthStorageService>() ? Get.find<AuthStorageService>() : null;
    if (authStorage != null && !authStorage.isAuthenticated) return;

    try {
      final bookmarks = await _provider.fetchBookmarks();
      for (final item in bookmarks) {
        if (item.id.isNotEmpty) {
          connectedIds.add(item.id);
          bookmarkedIds.add(item.id);
        }
      }
    } catch (_) {}
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _applyFilter();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    _applyFilter();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    _applyFilter();
  }

  void selectChapter(String chapter) {
    selectedChapter.value = chapter;
    _applyFilter();
  }

  Future<void> toggleBookmark(String id) async {
    final alumnus = alumniList.firstWhereOrNull((a) => a.id == id);
    final name = alumnus?.name ?? 'Alumni';
    await toggleConnect(id, name);
  }

  Future<void> toggleConnect(String id, String name) async {
    if (connectingId.value == id) return;
    connectingId.value = id;

    final wasConnected = connectedIds.contains(id);

    // Optimistic UI state update
    if (wasConnected) {
      connectedIds.remove(id);
      bookmarkedIds.remove(id);
      if (Get.context != null) {
        Get.snackbar(
          'Connection Removed',
          'Disconnected from $name',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } else {
      connectedIds.add(id);
      bookmarkedIds.add(id);
      if (Get.context != null) {
        Get.snackbar(
          'Connection Request Sent',
          'Invitation sent to $name',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    }

    try {
      if (wasConnected) {
        await _provider.disconnectAlumni(id);
      } else {
        await _provider.connectAlumni(id);
      }
    } catch (e) {
      // Rollback on network failure
      if (wasConnected) {
        connectedIds.add(id);
        bookmarkedIds.add(id);
      } else {
        connectedIds.remove(id);
        bookmarkedIds.remove(id);
      }
      if (Get.context != null) {
        Get.snackbar(
          'Connection Error',
          e.toString().replaceAll('Exception: ', ''),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      connectingId.value = '';
    }
  }

  void _applyFilter() {
    final query = searchQuery.value.trim().toLowerCase();
    final cat = selectedCategory.value;
    final chap = selectedChapter.value;

    filteredList.assignAll(
      alumniList.where((alumnus) {
        final matchesQuery = query.isEmpty ||
            alumnus.name.toLowerCase().contains(query) ||
            alumnus.role.toLowerCase().contains(query) ||
            alumnus.faculty.toLowerCase().contains(query) ||
            alumnus.location.toLowerCase().contains(query) ||
            alumnus.graduationYear.toString().contains(query) ||
            (alumnus.company != null && alumnus.company!.toLowerCase().contains(query)) ||
            (alumnus.currentRole != null && alumnus.currentRole!.toLowerCase().contains(query));

        final matchesCat = cat == 'All (5.4k)' ||
            alumnus.category == cat ||
            (cat == 'Executive Council' && alumnus.isExecutiveLeader) ||
            (cat == 'Mentors' && alumnus.isMentor);

        final matchesChap = chap == 'All Chapters' || alumnus.chapter == chap;

        return matchesQuery && matchesCat && matchesChap;
      }).toList(),
    );
  }
}
