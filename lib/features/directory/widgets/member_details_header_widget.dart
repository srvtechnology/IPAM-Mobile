import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class MemberDetailsHeaderWidget extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onBookmark;
  final VoidCallback onCopyLink;

  const MemberDetailsHeaderWidget({
    super.key,
    required this.isBookmarked,
    required this.onBack,
    required this.onShare,
    required this.onBookmark,
    required this.onCopyLink,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Column(
      children: [
        // 1. App Bar Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              IconButton(
                onPressed: onBack,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: isDark ? Colors.white : AppColors.charcoal,
                  size: 22,
                ),
                tooltip: 'Back to Directory',
              ),

              // Title and Subtitle
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Directory Member Details',
                      style: GoogleFonts.libreCaslonText(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.charcoal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'IPAM USL • DIRECTORY',
                      style: GoogleFonts.manrope(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: AppColors.goldWarm,
                      ),
                    ),
                  ],
                ),
              ),

              // Share Button
              IconButton(
                onPressed: onShare,
                icon: Icon(
                  Icons.share_outlined,
                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                  size: 20,
                ),
                tooltip: 'Share Member Profile',
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // 2. Action Ribbon: Registrar Confirmed (Left) & Bookmark/Link Buttons (Right)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Registrar Confirmed Badge
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.5),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE8F7EE),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Color(0xFF059669),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 11,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'REGISTRAR CONFIRMED',
                          style: GoogleFonts.manrope(
                            fontSize: 9.8,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                            color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Right: Bookmark & Link Buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Bookmark Button
                  Material(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: onBookmark,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 38,
                        height: 38,
                        alignment: Alignment.center,
                        child: Icon(
                          isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          size: 19,
                          color: isBookmarked ? AppColors.goldWarm : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Link Button (Copy Profile Link)
                  Material(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: onCopyLink,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 38,
                        height: 38,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.link_rounded,
                          size: 20,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
