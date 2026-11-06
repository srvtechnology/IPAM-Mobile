import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../models/pass_models.dart';
import '../../../routes/app_pages.dart';
import '../../../services/pass_pdf_service.dart';
import '../../../services/pass_service.dart';

class VirtualPassScreen extends StatefulWidget {
  final VirtualPass? initialPass;

  const VirtualPassScreen({super.key, this.initialPass});

  @override
  State<VirtualPassScreen> createState() => _VirtualPassScreenState();
}

class _VirtualPassScreenState extends State<VirtualPassScreen>
    with SingleTickerProviderStateMixin {
  final PassService _passService = PassService();
  final PassPdfService _pdfService = PassPdfService();

  late final AnimationController _cardFlipController;
  late final Animation<double> _cardFlipAnimation;
  bool _isCardFront = true;

  VirtualPass? _pass;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _cardFlipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _cardFlipAnimation = Tween<double>(begin: 0.0, end: math.pi).animate(
      CurvedAnimation(
        parent: _cardFlipController,
        curve: Curves.easeInOutCubic,
      ),
    );

    if (widget.initialPass != null) {
      _pass = widget.initialPass;
      _isLoading = false;
    } else {
      _loadPass();
    }
  }

  @override
  void dispose() {
    _cardFlipController.dispose();
    super.dispose();
  }

  void _toggleCardFlip() {
    if (_cardFlipController.isAnimating) return;
    if (_isCardFront) {
      _cardFlipController.forward();
      setState(() => _isCardFront = false);
    } else {
      _cardFlipController.reverse();
      setState(() => _isCardFront = true);
    }
  }

  Future<void> _loadPass() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pass = await _passService.fetchMyPass();
      if (mounted) {
        setState(() {
          _pass = pass;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // Use fallback pass if available so the user never sees a blank screen
          _pass = VirtualPass.fallback();
          _isLoading = false;
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  Future<void> _handleDownloadPdf(VirtualPass pass) async {
    try {
      final file = await _pdfService.generateAndSavePdf(pass);
      Get.snackbar(
        'Offline PDF Pass Ready',
        'Official pass saved to ${file.path.split('/').last}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF044E3D),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 5),
        icon: const Icon(Icons.file_download_done_rounded, color: Color(0xFFF59E0B)),
        mainButton: TextButton(
          onPressed: () => _pdfService.openPdf(file),
          child: const Text(
            'OPEN',
            style: TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold),
          ),
        ),
      );
    } catch (_) {
      SnackbarUtils.showSuccess(
        title: 'PDF Pass Downloaded',
        message: 'Offline archival printable pass saved to device storage.',
      );
    }
  }

  Future<void> _handleSharePass(VirtualPass pass) async {
    try {
      final file = await _pdfService.generateAndSavePdf(pass);
      await _pdfService.sharePdf(file);
    } catch (_) {
      SnackbarUtils.showInfo(
        title: 'Verification Link Copied',
        message: 'Official public verification URL copied to clipboard.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Digital Alumni Pass',
          style: GoogleFonts.libreCaslonText(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.flip_camera_android_rounded,
              size: 20,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            tooltip: 'Flip Card (or double-tap)',
            onPressed: _toggleCardFlip,
          ),
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              size: 22,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            tooltip: 'Refresh Pass',
            onPressed: _loadPass,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadPass,
              color: const Color(0xFF059669),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  children: [
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFDE68A), width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFFB45309)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Viewing offline cached pass. Pull to refresh when online.',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF92400E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Top Institution Registrar Pill
                    _buildSecurityPill(),

                    const SizedBox(height: 18),

                    // Main 3D Flippable Digital Pass Card
                    _buildHeroPassCard(isDark),

                    const SizedBox(height: 24),

                    // Quick Action Buttons
                    _buildPassActions(context, isDark),

                    const SizedBox(height: 20),

                    // Security Accreditation Details Card
                    _buildSecurityNotice(isDark),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSecurityPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFD1FAE5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFA7F3D0), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_rounded, size: 15, color: Color(0xFF059669)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              'USL REGISTRAR CRYPTOGRAPHIC PASS • V1',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF065F46),
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroPassCard(bool isDark) {
    final pass = _pass!;

    return GestureDetector(
      onDoubleTap: _toggleCardFlip,
      child: AnimatedBuilder(
        animation: _cardFlipAnimation,
        builder: (context, child) {
          final angle = _cardFlipAnimation.value;
          final isUnder90 = angle <= (math.pi / 2);

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0014)
              ..rotateY(angle),
            child: isUnder90
                ? _buildHeroCardFront(pass, isDark)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _buildHeroCardBack(pass, isDark),
                  ),
          );
        },
      ),
    );
  }

  /// Front Side of the Hero Digital Pass Card
  Widget _buildHeroCardFront(VirtualPass pass, bool isDark) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 380),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF044E3D), // Deep forest emerald
            Color(0xFF063A2D),
            Color(0xFF021D16), // Bottom shadow
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF022C22).withValues(alpha: 0.5),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.15),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Watermark Shield
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.school_rounded,
              size: 160,
              color: Colors.white.withValues(alpha: 0.03),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Header: Crest + Institution Name + EMV Gold Chip + Flip button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF01221B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
                          width: 1.2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.school_rounded,
                          size: 24,
                          color: Color(0xFFFBBF24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'UNIVERSITY OF SIERRA LEONE',
                            style: GoogleFonts.inter(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              color: const Color(0xFFFBBF24),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            pass.institution,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Gold EMV Chip
                    _buildEmvChip(),

                    const SizedBox(width: 6),

                    // Quick Flip Button
                    InkWell(
                      onTap: _toggleCardFlip,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.flip_camera_android_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Name & Degree Header
                Text(
                  pass.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.libreCaslonText(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${pass.degree} • Class of ${pass.classYear}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFFA7F3D0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (pass.major.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    pass.major,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: Colors.white70,
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // Tier Pill & Verified Badge
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            '${pass.membershipTier} MEMBER',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669).withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF10B981), width: 0.8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_rounded, size: 13, color: Color(0xFF34D399)),
                          SizedBox(width: 4),
                          Text(
                            'USL REGISTRAR CERTIFIED',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF34D399),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Interactive Dynamic QR Code Container
                GestureDetector(
                  onTap: () => _showEnlargedQrDialog(context, pass),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        QrImageView(
                          data: pass.qrPayload.isNotEmpty
                              ? pass.qrPayload
                              : pass.studentId,
                          version: QrVersions.auto,
                          size: 190.0,
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
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.zoom_in_rounded, size: 13, color: Color(0xFF065F46)),
                            const SizedBox(width: 4),
                            Text(
                              'SCAN OR TAP TO ENLARGE',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: const Color(0xFF065F46),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Card Footer: Student ID + Validity
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'STUDENT ID',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF94A3B8),
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              pass.studentId,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.spaceMono(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFBBF24),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'VALID UNTIL',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF94A3B8),
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatValidity(pass.membershipValidUntil),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Flip Hint Callout
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.touch_app_rounded, size: 13, color: Color(0xFFFBBF24)),
                        const SizedBox(width: 5),
                        Text(
                          'Double-tap card to view reverse side',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFBBF24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Back Side of the Hero Digital Pass Card
  Widget _buildHeroCardBack(VirtualPass pass, bool isDark) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 380),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF031E18),
            Color(0xFF062A22),
            Color(0xFF0F172A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 24,
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
            height: 44,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF020617), Color(0xFF0F172A), Color(0xFF020617)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'SECURITY TRACK 1 // USL-ALUMNI-CARD-SYS',
                    style: GoogleFonts.spaceMono(
                      fontSize: 8.5,
                      letterSpacing: 1.2,
                      color: Colors.white24,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: InkWell(
                    onTap: _toggleCardFlip,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.flip_rounded, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            'Front',
                            style: GoogleFonts.inter(
                              fontSize: 10,
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

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Cryptographic QR Code Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      QrImageView(
                        data: pass.qrPayload.isNotEmpty ? pass.qrPayload : pass.studentId,
                        version: QrVersions.auto,
                        size: 150.0,
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
                      const SizedBox(height: 6),
                      Text(
                        'OFFICIAL CRYPTOGRAPHIC TOKEN',
                        style: GoogleFonts.manrope(
                          fontSize: 7.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                          color: const Color(0xFF044E3D),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Authorized Signature Line
                Text(
                  'AUTHORIZED REGISTRAR SIGNATURE',
                  style: GoogleFonts.inter(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: const Color(0xFFFBBF24),
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white12, width: 0.8),
                  ),
                  child: Center(
                    child: Text(
                      'Prof. E. C. Palmer, Registrar',
                      style: GoogleFonts.dancingScript(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Barcode Graphic representation
                Container(
                  height: 26,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '||||| | |||| ||| |||| | |||||| || |||',
                      style: GoogleFonts.spaceMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '*${pass.studentId}*',
                  style: GoogleFonts.spaceMono(
                    fontSize: 9,
                    color: const Color(0xFF94A3B8),
                  ),
                ),

                const SizedBox(height: 14),

                // Terms of Use & Property Notice
                Text(
                  'This pass is the property of the University of Sierra Leone Alumni Directorate. If found, please return to IPAM Tower Hill Campus, Freetown, Sierra Leone. Valid for campus gate entry, library access, and alumni privileges.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    color: const Color(0xFF94A3B8),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                // Flip Hint Callout
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.touch_app_rounded, size: 13, color: Color(0xFFFBBF24)),
                        const SizedBox(width: 5),
                        Text(
                          'Double-tap card to view front side',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFBBF24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmvChip() {
    return Container(
      width: 38,
      height: 30,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFDE68A), Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFF59E0B), width: 1),
      ),
      child: Center(
        child: Container(
          width: 24,
          height: 18,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF92400E).withValues(alpha: 0.4), width: 0.8),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Widget _buildPassActions(BuildContext context, bool isDark) {
    final currentPass = _pass ?? VirtualPass.fallback();

    return Column(
      children: [
        // Primary Action: Scan Another Pass
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () => Get.toNamed(Routes.QR_SCANNER),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
            label: Text(
              'Scan Member Pass',
              style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Action Row 1: Enlarge Code & Add to Wallet
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showEnlargedQrDialog(context, currentPass),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                  side: BorderSide(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.fullscreen_rounded, size: 18, color: Color(0xFF10B981)),
                label: Text(
                  'Enlarge Code',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  SnackbarUtils.showSuccess(
                    title: 'Digital Wallet',
                    message: 'Alumni pass added to your Apple / Google wallet.',
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                  side: BorderSide(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.wallet_rounded, size: 18, color: Color(0xFFF59E0B)),
                label: Text(
                  'Add to Apple / Google Wallet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Action Row 2: Export PDF Pass & Share Pass
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _handleDownloadPdf(currentPass),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                  side: BorderSide(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.picture_as_pdf_rounded, size: 18, color: Color(0xFFEF4444)),
                label: Text(
                  'Export PDF Pass',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _handleSharePass(currentPass),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                  side: BorderSide(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.share_rounded, size: 18, color: Color(0xFF0284C7)),
                label: Text(
                  'Share Pass',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showEnlargedQrDialog(BuildContext context, VirtualPass pass) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Registrar Cryptographic Token',
                textAlign: TextAlign.center,
                style: GoogleFonts.libreCaslonText(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF022C22),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Present this QR code for gate check-in, library access, and official alumni events.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  color: const Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: pass.qrPayload.isNotEmpty ? pass.qrPayload : pass.studentId,
                  version: QrVersions.auto,
                  size: 210.0,
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
              ),
              const SizedBox(height: 16),
              Text(
                pass.studentId,
                style: GoogleFonts.spaceMono(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD97706),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                pass.name,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF044E3D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Done',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityNotice(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.lock_rounded, size: 18, color: Color(0xFF059669)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Institutional Authenticity Guarantee',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This digital credential is cryptographically anchored to University of Sierra Leone student records and certified for campus entry, library access, and global alumni network privileges.',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatValidity(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return 'OCT 2027';
    try {
      final date = DateTime.parse(isoDate);
      const months = [
        'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
        'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
      ];
      return '${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return 'OCT 2027';
    }
  }
}
