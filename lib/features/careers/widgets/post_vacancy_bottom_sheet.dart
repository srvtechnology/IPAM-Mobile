import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/careers_controller.dart';

/// Interactive modal sheet to dynamically post a new alumni job opening as per OpenAPI specification
void showPostVacancyBottomSheet(BuildContext context, CareersController controller) {
  final titleCtrl = TextEditingController();
  final companyCtrl = TextEditingController();
  final locationCtrl = TextEditingController(text: 'Freetown, Sierra Leone');
  final salaryCtrl = TextEditingController(text: '\$1,500 - \$2,200 monthly');
  final descCtrl = TextEditingController();
  final reqsCtrl = TextEditingController();

  String selectedCategory = 'Technology';
  String selectedWorkplace = 'Hybrid';
  String selectedType = 'Full Time';

  final categories = const [
    'Technology',
    'Finance & Banking',
    'Public Administration',
    'Data & AI',
    'Risk & Governance',
    'Product & Design',
  ];

  final workplaceTypes = const ['Hybrid', 'On-site', 'Remote'];
  final employmentTypes = const ['Full Time', 'Part Time', 'Contract', 'Remote'];

  Get.bottomSheet(
    StatefulBuilder(
      builder: (context, setModalState) {
        final isDark = AppColors.isDark(context);

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.88,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.card(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: AppColors.cardBorder(context), width: 1.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary(context).withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // 2. Title & Subtitle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Post an Alumni Vacancy',
                          style: GoogleFonts.libreCaslonText(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Connect directly with verified IPAM graduates and specialists.',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: controller.isPostingVacancy.value
                          ? null
                          : () {
                              if (Navigator.of(context, rootNavigator: true).canPop()) {
                                Navigator.of(context, rootNavigator: true).pop();
                              } else {
                                Get.back();
                              }
                            },
                      color: AppColors.textTertiary(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 3. Scrollable Form Fields
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Job Title
                      TextField(
                        controller: titleCtrl,
                        decoration: InputDecoration(
                          labelText: 'Job Title *',
                          hintText: 'e.g. Senior Financial Analyst',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Company / Organization
                      TextField(
                        controller: companyCtrl,
                        decoration: InputDecoration(
                          labelText: 'Company / Organization *',
                          hintText: 'e.g. Apex Fintech Sierra Leone',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Industry / Category Section
                      Text(
                        'Category / Discipline',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: categories.map((cat) {
                          final isSelected = selectedCategory == cat;
                          return ChoiceChip(
                            label: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.white70 : AppColors.charcoal),
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.emeraldDeep,
                            backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                            onSelected: (val) {
                              if (val) {
                                setModalState(() => selectedCategory = cat);
                              }
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),

                      // Workplace Type Section
                      Text(
                        'Workplace Mode',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: workplaceTypes.map((wp) {
                          final isSelected = selectedWorkplace == wp;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(
                                wp,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark ? Colors.white70 : AppColors.charcoal),
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: AppColors.emeraldDeep,
                              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                              onSelected: (val) {
                                if (val) {
                                  setModalState(() => selectedWorkplace = wp);
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),

                      // Employment Type Section
                      Text(
                        'Employment Type',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: employmentTypes.map((tp) {
                          final isSelected = selectedType == tp;
                          return ChoiceChip(
                            label: Text(
                              tp,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.white70 : AppColors.charcoal),
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.emeraldDeep,
                            backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                            onSelected: (val) {
                              if (val) {
                                setModalState(() => selectedType = tp);
                              }
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),

                      // Location
                      TextField(
                        controller: locationCtrl,
                        decoration: InputDecoration(
                          labelText: 'Location / Address',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Compensation
                      TextField(
                        controller: salaryCtrl,
                        decoration: InputDecoration(
                          labelText: 'Compensation / Salary Range',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Description
                      TextField(
                        controller: descCtrl,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Role Overview & Description (Optional)',
                          hintText: 'Outline key responsibilities and mission of this requisition...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Requirements
                      TextField(
                        controller: reqsCtrl,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Key Qualifications & Skills (Optional)',
                          hintText: 'e.g. IPAM Degree, SQL / Python, 3+ years experience',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),

              // 4. Action Button
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: Obx(
                  () {
                    final isPosting = controller.isPostingVacancy.value;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emeraldDeep,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      onPressed: isPosting
                          ? null
                          : () async {
                              final titleText = titleCtrl.text.trim();
                              final companyText = companyCtrl.text.trim();

                              if (titleText.isEmpty || companyText.isEmpty) {
                                Get.snackbar(
                                  'Missing Information',
                                  'Please enter both Job Title and Company / Organization name.',
                                  backgroundColor: AppColors.errorLight,
                                  colorText: AppColors.error,
                                  snackPosition: SnackPosition.TOP,
                                );
                                return;
                              }

                              final reqList = reqsCtrl.text.trim().isNotEmpty
                                  ? reqsCtrl.text
                                      .trim()
                                      .split('\n')
                                      .expand((e) => e.split(','))
                                      .map((s) => s.trim())
                                      .where((s) => s.isNotEmpty)
                                      .toList()
                                  : null;

                              final success = await controller.addVacancy(
                                title: titleText,
                                company: companyText,
                                location: locationCtrl.text.trim(),
                                salary: salaryCtrl.text.trim(),
                                category: selectedCategory,
                                description: descCtrl.text.trim(),
                                type: selectedType,
                                workplaceType: selectedWorkplace,
                                requirements: reqList,
                              );

                              if (success) {
                                if (context.mounted) {
                                  if (Navigator.of(context, rootNavigator: true).canPop()) {
                                    Navigator.of(context, rootNavigator: true).pop();
                                  } else if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                } else if (Get.isBottomSheetOpen == true) {
                                  Get.back();
                                }

                                Get.snackbar(
                                  'Vacancy Published! 🚀',
                                  '$titleText at $companyText is now live across the alumni network.',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: AppColors.emeraldDeep,
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 3),
                                  margin: const EdgeInsets.all(16),
                                );
                              }
                            },
                      child: isPosting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Publish Vacancy to Alumni Network',
                              style: GoogleFonts.manrope(fontWeight: FontWeight.bold, fontSize: 13.5),
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    ),
    isScrollControlled: true,
  );
}
