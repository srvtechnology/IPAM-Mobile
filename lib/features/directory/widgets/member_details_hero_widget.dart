import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../models/alumni_model.dart';

class MemberDetailsHeroWidget extends StatelessWidget {
  final AlumniModel alumnus;

  const MemberDetailsHeroWidget({
    super.key,
    required this.alumnus,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Top Right Mint Radial Accent Shape
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? const Color(0xFF064E3B).withValues(alpha: 0.25)
                      : const Color(0xFFE8FBF2),
                ),
              ),
            ),

            // Card Body Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Centered Avatar with Green Ring & Overlapping Verified Check Badge
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF059669),
                              width: 2.2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 44,
                            backgroundColor: const Color(0xFFE6F4EA),
                            backgroundImage: (alumnus.avatarUrl.isNotEmpty)
                                ? NetworkImage(alumnus.avatarUrl)
                                : null,
                            child: (alumnus.avatarUrl.isEmpty)
                                ? Text(
                                    alumnus.initials,
                                    style: GoogleFonts.libreCaslonText(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF065F46),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        // Verified Check Badge
                        Positioned(
                          right: 2,
                          bottom: 2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppColors.card(context),
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Color(0xFF059669),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 2. Full Name with Honorific
                  Text(
                    alumnus.displayFullName,
                    style: GoogleFonts.libreCaslonText(
                      fontSize: 19.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.charcoal,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 6),

                  // 3. Primary Role / Title
                  Text(
                    alumnus.role,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF34D399) : const Color(0xFF064E3B),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 4),

                  // 4. Department / Institution
                  Text(
                    'Institute of Public Administration and Management • USL',
                    style: GoogleFonts.manrope(
                      fontSize: 11.5,
                      color: AppColors.textSecondary(context),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // 5. Location Row with Green Pin
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: Color(0xFF059669),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          alumnus.displayCampus,
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: AppColors.textSecondary(context),
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 6. Credential Information Pill Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        width: 0.8,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Class Year • Chapter • Registration Number
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            Text(
                              'Class of ${alumnus.graduationYear}',
                              style: GoogleFonts.manrope(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.charcoal,
                              ),
                            ),
                            Text(
                              '•',
                              style: TextStyle(
                                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              'Freetown (Tower Hill)',
                              style: GoogleFonts.manrope(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.charcoal,
                              ),
                            ),
                            Text(
                              '•',
                              style: TextStyle(
                                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              alumnus.displayRegistrationNumber,
                              style: GoogleFonts.manrope(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFD97706),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // USL Registrar Authenticated • Verified Alumnus
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.shield_rounded,
                              size: 13,
                              color: Color(0xFF059669),
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                'USL Registrar Authenticated • Verified Alumnus',
                                style: GoogleFonts.manrope(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
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
          ],
        ),
      ),
    );
  }
}
