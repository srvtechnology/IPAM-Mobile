import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_service.dart';
import '../controllers/profile_controller.dart';
import 'profile_avatar_view.dart';

/// Modal bottom sheet or full dialog for Alumni Profile Management
/// Supports BOTH Light and Dark Theme seamlessly:
/// - Profile Photo (Base64 System) with circular avatar & camera badge
/// - Academic & Graduate Identity (Full Name, Class Year, Degree, Major)
/// - Career & Professional Information (Job Title, Company, Industry Sector, Country, City, LinkedIn)
/// - Mentorship opt-in checkbox card
/// - Skills & Functional Competencies with quick-add suggestion chips
/// - Alumni Biography & Professional Statement (2000 character limit)
/// - Admin Announcements tab
class AlumniProfileManagementWidget extends StatefulWidget {
  final ProfileController controller;
  final VoidCallback? onClose;

  const AlumniProfileManagementWidget({
    super.key,
    required this.controller,
    this.onClose,
  });

  @override
  State<AlumniProfileManagementWidget> createState() =>
      _AlumniProfileManagementWidgetState();
}

class _AlumniProfileManagementWidgetState
    extends State<AlumniProfileManagementWidget> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _gradYearCtrl;
  late final TextEditingController _degreeCtrl;
  late final TextEditingController _majorCtrl;
  late final TextEditingController _roleCtrl;
  late final TextEditingController _companyCtrl;
  late final TextEditingController _countryCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _linkedinCtrl;
  late final TextEditingController _skillInputCtrl;
  late final TextEditingController _bioCtrl;

  late String _selectedIndustry;
  late bool _isMentor;
  late List<String> _skills;

  final List<String> _industryOptions = const [
    'Banking & Financial Services',
    'Technology & Software',
    'Public Administration & Governance',
    'Healthcare & Life Sciences',
    'Education & Research',
    'Mining & Natural Resources',
    'Telecommunications',
    'Consulting & Professional Services',
    'Agriculture & Agribusiness',
    'Legal & Regulatory Compliance',
    'Non-Profit & Development',
    'Other',
  ];

  final List<String> _quickAddSuggestions = const [
    'Public Policy',
    'Financial Management',
    'Internal Audit',
    'Strategic Governance',
    'Accounting',
    'Data Analysis',
    'Project Management',
    'Banking Operations',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.controller.profile.value;

    _nameCtrl = TextEditingController(text: p.fullName);
    _gradYearCtrl = TextEditingController(text: p.graduationYear.toString());
    _degreeCtrl = TextEditingController(text: p.degree);
    _majorCtrl = TextEditingController(text: p.major);
    _roleCtrl = TextEditingController(text: p.currentRole);
    _companyCtrl = TextEditingController(text: p.currentCompany);
    _countryCtrl = TextEditingController(text: p.country);

    // Parse city from location (e.g. "Freetown, Sierra Leone" -> "Freetown")
    final locParts = p.location.split(',');
    _cityCtrl = TextEditingController(text: locParts.first.trim());

    _linkedinCtrl = TextEditingController(text: p.linkedinUrl);
    _skillInputCtrl = TextEditingController();
    _bioCtrl = TextEditingController(text: p.bio);

    _selectedIndustry = _industryOptions.contains(p.industrySector)
        ? p.industrySector
        : _industryOptions.first;
    _isMentor = p.isMentorAvailable;
    _skills = List<String>.from(p.skills);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _gradYearCtrl.dispose();
    _degreeCtrl.dispose();
    _majorCtrl.dispose();
    _roleCtrl.dispose();
    _companyCtrl.dispose();
    _countryCtrl.dispose();
    _cityCtrl.dispose();
    _linkedinCtrl.dispose();
    _skillInputCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  bool _checkIsDark(BuildContext context) {
    if (Get.isRegistered<ThemeService>()) {
      return ThemeService.to.isDarkMode.value;
    }
    return AppColors.isDark(context);
  }

  void _addSkill(String skill) {
    final trimmed = skill.trim();
    if (trimmed.isNotEmpty && !_skills.contains(trimmed)) {
      setState(() {
        _skills.add(trimmed);
      });
      _skillInputCtrl.clear();
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  Future<void> _handleSave() async {
    final year = int.tryParse(_gradYearCtrl.text.trim()) ??
        widget.controller.profile.value.graduationYear;

    final success = await widget.controller.updateFullProfile(
      fullName: _nameCtrl.text.trim().isEmpty
          ? widget.controller.profile.value.fullName
          : _nameCtrl.text.trim(),
      graduationYear: year,
      degree: _degreeCtrl.text.trim(),
      major: _majorCtrl.text.trim(),
      currentRole: _roleCtrl.text.trim(),
      currentCompany: _companyCtrl.text.trim(),
      industrySector: _selectedIndustry,
      country: _countryCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      linkedinUrl: _linkedinCtrl.text.trim(),
      isMentor: _isMentor,
      skills: _skills,
      bio: _bioCtrl.text.trim(),
    );

    if (success && mounted) {
      Get.back();
    }
  }

  void _showImageSourceDialog(bool isDark) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Upload Profile Photo (Base64)',
                style: GoogleFonts.libreCaslonText(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose an image source to update your headshot avatar.',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                leading: Icon(
                  Icons.photo_library_outlined,
                  color: isDark ? const Color(0xFF10B981) : const Color(0xFF044E3D),
                ),
                title: Text(
                  'Choose from Gallery',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                onTap: () {
                  Get.back();
                  widget.controller.pickAndUploadAvatar(source: ImageSource.gallery);
                },
              ),
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                leading: Icon(
                  Icons.camera_alt_outlined,
                  color: isDark ? const Color(0xFF10B981) : const Color(0xFF044E3D),
                ),
                title: Text(
                  'Take Photo with Camera',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                onTap: () {
                  Get.back();
                  widget.controller.pickAndUploadAvatar(source: ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = _checkIsDark(context);

      // Theme-Aware Palette Tokens
      final bgColor = isDark ? const Color(0xFF090E1A) : Colors.white;
      final surfaceColor = isDark ? const Color(0xFF111927) : const Color(0xFFF8FAFC);
      final borderColor = isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0);
      final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
      final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
      final inputFill = isDark ? const Color(0xFF111927) : const Color(0xFFF8FAFC);
      final inputBorder = isDark ? const Color(0xFF1F2937) : const Color(0xFFCBD5E1);
      final inputHint = isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);
      final sectionColor = isDark ? const Color(0xFF10B981) : const Color(0xFF044E3D);

      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.94,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
        ),
        child: Column(
          children: [
            // Top Drag Handle Pill
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 2),
                width: 38,
                height: 4.5,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),

            // 1. Modal Top Bar Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: borderColor, width: 1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF042F2E) : const Color(0xFFE6F4EA),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF10B981).withValues(alpha: 0.3)
                                : const Color(0xFFA7F3D0),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person_outline_rounded,
                            color: isDark ? const Color(0xFF10B981) : const Color(0xFF044E3D),
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alumni Profile Management',
                              style: GoogleFonts.libreCaslonText(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Update your public biography, professional credentials, and avatar photo.',
                              style: GoogleFonts.manrope(
                                fontSize: 11.5,
                                color: textSecondary,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close_rounded, color: textSecondary, size: 22),
                        onPressed: widget.onClose ?? () => Get.back(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Segmented Tabs Bar: "Profile & Avatar" and "Admin Announcements"
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF111827) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTabPill(
                            index: 0,
                            title: 'Profile & Avatar',
                            icon: Icons.person_outline_rounded,
                            isActive: widget.controller.activeManagementTab.value == 0,
                            isDark: isDark,
                          ),
                          const SizedBox(width: 4),
                          _buildTabPill(
                            index: 1,
                            title: 'Admin Announcements',
                            icon: Icons.notifications_none_rounded,
                            isActive: widget.controller.activeManagementTab.value == 1,
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Tab Views Content
            Expanded(
              child: widget.controller.activeManagementTab.value == 1
                  ? _buildAdminAnnouncementsTab(
                      context,
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    )
                  : _buildProfileEditingTab(
                      context,
                      isDark: isDark,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      inputFill: inputFill,
                      inputBorder: inputBorder,
                      inputHint: inputHint,
                      sectionColor: sectionColor,
                    ),
            ),

            // 3. Bottom Action Bar (Cancel & Save Profile Changes)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0B132B) : Colors.white,
                border: Border(top: BorderSide(color: borderColor, width: 1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: widget.onClose ?? () => Get.back(),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDark ? const Color(0xFF059669) : const Color(0xFF044E3D),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: widget.controller.isLoading.value ? null : _handleSave,
                      child: widget.controller.isLoading.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Save Profile Changes',
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTabPill({
    required int index,
    required String title,
    required IconData icon,
    required bool isActive,
    required bool isDark,
  }) {
    final activeBg = isDark ? const Color(0xFF10B981) : const Color(0xFF059669);
    final activeTextColor = isDark ? const Color(0xFF022C22) : Colors.white;
    final inactiveTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return GestureDetector(
      onTap: () => widget.controller.switchManagementTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? activeTextColor : inactiveTextColor,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? activeTextColor : inactiveTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileEditingTab(
    BuildContext context, {
    required bool isDark,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color inputFill,
    required Color inputBorder,
    required Color inputHint,
    required Color sectionColor,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A. Profile Photo (Base64 System) Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 1),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileAvatarView(
                  avatarUrl: widget.controller.profile.value.avatarUrl,
                  name: widget.controller.profile.value.fullName,
                  size: 80,
                  showCameraBadge: true,
                  isDark: isDark,
                  onCameraTap: () => _showImageSourceDialog(isDark),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile Photo (Base64 System)',
                        style: GoogleFonts.manrope(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Upload a high-resolution headshot for your digital pass and directory card. Supported formats: JPEG, PNG, WebP (auto-optimized as Base64).',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: textSecondary,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
                            width: 1.2,
                          ),
                          backgroundColor: isDark
                              ? const Color(0xFF042F2E).withValues(alpha: 0.3)
                              : const Color(0xFFECFDF5),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: widget.controller.isUploadingAvatar.value
                            ? null
                            : () => _showImageSourceDialog(isDark),
                        icon: widget.controller.isUploadingAvatar.value
                            ? SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: isDark
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFF059669),
                                ),
                              )
                            : Icon(
                                Icons.file_upload_outlined,
                                size: 16,
                                color: isDark
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF044E3D),
                              ),
                        label: Text(
                          widget.controller.isUploadingAvatar.value
                              ? 'Uploading...'
                              : 'Upload New Photo',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? const Color(0xFF10B981)
                                : const Color(0xFF044E3D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // B. 🎓 ACADEMIC & GRADUATE IDENTITY
          _buildSectionHeader(
            icon: Icons.school_outlined,
            title: 'ACADEMIC & GRADUATE IDENTITY',
            color: sectionColor,
          ),
          const SizedBox(height: 14),

          _buildResponsiveRow(
            context,
            firstField: _buildFormField(
              label: 'Full Legal / Alumni Name',
              controller: _nameCtrl,
              isRequired: true,
              hintText: 'e.g. Mohamed S. Bangura',
              textPrimary: textPrimary,
              inputFill: inputFill,
              inputBorder: inputBorder,
              inputHint: inputHint,
              isDark: isDark,
            ),
            secondField: _buildFormField(
              label: 'Graduation Class Year',
              controller: _gradYearCtrl,
              isRequired: true,
              keyboardType: TextInputType.number,
              hintText: 'e.g. 2016',
              textPrimary: textPrimary,
              inputFill: inputFill,
              inputBorder: inputBorder,
              inputHint: inputHint,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 14),

          _buildResponsiveRow(
            context,
            firstField: _buildFormField(
              label: 'Conferred Degree',
              controller: _degreeCtrl,
              isRequired: true,
              hintText: 'e.g. B.Sc. Banking & Finance',
              textPrimary: textPrimary,
              inputFill: inputFill,
              inputBorder: inputBorder,
              inputHint: inputHint,
              isDark: isDark,
            ),
            secondField: _buildFormField(
              label: 'Major / Specialization',
              controller: _majorCtrl,
              isRequired: true,
              hintText: 'e.g. Accounting & Auditing',
              textPrimary: textPrimary,
              inputFill: inputFill,
              inputBorder: inputBorder,
              inputHint: inputHint,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 24),

          // C. 💼 CAREER & PROFESSIONAL INFORMATION
          _buildSectionHeader(
            icon: Icons.work_outline_rounded,
            title: 'CAREER & PROFESSIONAL INFORMATION',
            color: sectionColor,
          ),
          const SizedBox(height: 14),

          _buildResponsiveRow(
            context,
            firstField: _buildFormField(
              label: 'Current Job Title / Role',
              controller: _roleCtrl,
              isRequired: true,
              hintText: 'e.g. Senior Financial Analyst',
              textPrimary: textPrimary,
              inputFill: inputFill,
              inputBorder: inputBorder,
              inputHint: inputHint,
              isDark: isDark,
            ),
            secondField: _buildFormField(
              label: 'Company / Organization',
              controller: _companyCtrl,
              isRequired: true,
              hintText: 'e.g. Central Bank of Sierra Leone',
              textPrimary: textPrimary,
              inputFill: inputFill,
              inputBorder: inputBorder,
              inputHint: inputHint,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 14),

          _buildResponsiveRow(
            context,
            firstField: _buildIndustryDropdown(
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              inputFill: inputFill,
              inputBorder: inputBorder,
              isDark: isDark,
            ),
            secondField: _buildFormField(
              label: 'Country',
              controller: _countryCtrl,
              isRequired: true,
              hintText: 'e.g. Sierra Leone',
              textPrimary: textPrimary,
              inputFill: inputFill,
              inputBorder: inputBorder,
              inputHint: inputHint,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 14),

          _buildResponsiveRow(
            context,
            firstField: _buildFormField(
              label: 'City / Location',
              controller: _cityCtrl,
              isRequired: true,
              hintText: 'e.g. Freetown',
              textPrimary: textPrimary,
              inputFill: inputFill,
              inputBorder: inputBorder,
              inputHint: inputHint,
              isDark: isDark,
            ),
            secondField: _buildFormField(
              label: 'LinkedIn Profile URL',
              controller: _linkedinCtrl,
              isRequired: false,
              hintText: 'https://linkedin.com/in/your-profile',
              keyboardType: TextInputType.url,
              textPrimary: textPrimary,
              inputFill: inputFill,
              inputBorder: inputBorder,
              inputHint: inputHint,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 18),

          // D. Mentorship Opt-In Card
          InkWell(
            onTap: () {
              setState(() {
                _isMentor = !_isMentor;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? surfaceColor
                    : (_isMentor ? const Color(0xFFF0FDF4) : surfaceColor),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isMentor
                      ? (isDark ? const Color(0xFF10B981) : const Color(0xFF059669))
                      : borderColor,
                  width: _isMentor ? 1.2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: _isMentor,
                    activeColor: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: (val) {
                      setState(() {
                        _isMentor = val ?? false;
                      });
                    },
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.volunteer_activism_outlined,
                    color: isDark ? const Color(0xFF10B981) : const Color(0xFF044E3D),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Open to Mentoring Younger Alumni & IPAM Students',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Display the "Available for Mentorship" badge on your directory profile card.',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // E. 🏷️ SKILLS & FUNCTIONAL COMPETENCIES
          _buildSectionHeader(
            icon: Icons.local_offer_outlined,
            title: 'SKILLS & FUNCTIONAL COMPETENCIES',
            color: sectionColor,
          ),
          const SizedBox(height: 14),

          // Skill Input & Add Button Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _skillInputCtrl,
                  cursorColor: isDark ? const Color(0xFF10B981) : const Color(0xFF044E3D),
                  style: GoogleFonts.manrope(fontSize: 13, color: textPrimary),
                  onSubmitted: _addSkill,
                  decoration: InputDecoration(
                    hintText: 'Add a core skill (e.g. Risk Audit, Python)...',
                    hintStyle: GoogleFonts.manrope(fontSize: 12.5, color: inputHint),
                    filled: true,
                    fillColor: inputFill,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: inputBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
                        width: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? const Color(0xFF059669) : const Color(0xFF044E3D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _addSkill(_skillInputCtrl.text),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(
                  'Add',
                  style: GoogleFonts.manrope(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Active Skills Chips
          if (_skills.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skills.map((skill) {
                return Chip(
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  side: BorderSide(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  label: Text(
                    skill,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  deleteIcon: Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: textSecondary,
                  ),
                  onDeleted: () => _removeSkill(skill),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],

          // Quick Add Suggestions
          Text(
            'Quick add suggestions:',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickAddSuggestions.map((suggestion) {
              final isAlreadyAdded = _skills.contains(suggestion);
              return InkWell(
                onTap: isAlreadyAdded ? null : () => _addSkill(suggestion),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isAlreadyAdded
                        ? (isDark
                            ? const Color(0xFF064E3B).withValues(alpha: 0.3)
                            : const Color(0xFFE6F4EA))
                        : (isDark ? const Color(0xFF1E293B) : Colors.white),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isAlreadyAdded
                          ? (isDark ? const Color(0xFF059669) : const Color(0xFFA7F3D0))
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAlreadyAdded ? Icons.check_rounded : Icons.add_rounded,
                        size: 13,
                        color: isAlreadyAdded
                            ? (isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D))
                            : textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        suggestion,
                        style: GoogleFonts.manrope(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: isAlreadyAdded
                              ? (isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D))
                              : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // F. Alumni Biography & Professional Statement
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Alumni Biography & Professional Statement',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _bioCtrl,
                builder: (_, val, child) {
                  return Text(
                    '${val.text.length}/2000 characters',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: textSecondary,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),

          TextField(
            controller: _bioCtrl,
            maxLines: 5,
            maxLength: 2000,
            cursorColor: isDark ? const Color(0xFF10B981) : const Color(0xFF044E3D),
            buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
            style: GoogleFonts.manrope(fontSize: 13, color: textPrimary, height: 1.4),
            decoration: InputDecoration(
              hintText: 'Share your career journey, leadership experience, and how IPAM shaped your path...',
              hintStyle: GoogleFonts.manrope(fontSize: 12.5, color: inputHint),
              filled: true,
              fillColor: inputFill,
              contentPadding: const EdgeInsets.all(14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: inputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
                  width: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAdminAnnouncementsTab(
    BuildContext context, {
    required bool isDark,
    required Color surfaceColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return Obx(() {
      if (widget.controller.isLoadingAnnouncements.value &&
          widget.controller.adminAnnouncements.isEmpty) {
        return Center(
          child: CircularProgressIndicator(
            color: isDark ? const Color(0xFF10B981) : const Color(0xFF044E3D),
          ),
        );
      }

      if (widget.controller.adminAnnouncements.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.campaign_outlined,
                    size: 40,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'No New Announcements',
                  style: GoogleFonts.libreCaslonText(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'University administration broadcasts and campus updates will appear here.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: widget.controller.adminAnnouncements.length,
        separatorBuilder: (_, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final note = widget.controller.adminAnnouncements[index];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF042F2E) : const Color(0xFFE6F4EA),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark ? const Color(0xFF059669) : const Color(0xFFA7F3D0),
                          width: 0.6,
                        ),
                      ),
                      child: Text(
                        note.category,
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D),
                        ),
                      ),
                    ),
                    Text(
                      dateFormat.format(note.createdAt),
                      style: GoogleFonts.manrope(fontSize: 11, color: textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  note.title,
                  style: GoogleFonts.manrope(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  note.message,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResponsiveRow(
    BuildContext context, {
    required Widget firstField,
    required Widget secondField,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 480) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: firstField),
              const SizedBox(width: 14),
              Expanded(child: secondField),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            firstField,
            const SizedBox(height: 12),
            secondField,
          ],
        );
      },
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required bool isRequired,
    required String hintText,
    required Color textPrimary,
    required Color inputFill,
    required Color inputBorder,
    required Color inputHint,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          cursorColor: isDark ? const Color(0xFF10B981) : const Color(0xFF044E3D),
          style: GoogleFonts.manrope(fontSize: 13, color: textPrimary),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.manrope(
              fontSize: 12.5,
              color: inputHint,
            ),
            filled: true,
            fillColor: inputFill,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIndustryDropdown({
    required Color textPrimary,
    required Color textSecondary,
    required Color inputFill,
    required Color inputBorder,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Industry Sector',
              style: GoogleFonts.manrope(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const Text(
              ' *',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _selectedIndustry,
          isExpanded: true,
          dropdownColor: isDark ? const Color(0xFF111927) : Colors.white,
          style: GoogleFonts.manrope(fontSize: 13, color: textPrimary),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: textSecondary),
          decoration: InputDecoration(
            filled: true,
            fillColor: inputFill,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
                width: 1.4,
              ),
            ),
          ),
          items: _industryOptions.map((ind) {
            return DropdownMenuItem<String>(
              value: ind,
              child: Text(
                ind,
                style: GoogleFonts.manrope(fontSize: 13, color: textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (newVal) {
            if (newVal != null) {
              setState(() {
                _selectedIndustry = newVal;
              });
            }
          },
        ),
      ],
    );
  }
}
