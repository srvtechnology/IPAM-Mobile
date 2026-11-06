import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/profile_model.dart';

class DigitalPassCardWidget extends StatefulWidget {
  final ProfileModel profile;
  final VoidCallback? onQrTap;

  const DigitalPassCardWidget({
    super.key,
    required this.profile,
    this.onQrTap,
  });

  @override
  State<DigitalPassCardWidget> createState() => _DigitalPassCardWidgetState();
}

class _DigitalPassCardWidgetState extends State<DigitalPassCardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: math.pi).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_flipController.isAnimating) return;
    if (_isFront) {
      _flipController.forward();
      setState(() => _isFront = false);
    } else {
      _flipController.reverse();
      setState(() => _isFront = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _toggleFlip,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value;
          final isUnder90 = angle <= (math.pi / 2);

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0014)
              ..rotateY(angle),
            child: isUnder90
                ? _buildFrontSide()
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _buildBackSide(),
                  ),
          );
        },
      ),
    );
  }

  /// Front Side of the Digital Alumni Pass Card
  Widget _buildFrontSide() {
    final profile = widget.profile;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF044E3D),
            Color(0xFF02362A),
            Color(0xFF01241C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF01221B).withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFF059669).withValues(alpha: 0.15),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Subtle Watermark University Crest
          Positioned(
            right: -25,
            bottom: -20,
            child: Icon(
              Icons.school_rounded,
              size: 170,
              color: Colors.white.withValues(alpha: 0.035),
            ),
          ),

          // Main Front Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: IPAM Crest + Campus Title + EMV Chip + Flip Button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 12, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // IPAM Emblem Box
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFF01221B),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.school_rounded,
                            color: Color(0xFFFBBF24),
                            size: 17,
                          ),
                          Text(
                            'IPAM',
                            style: GoogleFonts.manrope(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Campus & Program Label
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'UNIVERSITY OF SIERRA LEONE',
                            style: GoogleFonts.manrope(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                              color: const Color(0xFFFBBF24),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            profile.campus.isNotEmpty
                                ? profile.campus
                                : 'IPAM • Tower Hill Campus',
                            style: GoogleFonts.libreCaslonText(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            'ALUMNI ASSOCIATION GLOBAL PASS',
                            style: GoogleFonts.manrope(
                              fontSize: 8.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.9,
                              color: const Color(0xFF6EE7B7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Smart EMV Golden Chip Graphic
                    _buildEmvGoldChip(),

                    const SizedBox(width: 6),

                    // Contactless NFC Wave Icon
                    const Icon(
                      Icons.wifi_rounded,
                      size: 16,
                      color: Color(0xFFFBBF24),
                    ),

                    const SizedBox(width: 4),

                    // 3D Flip Quick Action Button
                    InkWell(
                      onTap: _toggleFlip,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.flip_camera_android_rounded,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Hairline Metallic Divider
              Container(
                width: double.infinity,
                height: 1,
                color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
              ),

              // Middle Row: Avatar Photo + Graduate Credential Details + Mini QR
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Member Avatar with Gold Verified Ring
                    Stack(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFFBBF24),
                              width: 1.8,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.35),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: profile.avatarUrl.isNotEmpty
                                ? Image.network(
                                    profile.avatarUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => _buildAvatarFallback(),
                                  )
                                : _buildAvatarFallback(),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2.5),
                            decoration: const BoxDecoration(
                              color: Color(0xFF059669),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_rounded,
                              size: 11,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 14),

                    // Graduate Credential Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 6,
                            runSpacing: 2,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'GRADUATE CREDENTIAL',
                                style: GoogleFonts.manrope(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.1,
                                  color: const Color(0xFFFBBF24),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD97706).withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFF59E0B), width: 0.6),
                                ),
                                child: Text(
                                  profile.membershipTier,
                                  style: GoogleFonts.inter(
                                    fontSize: 7.5,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFFDE68A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            profile.fullName,
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
                            '${profile.degree} • Class of ${profile.graduationYear}',
                            style: GoogleFonts.manrope(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFA7F3D0),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),

                          // Member ID & Expiry Row
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'MEMBER ID',
                                      style: GoogleFonts.manrope(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      profile.memberId,
                                      style: GoogleFonts.spaceMono(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFBBF24),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EXPIRES',
                                    style: GoogleFonts.manrope(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    profile.expires,
                                    style: GoogleFonts.manrope(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Mini QR Code Preview (Tappable to open full pass screen)
                    GestureDetector(
                      onTap: widget.onQrTap,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            QrImageView(
                              data: profile.memberId.isNotEmpty
                                  ? '{"schema":"IPAM_PASS_V1","id":"${profile.memberId}","studentId":"${profile.memberId}","name":"${profile.fullName}","tier":"${profile.membershipTier}","issuedAt":"2026-10-15T08:00:00.000Z"}'
                                  : 'IPAM-2019-0142',
                              version: QrVersions.auto,
                              size: 48.0,
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: Color(0xFF022C22),
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: Color(0xFF022C22),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'SCAN TO VERIFY',
                              style: GoogleFonts.manrope(
                                fontSize: 6.0,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.4,
                                color: const Color(0xFF022C22),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Certification & Flip Hint Bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                color: const Color(0xFF011E17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified_rounded,
                            color: Color(0xFFF59E0B),
                            size: 13,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'USL REGISTRAR ARCHIVE CERTIFIED',
                              style: GoogleFonts.manrope(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.7,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SECURE • SHA-256',
                      style: GoogleFonts.manrope(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: const Color(0xFF34D399),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Back Side of the Digital Alumni Pass Card
  Widget _buildBackSide() {
    final profile = widget.profile;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF031E18),
            Color(0xFF062A22),
            Color(0xFF0F172A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.6),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Realistic Black Magnetic Stripe across top
          Container(
            width: double.infinity,
            height: 38,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF020617), Color(0xFF0F172A), Color(0xFF020617)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Text(
                    'SECURITY TRACK 1 // USL-ALUMNI-CARD-SYS',
                    style: GoogleFonts.spaceMono(
                      fontSize: 7.5,
                      letterSpacing: 1.2,
                      color: Colors.white24,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: _toggleFlip,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.flip_rounded, size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            'Front',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Middle Body: Large Cryptographic QR Code + Signatures & Disclaimer
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Prominent Verified QR Code
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      QrImageView(
                        data: profile.memberId.isNotEmpty
                            ? '{"schema":"IPAM_PASS_V1","id":"${profile.memberId}","studentId":"${profile.memberId}","name":"${profile.fullName}","tier":"${profile.membershipTier}","issuedAt":"2026-10-15T08:00:00.000Z"}'
                            : 'IPAM-2019-0142',
                        version: QrVersions.auto,
                        size: 78.0,
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.white,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Color(0xFF022C22),
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Color(0xFF022C22),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'CRYPTOGRAPHIC TOKEN',
                        style: GoogleFonts.manrope(
                          fontSize: 6.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: const Color(0xFF044E3D),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 14),

                // Right Column: Signatures & Property Terms
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Authorized Signature Line
                      Text(
                        'AUTHORIZED REGISTRAR SIGNATURE',
                        style: GoogleFonts.inter(
                          fontSize: 7.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: const Color(0xFFFBBF24),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white12, width: 0.8),
                        ),
                        child: Text(
                          'Prof. E. C. Palmer, Registrar',
                          style: GoogleFonts.dancingScript(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Barcode Graphic representation
                      Container(
                        height: 20,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            '||||| | |||| ||| |||| | |||||| || |||',
                            style: GoogleFonts.spaceMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Center(
                        child: Text(
                          '*${profile.memberId}*',
                          style: GoogleFonts.spaceMono(
                            fontSize: 8,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Property & Disclaimer Notice
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'This card remains the property of the University of Sierra Leone Alumni Directorate. If found, return to IPAM Tower Hill Campus, Freetown. Valid for campus gate entry and library privileges.',
              style: GoogleFonts.inter(
                fontSize: 8.0,
                color: const Color(0xFF94A3B8),
                height: 1.35,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 8),

          // 4. Bottom Access Bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: const Color(0xFF01140F),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'alumni@ipam.edu.sl • www.ipam.edu.sl',
                  style: GoogleFonts.inter(
                    fontSize: 8.0,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6EE7B7),
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.touch_app_rounded,
                      size: 11,
                      color: Color(0xFFFBBF24),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'Double-tap for Front Side',
                      style: GoogleFonts.manrope(
                        fontSize: 8.0,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFBBF24),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback() {
    final rawName = widget.profile.fullName.trim();
    String initial = 'A';
    if (rawName.isNotEmpty) {
      final cleaned = rawName.contains('@') ? rawName.split('@').first : rawName;
      final stripped = cleaned.replaceFirst(RegExp(r'^[@_.\s]+'), '');
      if (stripped.isNotEmpty) {
        initial = stripped.substring(0, 1).toUpperCase();
      }
    }
    return Container(
      color: const Color(0xFF044E3D),
      child: Center(
        child: Text(
          initial,
          style: GoogleFonts.manrope(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// EMV Gold Smart Chip
  Widget _buildEmvGoldChip() {
    return Container(
      width: 36,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFDE68A),
            Color(0xFFF59E0B),
            Color(0xFFD97706),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFFEF3C7),
          width: 0.8,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: double.infinity,
              height: 1,
              color: const Color(0xFFB45309).withValues(alpha: 0.7),
            ),
          ),
          Center(
            child: Container(
              width: 1,
              height: double.infinity,
              color: const Color(0xFFB45309).withValues(alpha: 0.7),
            ),
          ),
          Center(
            child: Container(
              width: 16,
              height: 14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: const Color(0xFFB45309).withValues(alpha: 0.7),
                  width: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
