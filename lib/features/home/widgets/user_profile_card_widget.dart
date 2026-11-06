import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/network/models/user_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../profile/widgets/profile_avatar_view.dart';

class UserProfileCardWidget extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onQrTap;
  final VoidCallback? onCardTap;

  const UserProfileCardWidget({
    super.key,
    required this.user,
    this.onQrTap,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayName =
        user.fullName.trim().isNotEmpty ? user.fullName.trim() : 'Pranabesh Sarkar';

    final gradYear = user.graduationYear ?? 2020;
    final degree = (user.degree != null && user.degree!.trim().isNotEmpty)
        ? user.degree!.trim()
        : 'B.Sc';

    final isDark = AppColors.isDark(context);

    return InkWell(
      onTap: onCardTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder(context), width: 1.2),
          boxShadow: AppColors.cardShadow(context),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar with Verified Checkmark Overlay
            Stack(
              clipBehavior: Clip.none,
              children: [
                ProfileAvatarView(
                  avatarUrl: user.avatarUrl ?? '',
                  name: displayName,
                  username: user.email,
                  size: 52,
                  borderWidth: 2,
                  borderColor: isDark
                      ? AppColors.darkTealPillText
                      : AppColors.jadeAccent,
                  isDark: isDark,
                ),
                if (user.isVerified)
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.card(context),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkTealPillText
                              : AppColors.jadeAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 11,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            // User Info & Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $displayName',
                    style: GoogleFonts.libreCaslonText(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Class of $gradYear • $degree',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppColors.textSecondary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Registrar Verified Pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.verifiedBg(context),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.tealPillBorder(context),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          color: AppColors.verifiedText(context),
                          size: 13,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Registrar Verified',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
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
            const SizedBox(width: 10),
            // QR Code Action Button
            InkWell(
              onTap: onQrTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.tealPillBg(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.tealPillBorder(context),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.qr_code_2_rounded,
                    color: isDark
                        ? AppColors.darkTealPillText
                        : AppColors.emeraldDeep,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
