import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/auth_dto.dart';
import '../services/auth_service.dart';
import 'registration_pending_screen.dart';

class Verify2faScreen extends StatefulWidget {
  final RegistrationDraft draft;

  const Verify2faScreen({super.key, required this.draft});

  @override
  State<Verify2faScreen> createState() => _Verify2faScreenState();
}

class _Verify2faScreenState extends State<Verify2faScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _otpController = TextEditingController();

  bool _isSubmitting = false;
  bool _isResending = false;
  String? _errorMessage;

  // 30-second cooldown timer for resending OTP
  int _resendCooldown = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCooldownTimer();
  }

  void _startCooldownTimer() {
    setState(() => _resendCooldown = 30);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown <= 1) {
        timer.cancel();
        if (mounted) setState(() => _resendCooldown = 0);
      } else {
        if (mounted) setState(() => _resendCooldown--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleResendCode() async {
    if (_resendCooldown > 0 || _isResending) return;

    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      await _authService.sendRegistrationOtp(
        email: widget.draft.email,
        name: widget.draft.name,
      );
      _startCooldownTimer();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF065F46),
            content: Text(
              'A new 6-digit code has been dispatched to ${widget.draft.email}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    } catch (err) {
      setState(() => _errorMessage = err.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  Future<void> _handleVerifyAndSubmit() async {
    final cleanOtp = _otpController.text.trim();
    if (cleanOtp.length != 6) {
      setState(() => _errorMessage = 'Please enter the complete 6-digit verification code.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await _authService.submitRegistration(
        draft: widget.draft,
        otp: cleanOtp,
      );

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => RegistrationPendingScreen(
              name: widget.draft.name,
              studentId: widget.draft.studentId,
              email: widget.draft.email,
              degree: widget.draft.degree,
              major: widget.draft.major,
              password: widget.draft.password,
            ),
          ),
          (route) => false,
        );
      }
    } catch (err) {
      setState(() => _errorMessage = err.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF020617);
    const cardDark = Color(0xFF0F172A);
    const emeraldPrimary = Color(0xFF10B981);

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(), // Returns to Registration form with data intact
        ),
        title: const Text(
          'Security Verification',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              // Security Shield Icon
              Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF064E3B).withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                  border: Border.all(color: emeraldPrimary.withValues(alpha: 0.4), width: 2),
                ),
                child: const Icon(Icons.shield_outlined, color: emeraldPrimary, size: 36),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'Two-Factor Authentication',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Text(
                'Verify your university email address to submit your profile',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
              const SizedBox(height: 24),

              // SMTP Email Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.mark_email_read_outlined, color: emeraldPrimary, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'SMTP Verification',
                              style: TextStyle(
                                color: emeraldPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF065F46),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Dispatched',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'A single-use 6-digit dynamic code was dispatched to:',
                      style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF020617),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Text(
                        widget.draft.email,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please check your inbox & spam folder. Code expires in 15 minutes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 6-Digit OTP Input Field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Enter 6-Digit Verification Code',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      _otpController.text = '123456';
                    },
                    child: const Text(
                      'Auto-fill 123456',
                      style: TextStyle(
                        color: emeraldPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _otpController,
                autofocus: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 12,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '••••••',
                  hintStyle: const TextStyle(color: Color(0xFF334155), letterSpacing: 12),
                  filled: true,
                  fillColor: cardDark,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF334155)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: emeraldPrimary, width: 2),
                  ),
                ),
                onSubmitted: (_) => _handleVerifyAndSubmit(),
              ),

              // Error display
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4C0519).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF43F5E).withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFFDA4AF),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_errorMessage!.toLowerCase().contains('already exists')) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            backgroundColor: emeraldPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text(
                            'Back to Sign In',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleVerifyAndSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: emeraldPrimary,
                    foregroundColor: const Color(0xFF020617),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Verify & Submit Application',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Resend Code Button with countdown
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the email?",
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: (_resendCooldown > 0 || _isResending) ? null : _handleResendCode,
                    child: Text(
                      _resendCooldown > 0
                          ? 'Resend in ${_resendCooldown}s'
                          : (_isResending ? 'Sending...' : 'Resend Code'),
                      style: TextStyle(
                        color: _resendCooldown > 0 ? const Color(0xFF475569) : emeraldPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

