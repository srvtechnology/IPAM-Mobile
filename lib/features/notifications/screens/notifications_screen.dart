import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/notification_model.dart';
import '../controllers/notifications_controller.dart';

class NotificationsScreen extends GetView<NotificationsController> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColors.textPrimary(context),
          ),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Text(
              'Notifications',
              style: GoogleFonts.libreCaslonText(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(width: 8),
            Obx(() {
              final count = controller.unreadCount.value;
              if (count == 0) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ],
        ),
        actions: [
          Obx(() {
            final count = controller.unreadCount.value;
            if (count == 0) return const SizedBox.shrink();
            return TextButton(
              onPressed: controller.markAllAsRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            );
          }),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(54),
          child: _buildFilterBar(context),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF10B981)),
          );
        }

        final items = controller.filteredNotifications;
        if (items.isEmpty) {
          return RefreshIndicator(
            color: const Color(0xFF10B981),
            onRefresh: controller.fetchNotifications,
            child: ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                _buildEmptyState(context),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFF10B981),
          onRefresh: controller.fetchNotifications,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildNotificationCard(context, item);
            },
          ),
        );
      }),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final filters = [
      {'id': 'ALL', 'label': 'All'},
      {'id': 'VERIFICATION', 'label': 'Verification'},
      {'id': 'ID_CARD', 'label': 'Physical ID'},
      {'id': 'JOB', 'label': 'Careers'},
      {'id': 'EVENT', 'label': 'Events'},
      {'id': 'MESSAGE', 'label': 'Broadcasts'},
    ];

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final filterId = filter['id']!;
          final label = filter['label']!;

          return Obx(() {
            final isSelected = controller.selectedCategory.value == filterId;
            final isDark = AppColors.isDark(context);

            return InkWell(
              onTap: () => controller.setFilter(filterId),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF10B981)
                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF10B981)
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
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

  Widget _buildNotificationCard(BuildContext context, AlumniNotification item) {
    final isDark = AppColors.isDark(context);
    final isUrgent = item.isUrgent;
    final categoryInfo = _getCategoryMetadata(item.categoryType ?? item.type);

    return InkWell(
      onTap: () => controller.onNotificationTap(item),
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isRead
              ? (isDark ? const Color(0xFF0F172A) : Colors.white)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF0FDF4)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isUrgent
                ? const Color(0xFFF59E0B)
                : (item.isRead
                    ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0))
                    : const Color(0xFF10B981)),
            width: isUrgent ? 1.5 : (item.isRead ? 1.0 : 1.2),
          ),
          boxShadow: [
            if (!item.isRead)
              BoxShadow(
                color: const Color(0xFF10B981).withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top category & urgency badge row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: categoryInfo.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(categoryInfo.icon, size: 12, color: categoryInfo.color),
                          const SizedBox(width: 4),
                          Text(
                            categoryInfo.label.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: categoryInfo.color,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isUrgent) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'URGENT',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFB45309),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (!item.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              item.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w800,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 5),

            // Message Body
            Text(
              item.message,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 10),

            // Bottom metadata & action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(item.date),
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                ),
                if (item.actionUrl != null && item.actionUrl!.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'View details',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF10B981)),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_outlined,
              size: 44,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: GoogleFonts.libreCaslonText(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Degree approvals, ID tracking, job updates and\nuniversity announcements will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      final mins = difference.inMinutes;
      return mins <= 1 ? 'Just now' : '$mins mins ago';
    } else if (difference.inHours < 24) {
      final hrs = difference.inHours;
      return hrs == 1 ? '1 hour ago' : '$hrs hours ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return days == 1 ? 'Yesterday' : '$days days ago';
    }
    return DateFormat('dd MMM yyyy').format(date);
  }

  _CategoryMetadata _getCategoryMetadata(String? category) {
    final cat = (category ?? '').toUpperCase();
    if (cat.contains('VERIFICATION')) {
      return const _CategoryMetadata(
        label: 'Degree Verification',
        icon: Icons.verified_user_rounded,
        color: Color(0xFF10B981), // Emerald
      );
    } else if (cat.contains('ID_CARD') || cat.contains('CARD')) {
      return const _CategoryMetadata(
        label: 'Physical ID Card',
        icon: Icons.badge_rounded,
        color: Color(0xFF3B82F6), // Blue
      );
    } else if (cat.contains('JOB') || cat.contains('CAREER')) {
      return const _CategoryMetadata(
        label: 'Job Pipeline',
        icon: Icons.work_outline_rounded,
        color: Color(0xFF8B5CF6), // Purple
      );
    } else if (cat.contains('EVENT') || cat.contains('RSVP')) {
      return const _CategoryMetadata(
        label: 'Event RSVP',
        icon: Icons.event_available_rounded,
        color: Color(0xFFF59E0B), // Amber
      );
    }
    return const _CategoryMetadata(
      label: 'Broadcast',
      icon: Icons.campaign_rounded,
      color: Color(0xFF06B6D4), // Cyan
    );
  }
}

class _CategoryMetadata {
  final String label;
  final IconData icon;
  final Color color;

  const _CategoryMetadata({
    required this.label,
    required this.icon,
    required this.color,
  });
}
