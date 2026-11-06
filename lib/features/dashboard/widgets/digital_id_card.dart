import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/network/models/user_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class DigitalIdCard extends StatelessWidget {
  final UserModel? user;
  final bool showFlipHint;

  const DigitalIdCard({
    super.key,
    this.user,
    this.showFlipHint = true,
  });

  @override
  Widget build(BuildContext context) {
    final memberName = user?.fullName.isNotEmpty == true ? user!.fullName : 'Dr. Amara Sesay';
    final memberId = user?.membershipNumber ?? 'IPAM-ALM-2018-0142';
    final degree = user?.degree ?? 'M.Sc. Governance & Leadership';
    final gradYear = user?.graduationYear != null ? user!.graduationYear.toString() : '2018';

    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        gradient: const LinearGradient(
          colors: [
            AppColors.emeraldDarker,
            Color(0xFF03382B),
            AppColors.emeraldDeep,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.emeraldDarker.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.goldWarm.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border.all(
          color: AppColors.goldWarm.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Stack(
          children: [
            // Background subtle seal watermark
            Positioned(
              right: -30,
              bottom: -30,
              child: Opacity(
                opacity: 0.08,
                child: Icon(
                  Icons.school_rounded,
                  size: 200,
                  color: Colors.white,
                ),
              ),
            ),
            // Gold Foil Accent Top Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: const BoxDecoration(
                  gradient: AppColors.goldGradient,
                ),
              ),
            ),
            // Card Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Row: Logo & Card Type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.goldWarm.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.goldWarm.withValues(alpha: 0.5)),
                            ),
                            child: const Icon(Icons.school, color: AppColors.goldLight, size: 18),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'IPAM ALUMNI',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'OFFICIAL DIGITAL PASS',
                                style: GoogleFonts.manrope(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                  color: AppColors.goldLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.jadeAccent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.jadeAccent, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified, color: AppColors.jadeSoft, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              'VERIFIED',
                              style: GoogleFonts.manrope(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppColors.jadeSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Middle: Member Name & Details
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.goldLight, width: 2),
                          color: AppColors.emeraldDarker,
                        ),
                        child: const Center(
                          child: Icon(Icons.person, color: Colors.white, size: 30),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              memberName,
                              style: GoogleFonts.libreCaslonText(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              degree,
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Class of $gradYear',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.goldLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Bottom Row: Membership ID & QR code badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MEMBERSHIP ID',
                            style: GoogleFonts.manrope(
                              fontSize: 8,
                              letterSpacing: 1.2,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            memberId,
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      // Mini QR Code Emblem
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.qr_code_2_rounded,
                          size: 32,
                          color: AppColors.emeraldDarker,
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
    );
  }
}
