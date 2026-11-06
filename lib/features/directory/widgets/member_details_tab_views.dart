import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../models/alumni_model.dart';

class MemberOverviewBioView extends StatelessWidget {
  final AlumniModel alumnus;

  const MemberOverviewBioView({
    super.key,
    required this.alumnus,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Presidential Address / Leadership Quote Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF022C22) : const Color(0xFF043A2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF065F46) : const Color(0xFF044E3D),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                alumnus.displayQuoteHeader,
                style: GoogleFonts.manrope(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: const Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                alumnus.displayQuoteText,
                style: GoogleFonts.libreCaslonText(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  height: 1.45,
                  color: const Color(0xFFF0FDF4),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 2. Executive Biography Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.card(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border(context)),
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
              // Header Row
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF059669).withValues(alpha: 0.2)
                          : const Color(0xFFE8F7EE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.badge_outlined,
                      size: 18,
                      color: Color(0xFF059669),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Executive Biography',
                      style: GoogleFonts.libreCaslonText(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.charcoal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Paragraph Text
              Text(
                alumnus.displayBiography,
                style: GoogleFonts.manrope(
                  fontSize: 12.5,
                  height: 1.6,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 3. Office & Official Contact Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.card(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border(context)),
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
              // Header Row
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF059669).withValues(alpha: 0.2)
                          : const Color(0xFFE8F7EE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.contact_mail_outlined,
                      size: 18,
                      color: Color(0xFF059669),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Office & Official Contact',
                      style: GoogleFonts.libreCaslonText(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.charcoal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Contact 1: Email Row
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: alumnus.displayEmail));
                  SnackbarUtils.showSuccess(
                    title: 'Email Copied',
                    message: '${alumnus.displayEmail} copied to clipboard.',
                  );
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.mail_outline_rounded,
                        size: 18,
                        color: Color(0xFF059669),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          alumnus.displayEmail,
                          style: GoogleFonts.manrope(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppColors.charcoal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE8F7EE),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Authenticated',
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Contact 2: Secretariat Office Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.apartment_rounded,
                      size: 18,
                      color: Color(0xFF059669),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        alumnus.displayOfficeLocation,
                        style: GoogleFonts.manrope(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.charcoal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      alumnus.displayOfficeHours,
                      style: GoogleFonts.manrope(
                        fontSize: 10.5,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Contact 3: LinkedIn Profile Row
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: alumnus.displayLinkedin));
                  SnackbarUtils.showSuccess(
                    title: 'LinkedIn URL Copied',
                    message: '${alumnus.displayLinkedin} copied to clipboard.',
                  );
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.language_rounded,
                        size: 18,
                        color: Color(0xFF059669),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          alumnus.displayLinkedin,
                          style: GoogleFonts.manrope(
                            fontSize: 12.5,
                            color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.open_in_new_rounded,
                        size: 16,
                        color: Color(0xFF64748B),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MemberCredentialsView extends StatelessWidget {
  final AlumniModel alumnus;

  const MemberCredentialsView({
    super.key,
    required this.alumnus,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Column(
      children: [
        // Degrees & Certifications Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.card(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Academic Degrees & Honours',
                style: GoogleFonts.libreCaslonText(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 12),
              _buildDegreeItem(
                context,
                title: alumnus.degree ?? 'Ph.D. Public Policy & Governance',
                subtitle: 'University of Sierra Leone (IPAM) • Commonwealth Scholar',
                year: '2006',
              ),
              const Divider(height: 20),
              _buildDegreeItem(
                context,
                title: 'B.Sc. Public Administration & Management',
                subtitle: 'IPAM Tower Hill • First Class Honours & Valedictorian',
                year: alumnus.graduationYear.toString(),
              ),
              const Divider(height: 20),
              _buildDegreeItem(
                context,
                title: 'Fellow Chartered Public Administrator (FCPA)',
                subtitle: 'Institute of Public Administration Professional Guild',
                year: '2012',
              ),
            ],
          ),
        ),

        if (alumnus.skills.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border(context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.psychology_outlined, color: Color(0xFF059669), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Professional Skills & Competencies',
                      style: GoogleFonts.libreCaslonText(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.charcoal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: alumnus.skills.map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Text(
                        skill,
                        style: GoogleFonts.manrope(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTealPillText : const Color(0xFF044E3D),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 14),

        // USL Registrar Digital Verification Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.verified_user_rounded, color: Color(0xFF059669), size: 18),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'USL Registrar Archive Certificate',
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.charcoal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F7EE),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'SEALED',
                      style: GoogleFonts.manrope(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF044E3D),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Registration Hash: 8f4a9b2c...7d1e (${alumnus.displayRegistrationNumber})\nUSL Registrar Archives authenticated Oct 2026.',
                style: GoogleFonts.spaceMono(
                  fontSize: 10.5,
                  color: AppColors.textSecondary(context),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDegreeItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String year,
  }) {
    final isDark = AppColors.isDark(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF059669),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            year,
            style: GoogleFonts.spaceMono(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD97706),
            ),
          ),
        ),
      ],
    );
  }
}

class MemberCareerGovernanceView extends StatelessWidget {
  final AlumniModel alumnus;

  const MemberCareerGovernanceView({
    super.key,
    required this.alumnus,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Governance & Civic Leadership',
            style: GoogleFonts.libreCaslonText(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 14),
          _buildRoleTimeline(
            context,
            role: 'President, IPAM USL Global Alumni Association',
            duration: '2022 – Present',
            institution: 'University of Sierra Leone Global Council',
            isCurrent: true,
          ),
          const SizedBox(height: 14),
          _buildRoleTimeline(
            context,
            role: 'Professor & Dean of Public Governance',
            duration: '2014 – Present',
            institution: 'Institute of Public Administration and Management',
            isCurrent: true,
          ),
          const SizedBox(height: 14),
          _buildRoleTimeline(
            context,
            role: 'Special Technical Advisor on Fiscal Governance',
            duration: '2016 – 2021',
            institution: 'Anti-Corruption & Civil Service Commission',
            isCurrent: false,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleTimeline(
    BuildContext context, {
    required String role,
    required String duration,
    required String institution,
    required bool isCurrent,
  }) {
    final isDark = AppColors.isDark(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isCurrent ? Icons.circle : Icons.radio_button_unchecked,
          size: 14,
          color: isCurrent ? const Color(0xFF059669) : const Color(0xFF94A3B8),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                institution,
                style: GoogleFonts.manrope(
                  fontSize: 11.5,
                  color: AppColors.textSecondary(context),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                duration,
                style: GoogleFonts.manrope(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFD97706),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MemberMentorshipView extends StatelessWidget {
  final AlumniModel alumnus;

  const MemberMentorshipView({
    super.key,
    required this.alumnus,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Mentorship Fellowship',
                  style: GoogleFonts.libreCaslonText(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.charcoal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F7EE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '3 SLOTS OPEN',
                  style: GoogleFonts.manrope(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF044E3D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Areas of Focus: Public Sector Leadership, Administrative Ethics, Fiscal Modernization, and International Academic Fellowships.',
            style: GoogleFonts.manrope(
              fontSize: 12.5,
              height: 1.5,
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 14),
          _buildPillTag(context, 'Weekly 1:1 Executive Advisory', Icons.calendar_today_rounded),
          const SizedBox(height: 8),
          _buildPillTag(context, 'Graduate Thesis Review & Recommendations', Icons.menu_book_rounded),
          const SizedBox(height: 8),
          _buildPillTag(context, 'ECOWAS Regional Network Introductions', Icons.hub_rounded),
        ],
      ),
    );
  }

  Widget _buildPillTag(BuildContext context, String text, IconData icon) {
    final isDark = AppColors.isDark(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF059669)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.manrope(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.charcoal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
