import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../routes/app_pages.dart';

class AuthScreen extends StatefulWidget {
  final int initialTab;
  const AuthScreen({super.key, this.initialTab = 0});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthController get controller =>
      Get.isRegistered<AuthController>() ? Get.find<AuthController>() : Get.put(AuthController());

  late final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  late final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.loginFormKey = _loginFormKey;
    controller.registerFormKey = _registerFormKey;
    // Set initial tab and pre-fill email if passed from route arguments
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['tab'] is int) {
        controller.setAuthTab(args['tab'] as int);
      }
      if (args['email'] is String && (args['email'] as String).isNotEmpty) {
        final email = args['email'] as String;
        if (controller.emailController.text != email) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              controller.emailController.text = email;
            }
          });
        }
      }
    } else {
      controller.setAuthTab(widget.initialTab);
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top University & Registrar Badge Bar
              _buildTopBar(context, isDark),

              const SizedBox(height: 20),

              // Segmented Tab Switch: [ Sign In ] vs [ Register as Graduate ]
              _buildSegmentedTabSwitch(context, isDark),

              const SizedBox(height: 24),

              // Institutional Crest with Shield Badge
              _buildInstitutionalCrest(isDark),

              const SizedBox(height: 14),

              // EST 1980 • 15,000+ GLOBAL NETWORK Pill
              _buildNetworkPill(),

              const SizedBox(height: 16),

              // Dynamic Title & Subtitle based on selected tab
              Obx(() {
                final isRegister = controller.selectedAuthTab.value == 1;
                return Column(
                  children: [
                    Text(
                      isRegister ? 'Register as Graduate' : 'Welcome Back, Alumnus',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.libreCaslonText(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        isRegister
                            ? 'Verify your degree record against the USL Registrar to activate your digital alumni membership.'
                            : 'Sign in to access your digital ID, member directory, and verified opportunities.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 24),

              // Form Container Card
              Obx(() {
                final isRegister = controller.selectedAuthTab.value == 1;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: isRegister
                      ? _buildRegisterForm(context, isDark)
                      : _buildSignInForm(context, isDark),
                );
              }),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDark) {
    return Row(
      children: [
        if (Navigator.canPop(context)) ...[
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: isDark ? Colors.white70 : const Color(0xFF334155),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
        ],
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: Color(0xFF059669),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'UNIVERSITY OF SIERRA LEONE',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Registrar Authenticated Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFA7F3D0),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.verified_rounded,
                size: 14,
                color: Color(0xFF065F46),
              ),
              const SizedBox(width: 4),
              Text(
                'Registrar\nAuthenticated',
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF065F46),
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentedTabSwitch(BuildContext context, bool isDark) {
    return Obx(() {
      final selectedTab = controller.selectedAuthTab.value;
      return Container(
        height: 50,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Sign In Tab
            Expanded(
              child: _buildTabButton(
                label: 'Sign In',
                icon: Icons.login_rounded,
                isSelected: selectedTab == 0,
                isDark: isDark,
                onTap: () => controller.setAuthTab(0),
              ),
            ),
            // Register as Graduate Tab
            Expanded(
              child: _buildTabButton(
                label: 'Register as Graduate',
                icon: Icons.school_outlined,
                isSelected: selectedTab == 1,
                isDark: isDark,
                onTap: () => controller.setAuthTab(1),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTabButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF0F172A) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: const Color(0xFF0284C7),
                  width: 1.8,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: isSelected
                  ? (isDark ? Colors.white : const Color(0xFF0F172A))
                  : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected
                      ? (isDark ? Colors.white : const Color(0xFF0F172A))
                      : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstitutionalCrest(bool isDark) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.school_rounded,
                  size: 28,
                  color: Color(0xFF044E3D),
                ),
                const SizedBox(height: 1),
                Text(
                  'IPAM',
                  style: GoogleFonts.libreCaslonText(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF044E3D),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // Shield Badge on bottom right
          Positioned(
            right: -3,
            bottom: -3,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF59E0B),
                border: Border.all(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.shield_rounded,
                  size: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFFDE68A),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.military_tech_rounded,
            size: 16,
            color: Color(0xFFB45309),
          ),
          const SizedBox(width: 6),
          Text(
            'EST. 1980 • 15,000+ GLOBAL NETWORK',
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF92400E),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInForm(BuildContext context, bool isDark) {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pending Verification Notification Banner
          Obx(() {
            if (!controller.hasPendingRegistration.value) {
              return const SizedBox.shrink();
            }
            final pending = controller.pendingRegistrationData.value;
            final pendingEmail = pending?['email']?.toString() ?? controller.emailController.text.trim();
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? const Color(0xFFF59E0B).withValues(alpha: 0.4) : const Color(0xFFFDE68A),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.hourglass_top_rounded,
                      color: Color(0xFFD97706),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Registration Awaiting Approval',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF92400E),
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          pendingEmail.isNotEmpty ? 'Account $pendingEmail in USL review' : 'Registrar review in progress',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF78350F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: controller.openPendingStatusScreen,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: const Color(0xFFD97706),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Check Status',
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Label Row: Email or Alumni ID + Matriculation No. Accepted badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Email or Alumni ID',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFA7F3D0),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Matriculation No. Accepted',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF065F46),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Email Field
          _buildInputField(
            controller: controller.emailController,
            hint: 'ipam.alumni@usl.edu.sl',
            prefixIcon: Icons.account_circle_outlined,
            isDark: isDark,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            textInputAction: TextInputAction.next,
            validator: (v) {
              final req = Validators.required(v, message: 'Please enter your registered email address');
              if (req != null) return req;
              return Validators.email(v);
            },
          ),

          const SizedBox(height: 18),

          // Password Label
          Text(
            'Password',
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),

          // Password Field
          Obx(() => _buildInputField(
                controller: controller.passwordController,
                hint: '••••••••••••',
                prefixIcon: Icons.lock_outline_rounded,
                isDark: isDark,
                obscureText: !controller.isPasswordVisible.value,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  if (_loginFormKey.currentState?.validate() ?? false) {
                    controller.login(_loginFormKey);
                  }
                },
                suffixIcon: IconButton(
                  onPressed: controller.togglePasswordVisibility,
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                validator: Validators.password,
              )),

          const SizedBox(height: 12),

          // Remember Device Checkbox + Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: controller.rememberMe.value,
                          activeColor: const Color(0xFF059669),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (val) {
                            controller.rememberMe.value = val ?? true;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Remember device',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  )),
              TextButton(
                onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Sign In CTA Button
          Obx(() => PrimaryButton(
                isLoading: controller.isLoading.value,
                onPressed: () {
                  if (_loginFormKey.currentState?.validate() ?? false) {
                    controller.login(_loginFormKey);
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'Sign In to Alumni Portal',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              )),

          const SizedBox(height: 18),

          // Demo Mode Auto-Fill Assistant
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFA7F3D0),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: Color(0xFF065F46),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Demo Account: Tap below to auto-fill verified alumni demo credentials (demo.alumni@ipam.edu / Password123!).',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF065F46),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton.icon(
              onPressed: () {
                controller.emailController.text = 'demo.alumni@ipam.edu';
                controller.passwordController.text = 'Password123!';
              },
              icon: const Icon(Icons.flash_on_rounded, size: 16, color: Color(0xFF059669)),
              label: Text(
                'Auto-fill Demo Credentials',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF059669),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context, bool isDark) {
    return Form(
      key: _registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Official Full Name (As on USL Degree Scroll)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Official Full Name',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'As on USL Degree Scroll',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInputField(
            controller: controller.fullNameController,
            hint: 'Mohamed S. Bangura',
            prefixIcon: Icons.badge_outlined,
            isDark: isDark,
            validator: (v) => Validators.required(v, message: 'Please enter your official full name'),
          ),

          const SizedBox(height: 16),

          // Matriculation Number (e.g. IPAM/2019/0142)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Matriculation Number',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFA7F3D0),
                    width: 1,
                  ),
                ),
                child: Text(
                  'e.g. IPAM/2019/0142',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF065F46),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInputField(
            controller: controller.matriculationController,
            hint: 'ipam.alumni@usl.edu.sl',
            prefixIcon: Icons.account_circle_outlined,
            isDark: isDark,
            validator: (v) => Validators.required(v, message: 'Please enter your Matriculation or Student ID'),
          ),

          const SizedBox(height: 16),

          // Row: Grad Year & Degree / Faculty
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grad Year',
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInputField(
                      controller: controller.gradYearController,
                      hint: '2020',
                      prefixIcon: Icons.calendar_today_outlined,
                      keyboardType: TextInputType.number,
                      isDark: isDark,
                      validator: Validators.graduationYear,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Degree / Faculty',
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInputField(
                      controller: controller.degreeController,
                      hint: 'B.Sc. Applied Accounting',
                      prefixIcon: Icons.school_outlined,
                      isDark: isDark,
                      validator: (v) => Validators.required(v, message: 'Required'),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Department / Major
          Text(
            'Department / Major',
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          _buildInputField(
            controller: controller.majorController,
            hint: 'Applied Accounting',
            prefixIcon: Icons.menu_book_outlined,
            isDark: isDark,
            validator: (v) => Validators.required(v, message: 'Major is required'),
          ),

          const SizedBox(height: 16),

          // Primary Email
          Text(
            'Primary Email Address',
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          _buildInputField(
            controller: controller.emailController,
            hint: 'ipam.graduate@usl.edu.sl',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            isDark: isDark,
            validator: Validators.email,
          ),

          const SizedBox(height: 16),

          // Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Create Password',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Obx(() {
                final password = controller.passwordText.value;
                if (password.isEmpty) return const SizedBox.shrink();
                final strength = PasswordStrength.calculate(password);
                Color strengthColor;
                if (strength.score <= 2) {
                  strengthColor = const Color(0xFFEF4444);
                } else if (strength.score == 3) {
                  strengthColor = const Color(0xFFF97316);
                } else if (strength.score == 4) {
                  strengthColor = const Color(0xFFF59E0B);
                } else {
                  strengthColor = const Color(0xFF10B981);
                }
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: strengthColor.withValues(alpha: isDark ? 0.2 : 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: strengthColor.withValues(alpha: 0.5),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    strength.label,
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: strengthColor,
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => _buildInputField(
                controller: controller.passwordController,
                hint: 'At least 8 chars with Aa, 1, @',
                prefixIcon: Icons.lock_outline_rounded,
                isDark: isDark,
                obscureText: !controller.isPasswordVisible.value,
                suffixIcon: IconButton(
                  onPressed: controller.togglePasswordVisibility,
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                validator: Validators.strongPassword,
              )),

          const SizedBox(height: 10),

          // Real-time Password Strength Meter & Criteria Checklist
          _buildPasswordStrengthIndicator(context, isDark),

          const SizedBox(height: 22),

          // Submit Button
          Obx(() => PrimaryButton(
                isLoading: controller.isLoading.value,
                onPressed: () {
                  if (_registerFormKey.currentState?.validate() ?? false) {
                    controller.proceedToOtpVerification(_registerFormKey);
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'Verify with USL Registrar & Register',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              )),

          const SizedBox(height: 16),

          // Registrar Guarantee Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF064E3B).withValues(alpha: 0.3)
                  : const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF065F46) : const Color(0xFFBBF7D0),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.verified_user_rounded,
                  size: 18,
                  color: Color(0xFF10B981),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Your degree records are verified in real time against the University of Sierra Leone official registry records for instant alumni badge accreditation.',
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: isDark ? const Color(0xFFA7F3D0) : const Color(0xFF065F46),
                      height: 1.35,
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    required bool isDark,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.inter(
        fontSize: 14,
        color: isDark ? Colors.white : const Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 13.5,
          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        prefixIcon: Icon(
          prefixIcon,
          size: 20,
          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF059669),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator(BuildContext context, bool isDark) {
    return Obx(() {
      final password = controller.passwordText.value;
      final strength = PasswordStrength.calculate(password);
      final score = strength.score;

      Color barColor;
      if (score <= 2) {
        barColor = const Color(0xFFEF4444);
      } else if (score == 3) {
        barColor = const Color(0xFFF97316);
      } else if (score == 4) {
        barColor = const Color(0xFFF59E0B);
      } else {
        barColor = const Color(0xFF10B981);
      }

      final unfilledColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 5-segment Strength Meter Bar
          Row(
            children: List.generate(5, (index) {
              final isFilled = password.isNotEmpty && index < score;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index < 4 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: isFilled ? barColor : unfilledColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),

          // Real-time Requirement Criteria Chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildCriteriaChip('8+ chars', strength.hasMinLength, isDark),
              _buildCriteriaChip('Uppercase (A-Z)', strength.hasUppercase, isDark),
              _buildCriteriaChip('Lowercase (a-z)', strength.hasLowercase, isDark),
              _buildCriteriaChip('Number (0-9)', strength.hasDigit, isDark),
              _buildCriteriaChip('Special (!@#\$)', strength.hasSpecialChar, isDark),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildCriteriaChip(String label, bool isMet, bool isDark) {
    final activeBg = isDark
        ? const Color(0xFF064E3B).withValues(alpha: 0.45)
        : const Color(0xFFECFDF5);
    final inactiveBg = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFF8FAFC);
    final activeBorder = isDark
        ? const Color(0xFF10B981).withValues(alpha: 0.6)
        : const Color(0xFFA7F3D0);
    final inactiveBorder = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);
    final activeText = isDark
        ? const Color(0xFF34D399)
        : const Color(0xFF047857);
    final inactiveText = isDark
        ? const Color(0xFF64748B)
        : const Color(0xFF94A3B8);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isMet ? activeBg : inactiveBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isMet ? activeBorder : inactiveBorder,
          width: 0.9,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isMet ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            size: 11.5,
            color: isMet ? activeText : inactiveText,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              fontWeight: isMet ? FontWeight.w700 : FontWeight.w500,
              color: isMet ? activeText : inactiveText,
            ),
          ),
        ],
      ),
    );
  }
}
