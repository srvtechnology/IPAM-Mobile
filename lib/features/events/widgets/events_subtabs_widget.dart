import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class EventsSubtabsWidget extends StatelessWidget {
  final String activeTab;
  final int upcomingCount;
  final int ticketsCount;
  final ValueChanged<String> onTabChanged;

  const EventsSubtabsWidget({
    super.key,
    required this.activeTab,
    required this.upcomingCount,
    required this.ticketsCount,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Sub-Tab 1: Upcoming Events (5)
          Expanded(
            child: _buildTabButton(
              context,
              title: 'Upcoming Events ($upcomingCount)',
              icon: Icons.calendar_today_rounded,
              isSelected: activeTab == 'Upcoming Events',
              onTap: () => onTabChanged('Upcoming Events'),
              isDark: isDark,
              trailingBadge: null,
            ),
          ),
          const SizedBox(width: 4),

          // Sub-Tab 2: My Tickets (2) [New]
          Expanded(
            child: _buildTabButton(
              context,
              title: 'My Tickets ($ticketsCount)',
              icon: Icons.confirmation_number_outlined,
              isSelected: activeTab == 'My Tickets',
              onTap: () => onTabChanged('My Tickets'),
              isDark: isDark,
              trailingBadge: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF451A03) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? const Color(0xFF78350F) : const Color(0xFFFDE68A),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  'New',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    Widget? trailingBadge,
  }) {
    final selectedBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final selectedText = isDark ? Colors.white : AppColors.emeraldDarker;
    final unselectedText = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? selectedText : unselectedText,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? selectedText : unselectedText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trailingBadge != null) ...[
              const SizedBox(width: 6),
              trailingBadge,
            ],
          ],
        ),
      ),
    );
  }
}
