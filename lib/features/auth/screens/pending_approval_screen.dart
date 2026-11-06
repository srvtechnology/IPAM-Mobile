import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/network/auth_storage_service.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../controllers/auth_controller.dart';

class PendingApprovalScreen extends StatefulWidget {
  final String? email;
  final String? studentId;
  final String? name;
  final String? degree;
  final String? major;
  final String? password;

  const PendingApprovalScreen({
    super.key,
    this.email,
    this.studentId,
    this.name,
    this.degree,
    this.major,
    this.password,
  });

  @override
  State<PendingApprovalScreen> createState() => _PendingApprovalScreenState();
}

class _PendingApprovalScreenState extends State<PendingApprovalScreen> {
  final AuthService _authService = AuthService();
  final AuthStorageService _storage = Get.find<AuthStorageService>();
  final isChecking = false.obs;

  late String _email;
  late String _studentId;
  late String _name;
  late String _degree;
  late String _major;
  String? _password;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments is Map ? Get.arguments as Map : {};
    final savedPending = _storage.pendingRegistration;

    _email = widget.email ??
        args['email']?.toString() ??
        savedPending?['email']?.toString() ??
        'rupeshsingh9790@gmail.com';

    _studentId = widget.studentId ??
        args['studentId']?.toString() ??
        savedPending?['studentId']?.toString() ??
        'IPAM/2020/0142';

    _name = widget.name ??
        args['name']?.toString() ??
        savedPending?['name']?.toString() ??
        'Alumni Candidate';

    _degree = widget.degree ??
        args['degree']?.toString() ??
        savedPending?['degree']?.toString() ??
        'B.Sc. Applied Accounting';

    _major = widget.major ??
        args['major']?.toString() ??
        savedPending?['major']?.toString() ??
        'Applied Accounting';

    _password = widget.password ?? args['password']?.toString();
  }

  Future<String?> _promptForPassword() async {
    final pwdController = TextEditingController();
    final isObscure = true.obs;
    final isDark = AppColors.isDark(context);

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Authenticate with USL Registrar',
                style: GoogleFonts.inter(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Enter the password created for $_email to query your verification status.',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => TextField(
                    controller: pwdController,
                    obscureText: isObscure.value,
                    autofocus: true,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Enter account password',
                      hintStyle: TextStyle(
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                        fontSize: 13.5,
                      ),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                      prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscure.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          size: 20,
                        ),
                        onPressed: () => isObscure.toggle(),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final pwd = pwdController.text.trim();
                    if (pwd.isNotEmpty) {
                      Navigator.pop(ctx, pwd);
                    }
                  },
                  child: Text(
                    'Verify Status',
                    style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _checkStatus() async {
    final authCtrl = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());

    String effectivePassword = _password ?? '';
    if (effectivePassword.isEmpty && authCtrl.passwordController.text.isNotEmpty) {
      effectivePassword = authCtrl.passwordController.text.trim();
    }

    if (effectivePassword.isEmpty) {
      final entered = await _promptForPassword();
      if (entered == null || entered.isEmpty) return;
      effectivePassword = entered;
      _password = entered;
    }

    isChecking.value = true;
    try {
      final response = await _authService.login(_email, effectivePassword);
      // If login succeeds, it means registrar approved!
      await _storage.clearPendingRegistration();
      Get.offAllNamed(Routes.DASHBOARD);
      Get.snackbar(
        'Account Approved! 🎓',
        'Welcome, ${response.profile?.name ?? _name}! Your credentials have been authenticated.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.emeraldDeep,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Review in Progress ⏳',
        'Your credentials for $_email are still queued with the USL Registrar. Approvals are processed continuously.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isChecking.value = false;
    }
  }

  Future<void> _loginWithDemo() async {
    isChecking.value = true;
    try {
      final authCtrl = Get.isRegistered<AuthController>()
          ? Get.find<AuthController>()
          : Get.put(AuthController());

      authCtrl.emailController.text = 'demo.alumni@ipam.edu';
      authCtrl.passwordController.text = 'Password123!';
      await authCtrl.login();
    } finally {
      isChecking.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'UNIVERSITY OF SIERRA LEONE',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Text(
                      'REGISTRY QUEUE',
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: const Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Emblem / Badge
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF59E0B),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.hourglass_top_rounded,
                    size: 38,
                    color: Color(0xFFD97706),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Title
              Text(
                'Registration Submitted',
                textAlign: TextAlign.center,
                style: GoogleFonts.libreCaslonText(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle
              Text(
                'Credentials Queued for Registrar Verification',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFD97706),
                ),
              ),
              const SizedBox(height: 20),

              // Credential Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SUBMITTED DEGREE RECORD',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F4EA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Stage 1 of 2',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF044E3D),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),

                    _buildDetailRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Full Name',
                      value: _name,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),

                    _buildDetailRow(
                      icon: Icons.email_outlined,
                      label: 'Registered Email',
                      value: _email,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),

                    _buildDetailRow(
                      icon: Icons.badge_outlined,
                      label: 'Matriculation No.',
                      value: _studentId,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),

                    _buildDetailRow(
                      icon: Icons.school_outlined,
                      label: 'Degree & Major',
                      value: '$_degree • $_major',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Educational Registry Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.verified_user_rounded,
                      color: Color(0xFF10B981),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Your degree records are validated against the University of Sierra Leone registry archives. Once verified by the registrar, your official digital alumni ID pass and directory profile will become active.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? Colors.white.withValues(alpha: 0.95) : const Color(0xFF044E3D),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // CTA 1: Check Status
              Obx(() => PrimaryButton(
                    isLoading: isChecking.value,
                    onPressed: _checkStatus,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.refresh_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Check Approval Status',
                          style: GoogleFonts.inter(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 12),

              // CTA 2: Demo Mode Explorer
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF059669),
                    side: const BorderSide(color: Color(0xFF059669), width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isChecking.value ? null : _loginWithDemo,
                  icon: const Icon(Icons.bolt_rounded, color: Color(0xFFFBBF24)),
                  label: Text(
                    'Explore in Verified Demo Mode',
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // CTA 3: Return to Sign In
              TextButton(
                onPressed: () {
                  Get.offAllNamed(Routes.LOGIN, arguments: {'tab': 0});
                },
                child: Text(
                  'Sign In with Another Account',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
