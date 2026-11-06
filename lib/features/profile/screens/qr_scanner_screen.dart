import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/pass_models.dart';
import '../../../services/pass_service.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final PassService _passService = PassService();
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _isProcessing = false;
  bool _isTorchOn = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null || barcode.rawValue!.trim().isEmpty) {
      return;
    }

    final rawData = barcode.rawValue!;
    _processVerification(rawData);
  }

  Future<void> _processVerification(String rawData) async {
    setState(() => _isProcessing = true);
    _scannerController.stop();

    try {
      final identifier = _passService.extractIdentifier(rawData);
      final result = await _passService.verifyPass(identifier);
      if (mounted) {
        _showResultSheet(result);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSheet(e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  void _showResultSheet(VerificationResult result) {
    final isDark = AppColors.isDark(context);

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status Icon: Green Verified Shield or Amber Warning
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: result.valid
                      ? const Color(0xFFD1FAE5)
                      : const Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  result.valid
                      ? Icons.verified_user_rounded
                      : Icons.gpp_bad_rounded,
                  size: 36,
                  color: result.valid
                      ? const Color(0xFF059669)
                      : const Color(0xFFDC2626),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                result.valid ? 'Verified Alumni Pass' : 'Pass Verification Failed',
                style: GoogleFonts.libreCaslonText(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                result.message.isNotEmpty
                    ? result.message
                    : (result.valid ? 'Active USL Registrar Accreditation' : 'Record Not Found'),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: result.valid ? const Color(0xFF059669) : const Color(0xFFDC2626),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              // Member Details Card if User Object is Present
              if (result.user != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        'Full Name',
                        result.displayName,
                        isDark: isDark,
                        isBold: true,
                      ),
                      const Divider(height: 16),
                      _buildDetailRow(
                        'Student / Matric No.',
                        result.studentRegistrationId,
                        isDark: isDark,
                        isMono: true,
                      ),
                      const Divider(height: 16),
                      _buildDetailRow(
                        'Class Year',
                        result.graduationYear > 0 ? 'Class of ${result.graduationYear}' : 'Alumnus',
                        isDark: isDark,
                      ),
                      if (result.degree.isNotEmpty) ...[
                        const Divider(height: 16),
                        _buildDetailRow(
                          'Degree Program',
                          result.degree,
                          isDark: isDark,
                        ),
                      ],
                      const Divider(height: 16),
                      _buildDetailRow(
                        'Membership Tier',
                        '${result.tier} MEMBER',
                        isDark: isDark,
                        highlightColor: const Color(0xFFF59E0B),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Scan Next Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (mounted) {
                      setState(() => _isProcessing = false);
                      _scannerController.start();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
                  label: Text(
                    'Scan Next Pass',
                    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Get.back();
                },
                child: Text(
                  'Done & Return',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorSheet(String error) {
    final isDark = AppColors.isDark(context);

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 32,
                  color: Color(0xFFDC2626),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Invalid or Unregistered Pass',
                style: GoogleFonts.libreCaslonText(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (mounted) {
                      setState(() => _isProcessing = false);
                      _scannerController.start();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Try Again', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    required bool isDark,
    bool isBold = false,
    bool isMono = false,
    Color? highlightColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: isMono
                ? GoogleFonts.spaceMono(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: highlightColor ?? (isDark ? Colors.white : const Color(0xFF0F172A)),
                  )
                : GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                    color: highlightColor ?? (isDark ? Colors.white : const Color(0xFF0F172A)),
                  ),
          ),
        ),
      ],
    );
  }

  void _showManualEntryDialog() {
    final textController = TextEditingController(text: 'IPAM-2015-0042');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Manual ID Verification',
          style: GoogleFonts.libreCaslonText(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the alumni student ID or registration number to verify against registrar records.',
              style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF64748B)),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'e.g. IPAM-2015-0042',
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final query = textController.text.trim();
              Navigator.pop(ctx);
              if (query.isNotEmpty) {
                _processVerification(query);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Verify ID'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Scan Member Pass',
          style: GoogleFonts.libreCaslonText(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black.withValues(alpha: 0.6),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Torch Toggle
          IconButton(
            icon: Icon(
              _isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
              color: _isTorchOn ? const Color(0xFFFBBF24) : Colors.white70,
            ),
            tooltip: 'Toggle Flashlight',
            onPressed: () async {
              await _scannerController.toggleTorch();
              setState(() => _isTorchOn = !_isTorchOn);
            },
          ),
          // Switch Camera Toggle
          IconButton(
            icon: const Icon(Icons.flip_camera_ios_rounded, color: Colors.white70),
            tooltip: 'Switch Camera',
            onPressed: () => _scannerController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Scanner Stream
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
          ),

          // Stylized Viewfinder Overlay
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF10B981), width: 2.5),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withValues(alpha: 0.2),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // Top Instruction Banner
          Positioned(
            top: 24,
            left: 20,
            right: 20,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24, width: 0.8),
                ),
                child: Text(
                  'Align QR code inside the frame to scan',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Bottom Manual Entry Option
          Positioned(
            bottom: 34,
            left: 24,
            right: 24,
            child: Column(
              children: [
                if (_isProcessing) ...[
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Verifying with USL Central Registrar...',
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                  ),
                ] else ...[
                  ElevatedButton.icon(
                    onPressed: _showManualEntryDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    icon: const Icon(Icons.keyboard_alt_outlined, size: 18),
                    label: Text(
                      'Enter Student ID Manually',
                      style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
