import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class MemberDetailsActionsWidget extends StatelessWidget {
  final bool isConnected;
  final VoidCallback? onDirectMessage;
  final VoidCallback onMentorship;
  final VoidCallback onConnect;

  const MemberDetailsActionsWidget({
    super.key,
    required this.isConnected,
    this.onDirectMessage,
    required this.onMentorship,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Column(
      children: [
        // Row with Direct Message (optional) & Mentorship
        Row(
          children: [
            if (onDirectMessage != null) ...[
              // Direct Message Button (Solid Emerald)
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF065F46) : const Color(0xFF044E3D),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onDirectMessage,
                  icon: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Direct Message',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],

            // Mentorship Button (Outlined/Card)
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.card(context),
                  foregroundColor: isDark ? Colors.white : AppColors.charcoal,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  side: BorderSide(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: onMentorship,
                icon: const Icon(
                  Icons.school_rounded,
                  size: 17,
                  color: Color(0xFFF59E0B),
                ),
                label: Text(
                  'Mentorship',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.charcoal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Connect to Executive Network (Full Width Mint Button)
        SizedBox(
          width: double.infinity,
          child: Material(
            color: isDark
                ? (isConnected ? const Color(0xFF064E3B) : const Color(0xFF042F2C))
                : (isConnected ? const Color(0xFFDCFCE7) : const Color(0xFFE8F7EE)),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: onConnect,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF059669) : const Color(0xFFA7F3D0),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isConnected ? Icons.check_circle_rounded : Icons.person_add_alt_1_rounded,
                      size: 18,
                      color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        isConnected ? 'Connected to Executive Network' : 'Connect to Executive Network',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
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
          ),
        ),
      ],
    );
  }
}
