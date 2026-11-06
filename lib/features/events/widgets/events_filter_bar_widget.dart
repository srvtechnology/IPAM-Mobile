import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class EventsFilterBarWidget extends StatelessWidget {
  final String selectedChapter;
  final String selectedCategory;
  final List<String> categories;
  final VoidCallback onChapterTap;
  final ValueChanged<String> onCategorySelected;

  const EventsFilterBarWidget({
    super.key,
    required this.selectedChapter,
    required this.selectedCategory,
    required this.categories,
    required this.onChapterTap,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          // 1. Chapter Dropdown Button
          GestureDetector(
            onTap: onChapterTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  width: 1.1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.apartment_rounded,
                    size: 16,
                    color: Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    selectedChapter,
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 2. Category Chips
          ...categories.map((cat) {
            final isSelected = selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onCategorySelected(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? AppColors.darkTealPillBg : AppColors.emeraldDeep)
                        : (isDark ? const Color(0xFF1E293B) : Colors.white),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? (isDark ? AppColors.darkTealPillBorder : AppColors.emeraldDeep)
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      width: 1.1,
                    ),
                    boxShadow: isSelected
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                  child: Text(
                    cat,
                    style: GoogleFonts.manrope(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? (isDark ? AppColors.darkTealPillText : Colors.white)
                          : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
