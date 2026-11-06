import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/network/auth_storage_service.dart';
import '../../../routes/app_pages.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF02261C), // Deep forest emerald
              Color(0xFF063A2D), // Rich mid-emerald
              Color(0xFF021D16), // Bottom deep shadow
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),

                // Top Pill Badge: OFFICIAL PORTAL • USL REGISTRAR
                _buildTopPortalBadge(),

                const SizedBox(height: 22),

                // Institutional Crest with Amber Star Badge
                _buildInstitutionalCrest(),

                const SizedBox(height: 16),

                // Institution Name & Network Subtitle
                Text(
                  'UNIVERSITY OF SIERRA LEONE',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.2,
                    color: const Color(0xFFA7F3D0),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Color(0xFFF59E0B),
                        thickness: 1,
                        endIndent: 12,
                      ),
                    ),
                    Text(
                      'IPAM GLOBAL NETWORK',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: const Color(0xFFFBBF24),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Color(0xFFF59E0B),
                        thickness: 1,
                        indent: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Headline: Connect. Empower. Excel.
                Text(
                  'Connect.\nEmpower. Excel.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.libreCaslonText(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 14),

                // Subhead Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'The Official Association for IPAM Graduates Worldwide. Uniting leaders across public governance & global enterprise.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      color: const Color(0xFFCBD5E1),
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 3 Stat Tiles in a row
                _buildStatCardsRow(),

                const SizedBox(height: 28),

                // Pending Registration Banner (if user previously registered and is awaiting verification)
                _buildPendingRegistrationBanner(context),

                // Main CTA: Join Alumni Network
                _buildJoinAlumniButton(),

                const SizedBox(height: 14),

                // Secondary CTA: Sign In
                _buildSignInButton(),

                const SizedBox(height: 14),

                // Link: Explore as Guest >
                _buildExploreGuestButton(),

                const SizedBox(height: 14),

                // Trust Badge: USL Registrar Verified Alumni Records
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.verified_user_outlined,
                      size: 17,
                      color: Color(0xFF10B981),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'USL Registrar Verified Alumni Records',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFA7F3D0),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // "New graduate?" Highlight Card
                _buildNewGraduateCard(),

                const SizedBox(height: 24),

                // Trust Indicators Row (256-bit Encrypted • Official USL Portal • 45+ Chapters)
                _buildTrustIndicatorsRow(),

                const SizedBox(height: 14),

                // Secretariat Address
                Text(
                  'Tower Hill, Freetown, Sierra Leone • IPAM Alumni Association Secretariat',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: const Color(0xFFA7F3D0).withValues(alpha: 0.75),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopPortalBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.45),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified_rounded,
            size: 17,
            color: Color(0xFFFBBF24),
          ),
          const SizedBox(width: 8),
          Text(
            'OFFICIAL PORTAL • USL REGISTRAR',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: const Color(0xFFFCD34D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstitutionalCrest() {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.38),
                  blurRadius: 22,
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.school_rounded,
                  size: 32,
                  color: Color(0xFF044E3D),
                ),
                const SizedBox(height: 2),
                Text(
                  'IPAM',
                  style: GoogleFonts.libreCaslonText(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF044E3D),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // Circular Amber Star Badge on bottom right
          Positioned(
            right: -4,
            bottom: -4,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF59E0B),
                border: Border.all(
                  color: const Color(0xFF02261C),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.star_rounded,
                  size: 15,
                  color: Color(0xFF02261C),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatTile(
            number: '15,000+',
            label: 'GLOBAL ALUMNI',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatTile(
            number: '45+',
            label: 'COUNTRIES',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatTile(
            number: 'Est. 1980',
            label: 'FREETOWN',
          ),
        ),
      ],
    );
  }

  Widget _buildStatTile({required String number, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            number,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.libreCaslonText(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFDE68A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: const Color(0xFF6EE7B7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingRegistrationBanner(BuildContext context) {
    if (!Get.isRegistered<AuthStorageService>()) return const SizedBox.shrink();
    final storage = Get.find<AuthStorageService>();
    final pending = storage.pendingRegistration;
    if (pending == null) return const SizedBox.shrink();

    final email = pending['email']?.toString() ?? '';
    final name = pending['name']?.toString() ?? 'Alumni';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.6),
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(Routes.PENDING_APPROVAL, arguments: pending),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.hourglass_top_rounded,
                    color: Color(0xFFFBBF24),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Application in Review',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFCD34D),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email.isNotEmpty ? '$name ($email)' : 'USL Registrar verification in progress',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Status',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF02261C),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJoinAlumniButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed(Routes.REGISTER, arguments: {'tab': 1}),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF059669), Color(0xFF10B981)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF059669).withValues(alpha: 0.4),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.person_add_alt_1_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Join Alumni Network',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed(Routes.LOGIN, arguments: {'tab': 0}),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.22),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Sign In',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExploreGuestButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (Get.isRegistered<AuthStorageService>()) {
            Get.find<AuthStorageService>().setGuestMode(true);
          }
          Get.offAllNamed(Routes.DASHBOARD);
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Explore as Guest',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFA7F3D0),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: Color(0xFFA7F3D0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewGraduateCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFD1FAE5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dark green rounded icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF064E3B),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Icon(
                    Icons.how_to_reg_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'New graduate?',
                            style: GoogleFonts.libreCaslonText(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFFDE68A),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'REGISTRAR RECORD',
                            style: GoogleFonts.inter(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF92400E),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Register with your Matriculation No. to verify your alumni degree records with the USL Registrar.',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: const Color(0xFF475569),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Claim Verified Digital ID Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Get.toNamed(Routes.REGISTER, arguments: {'tab': 1}),
              borderRadius: BorderRadius.circular(14),
              child: Ink(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Claim Verified Digital ID',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF065F46),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: Color(0xFF065F46),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustIndicatorsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTrustItem(
          icon: Icons.lock_outline_rounded,
          text: '256-bit\nEncrypted',
        ),
        _buildSeparatorDot(),
        _buildTrustItem(
          icon: Icons.verified_outlined,
          text: 'Official USL\nPortal',
        ),
        _buildSeparatorDot(),
        _buildTrustItem(
          icon: Icons.public_rounded,
          text: '45+\nChapters',
        ),
      ],
    );
  }

  Widget _buildTrustItem({required IconData icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: const Color(0xFF10B981),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          textAlign: TextAlign.left,
          style: GoogleFonts.inter(
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFA7F3D0),
            height: 1.25,
          ),
        ),
      ],
    );
  }

  Widget _buildSeparatorDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: 3.5,
        height: 3.5,
        decoration: const BoxDecoration(
          color: Color(0xFFA7F3D0),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
