import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/directory_controller.dart';
import '../models/alumni_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_service.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/network/auth_storage_service.dart';
import '../../profile/widgets/profile_avatar_view.dart';
import '../../../routes/app_pages.dart';

class DirectoryScreen extends GetView<DirectoryController> {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<DirectoryController>()) {
      Get.put(DirectoryController());
    }

    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Bar Header (matching screenshots with Crest, IPAM Alumni, Bell, Avatar, Theme toggle)
            _buildTopBar(context, isDark),

            // 2. Sub-Header: Global Directory & All Chapters Pill
            _buildGlobalDirectoryHeader(context, isDark),

            // 3. Search Bar
            _buildSearchBar(context, isDark),

            const SizedBox(height: 8),

            // 4. Horizontal Category Filter Chips
            _buildCategoryFilterRow(context, isDark),

            const SizedBox(height: 8),

            // 5. Results Count
            _buildResultsCounter(context, isDark),

            const SizedBox(height: 4),

            // 6. Alumni Cards List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const LoadingWidget(message: 'Loading verified alumni...');
                }

                if (controller.filteredList.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.person_search_outlined,
                    title: 'No Alumni Found',
                    message: 'No members matched your search or chapter criteria.',
                    buttonText: 'Reset Filters',
                    onButtonPressed: () {
                      controller.clearSearch();
                      controller.selectCategory('All (5.4k)');
                      controller.selectChapter('All Chapters');
                    },
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 24),
                  itemCount: controller.filteredList.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final alumnus = controller.filteredList[index];
                    return _buildAlumniCard(context, alumnus, isDark);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Top Bar with IPAM Crest, USL Subtitle, Theme Toggle, Notification Bell & User Avatar
  Widget _buildTopBar(BuildContext context, bool isDark) {
    final authUser = Get.isRegistered<AuthStorageService>()
        ? Get.find<AuthStorageService>().user
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo & Title
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.emeraldDarker,
                    border: Border.all(
                      color: AppColors.goldWarm.withValues(alpha: 0.8),
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.school_rounded,
                      color: AppColors.goldLight,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'IPAM ',
                          style: GoogleFonts.libreCaslonText(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                          ),
                        ),
                        TextSpan(
                          text: 'Alumni',
                          style: GoogleFonts.libreCaslonText(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'USL • TOWER HILL',
                    style: GoogleFonts.manrope(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.goldWarm,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
          // Action Buttons: Theme Toggle + Notification Bell + User Avatar
          Row(
            children: [
              // Theme Toggle Button
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  color: isDark ? AppColors.goldHighlight : AppColors.charcoal,
                  size: 22,
                ),
                tooltip: isDark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
                onPressed: () {
                  if (Get.isRegistered<ThemeService>()) {
                    ThemeService.to.toggleTheme();
                  } else {
                    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                  }
                },
              ),
              // Notification Bell with Gold indicator dot
              InkWell(
                onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: isDark ? Colors.white70 : const Color(0xFF475569),
                        size: 24,
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: AppColors.goldWarm,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.background(context),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // User Avatar
              ProfileAvatarView(
                avatarUrl: authUser?.avatarUrl ?? '',
                name: authUser?.fullName ?? 'Alumni',
                username: authUser?.email,
                size: 36,
                borderWidth: 1.5,
                borderColor: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Global Directory Sub-header with shield badge and Chapter Selector dropdown pill
  Widget _buildGlobalDirectoryHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Green Shield Icon + Global Directory + 5,400+ Verified Members Worldwide
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF042F2C) : const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.gpp_good_rounded,
                      color: Color(0xFF059669),
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Global Directory',
                        style: GoogleFonts.libreCaslonText(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              '5,400+ Verified Members Worldwide',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
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
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Right: All Chapters ▾ Dropdown Pill
          Obx(
            () => InkWell(
              onTap: () => _showChapterSelector(context, isDark),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.public_rounded,
                      size: 16,
                      color: Color(0xFFEA580C),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      controller.selectedChapter.value,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: AppColors.textSecondary(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Chapter selector bottom sheet modal
  void _showChapterSelector(BuildContext context, bool isDark) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Chapter',
                  style: GoogleFonts.libreCaslonText(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...controller.chapters.map((chapter) {
              return Obx(() {
                final isSelected = controller.selectedChapter.value == chapter;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.location_city_rounded,
                    color: isSelected ? AppColors.emeraldDeep : AppColors.textSecondary(context),
                  ),
                  title: Text(
                    chapter,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? (isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep)
                          : AppColors.textPrimary(context),
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                        )
                      : null,
                  onTap: () {
                    controller.selectChapter(chapter);
                    Get.back();
                  },
                );
              });
            }),
          ],
        ),
      ),
    );
  }

  /// Search input matching Screenshot 2
  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.onSearchChanged,
        style: TextStyle(
          fontSize: 13.5,
          color: AppColors.textPrimary(context),
        ),
        decoration: InputDecoration(
          hintText: 'Search by name, company, graduation year, or department...',
          hintStyle: TextStyle(
            fontSize: 12.5,
            color: AppColors.textTertiary(context),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textTertiary(context),
            size: 20,
          ),
          suffixIcon: Obx(
            () => controller.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 18,
                      color: AppColors.textSecondary(context),
                    ),
                    onPressed: controller.clearSearch,
                  )
                : const SizedBox.shrink(),
          ),
          filled: true,
          fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  /// Category filter chips: All (5.4k), Executive Council, Finance & Accounting, Public Admin
  Widget _buildCategoryFilterRow(BuildContext context, bool isDark) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = controller.categories[index];
          return Obx(() {
            final isSelected = controller.selectedCategory.value == cat;
            return GestureDetector(
              onTap: () => controller.selectCategory(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? AppColors.darkTealPillBg : AppColors.emeraldDeep)
                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? (isDark ? AppColors.darkTealPillBorder : AppColors.emeraldDeep)
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                ),
                child: Center(
                  child: Text(
                    cat,
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? (isDark ? AppColors.darkTealPillText : Colors.white)
                          : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF334155)),
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  /// Results counter: Showing 5 Alumni matches
  Widget _buildResultsCounter(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Obx(
            () => RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Showing ',
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                  TextSpan(
                    text: '${controller.filteredList.length} Alumni',
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  TextSpan(
                    text: ' matches',
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Alumni Card matching Screenshot 2 & 3
  Widget _buildAlumniCard(BuildContext context, AlumniModel alumnus, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.MEMBER_DETAILS, arguments: alumnus);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border(context),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section: Avatar with Green Check badge + Name + USL Verified badge + Bookmark
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with overlapping verified badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: isDark ? const Color(0xFF134E4A) : AppColors.jadeSoft,
                    backgroundImage: (alumnus.avatarUrl.isNotEmpty) ? NetworkImage(alumnus.avatarUrl) : null,
                    child: (alumnus.avatarUrl.isEmpty)
                        ? Text(
                            alumnus.initials,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      padding: const EdgeInsets.all(1.5),
                      decoration: BoxDecoration(
                        color: AppColors.card(context),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Color(0xFF059669),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Name, Verified Pill, Bookmark, Role, Faculty
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + USL Verified badge + Bookmark icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Text(
                                alumnus.name,
                                style: GoogleFonts.libreCaslonText(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              // USL Verified Pill
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.verifiedBg(context),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.shield,
                                      size: 12,
                                      color: AppColors.verifiedText(context),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      'USL Verified',
                                      style: GoogleFonts.manrope(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.verifiedText(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Bookmark icon
                        Obx(() {
                          final isBookmarked = controller.bookmarkedIds.contains(alumnus.id);
                          return InkWell(
                            onTap: () => controller.toggleBookmark(alumnus.id),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                color: isBookmarked ? AppColors.goldWarm : const Color(0xFF94A3B8),
                                size: 20,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Role / Title
                    Text(
                      alumnus.role,
                      style: GoogleFonts.manrope(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTealPillText : const Color(0xFF044E3D),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // Faculty / Department
                    Text(
                      alumnus.faculty,
                      style: GoogleFonts.manrope(
                        fontSize: 11.5,
                        color: AppColors.textSecondary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Tag pills row: Class of [year] & Location / Campus
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              // Class Year
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.pillBg(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 14,
                      color: isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Class of ${alumnus.graduationYear}',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.pillText(context),
                      ),
                    ),
                  ],
                ),
              ),
              // Campus / City Location
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.pillBg(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Color(0xFFEA580C),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      alumnus.location,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.pillText(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Bottom row: Role Badge (Left) & Actions [Message, Connect] (Right)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Role / Mentor indicator
              Expanded(
                child: Row(
                  children: [
                    if (alumnus.isExecutiveLeader) ...[
                      const Icon(
                        Icons.workspace_premium_outlined,
                        size: 16,
                        color: Color(0xFF059669),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Executive Council Leader',
                          style: GoogleFonts.manrope(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ] else if (alumnus.isMentor) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Active Mentor',
                          style: GoogleFonts.manrope(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Right: Message & Connect Buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Message Button (Outlined/Soft) - commented out
                  /*
                  InkWell(
                    onTap: () {
                      Get.snackbar(
                        'Direct Message',
                        'Opening encrypted chat with ${alumnus.name}',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 14,
                            color: AppColors.textPrimary(context),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Message',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  */
                  // Connect Button (Deep Emerald Filled)
                  Obx(() {
                    final isConnected = controller.connectedIds.contains(alumnus.id);
                    final isConnecting = controller.connectingId.value == alumnus.id;
                    return InkWell(
                      onTap: () => controller.toggleConnect(alumnus.id, alumnus.name),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isConnected
                              ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0))
                              : AppColors.emeraldDeep,
                          borderRadius: BorderRadius.circular(8),
                          border: isConnected
                              ? Border.all(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                                )
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isConnecting)
                              SizedBox(
                                width: 13,
                                height: 13,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isConnected ? AppColors.emeraldDeep : Colors.white,
                                  ),
                                ),
                              )
                            else
                              Icon(
                                isConnected ? Icons.check_circle_outline_rounded : Icons.person_add_alt_1_rounded,
                                size: 14,
                                color: isConnected
                                    ? (isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep)
                                    : Colors.white,
                              ),
                            const SizedBox(width: 5),
                            Text(
                              isConnected ? 'Connected' : 'Connect',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isConnected
                                    ? (isDark ? AppColors.darkTealPillText : AppColors.emeraldDeep)
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
        ),
      ),
    );
  }
}
