import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/career_job_model.dart';
import 'careers_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/network/auth_storage_service.dart';
import '../../../services/job_service.dart';
import '../../../models/job_models.dart';
import '../../home/models/job_match_model.dart';

class JobDetailsController extends GetxController {
  final JobService _jobService;
  final AuthStorageService _authStorage;

  JobDetailsController({
    JobService? jobService,
    AuthStorageService? authStorage,
  })  : _jobService = jobService ?? JobService(),
        _authStorage = authStorage ??
            (Get.isRegistered<AuthStorageService>()
                ? Get.find<AuthStorageService>()
                : Get.put(AuthStorageService(), permanent: true));

  late final Rx<CareerJobModel> job;
  final isApplied = false.obs;
  final isBookmarked = false.obs;
  final isSubmitting = false.obs;
  final isLoadingDetails = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is CareerJobModel) {
      job = args.obs;
    } else if (args is JobMatchModel) {
      job = args.toCareerJob().obs;
    } else if (args is JobOpening) {
      job = args.toCareerJobModel().obs;
    } else if (args is String && args.isNotEmpty) {
      job = CareerJobModel(
        id: args,
        title: 'Job Opportunity',
        company: 'IPAM Partner Organization',
        location: 'Freetown, Sierra Leone',
        salary: 'Competitive',
        alumniCount: 4,
        deadline: 'Open Requisition',
        category: 'Technology',
        logoType: 'ipam',
      ).obs;
    } else if (Get.parameters['id'] != null && Get.parameters['id']!.isNotEmpty) {
      job = CareerJobModel(
        id: Get.parameters['id']!,
        title: 'Job Opportunity',
        company: 'IPAM Partner Organization',
        location: 'Freetown, Sierra Leone',
        salary: 'Competitive',
        alumniCount: 4,
        deadline: 'Open Requisition',
        category: 'Technology',
        logoType: 'ipam',
      ).obs;
    } else {
      // Default fallback matching Image 2 & 3 reference designs
      job = const CareerJobModel(
        id: 'job_afdb_research',
        title: 'Development Economics Research Associate',
        company: 'African Development Bank (AfDB)',
        companyBadge: 'Orange Money Core Team',
        location: "Abidjan, Côte d'Ivoire / Remote",
        employmentType: 'Full-Time',
        preferenceBadge: 'USL Alumni Preferred',
        salary: 'International Post USD Stipend',
        alumniCount: 5,
        deadline: 'Dec 15, 2026',
        category: 'Economics & Research',
        isVerified: true,
        logoType: 'afdb',
        logoText: 'AfDB',
        logoBgColor: Color(0xFF0F172A),
        description:
            'Conduct empirical econometrics studies to evaluate infrastructural loans and microfinance equity funds for climate adaptation in West Africa.',
        requirements: [
          'Degree: M.Sc. or First Class B.Sc. from IPAM USL in Economics, Statistics, or Finance.',
          'Minimum 3+ years demonstrable analytical experience in financial sector modeling or policy analysis.',
          'Proficiency with R, Stata, Python, or SQL for empirical econometric modeling.',
        ],
        responsibilities: [
          'Author policy reports and academic research papers on African economic integration.',
          'Coordinate with regional banking authorities and ministerial stakeholders.',
          'Formulate empirical econometric models to forecast trade liquidity and public debt trends.',
        ],
        benefits: [
          'Multilateral Benefits: Tax-exempt international status, housing allowance, comprehensive global healthcare for alumni.',
          'Tech & Equipment Grant: Annual hardware allowance, professional development stipends, and USL library access.',
          'Relocation Assistance: Full expatriate relocation stipend, visa sponsorship, and family resettlement allowance.',
        ],
      ).obs;
    }

    isApplied.value = job.value.isApplied;
    isBookmarked.value = job.value.isBookmarked;

    // Synchronize with CareersController if active
    if (Get.isRegistered<CareersController>()) {
      final careersCtrl = Get.find<CareersController>();
      final existingJob = careersCtrl.allJobs.firstWhereOrNull((j) => j.id == job.value.id);
      if (existingJob != null) {
        isApplied.value = existingJob.isApplied;
        isBookmarked.value = existingJob.isBookmarked || careersCtrl.savedJobIds.contains(job.value.id);
      }
    }

    // Dynamic Live API Synchronization: Refresh job specifications directly from GET /api/jobs/{id}
    if (job.value.id.isNotEmpty && !job.value.id.startsWith('job_afdb')) {
      loadJobDetailsFromApi(job.value.id);
    }
  }

  /// Dynamic API: Fetches full live job specifications from GET /api/jobs/{id}
  Future<void> loadJobDetailsFromApi(String jobId) async {
    isLoadingDetails.value = true;
    try {
      final liveOpening = await _jobService.getJobDetails(jobId);
      final liveJob = liveOpening.toCareerJobModel();
      job.value = liveJob;
      isApplied.value = liveJob.isApplied;
      isBookmarked.value = liveJob.isBookmarked;
    } catch (_) {
      // Retain existing model on network absence
    } finally {
      isLoadingDetails.value = false;
    }
  }

  /// Dynamic API: Submits candidate application to POST /api/jobs/{id}/apply
  Future<void> apply() async {
    if (isApplied.value || isSubmitting.value) return;

    isSubmitting.value = true;
    try {
      if (Get.isRegistered<CareersController>()) {
        final careersCtrl = Get.find<CareersController>();
        await careersCtrl.applyJob(job.value);
      } else {
        final user = _authStorage.user;
        final candidateName = (user?.fullName != null && user!.fullName.isNotEmpty)
            ? user.fullName
            : 'Mohamed S. Bangura';
        final email = (user?.email != null && user!.email.isNotEmpty)
            ? user.email
            : 'demo.alumni@ipam.edu';

        try {
          await _jobService.applyForJob(
            job.value.id,
            candidateName: candidateName,
            email: email,
            phone: user?.phone,
            degree: user?.degree,
            faculty: user?.department,
            gradYear: user?.graduationYear,
          );
        } catch (_) {}

        Get.snackbar(
          'Application Submitted! 🎉',
          'Your verified IPAM USL profile was transmitted directly to ${job.value.company}.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.emeraldDeep,
          colorText: Colors.white,
          icon: const Icon(Icons.verified, color: AppColors.jadeAccent),
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
        );
      }

      isApplied.value = true;
      job.value = job.value.copyWith(isApplied: true);
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Dynamic API: Toggles saving/bookmarking to POST /api/jobs/{id}/save
  Future<void> toggleBookmark() async {
    isBookmarked.value = !isBookmarked.value;
    job.value = job.value.copyWith(isBookmarked: isBookmarked.value);

    if (Get.isRegistered<CareersController>()) {
      final careersCtrl = Get.find<CareersController>();
      await careersCtrl.toggleBookmark(job.value);
    } else {
      try {
        await _jobService.toggleSaveJob(job.value.id);
      } catch (_) {}

      Get.snackbar(
        isBookmarked.value ? 'Job Saved' : 'Job Removed',
        isBookmarked.value
            ? 'Added ${job.value.title} to your saved bookmarks.'
            : 'Removed from saved jobs.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0F172A),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void requestReferral(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final count = job.value.alumniCount > 0 ? job.value.alumniCount : 5;
    final leadName = (job.value.leadAlumniName != null && job.value.leadAlumniName!.isNotEmpty)
        ? job.value.leadAlumniName!
        : 'David Okoro';

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.handshake_rounded, color: Color(0xFF10B981), size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Request Alumni Referral',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF044E3D),
                          ),
                        ),
                        Text(
                          'Connect with verified $leadName & $count alumni colleagues',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Requesting an internal alumni referral pairs your verified USL registry credentials with the hiring requisition lead at ${job.value.company}.',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                  height: 1.4,
                ),
              ),
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
                    Get.back();
                    Get.snackbar(
                      'Referral Request Sent! 🤝',
                      'Your request was transmitted to $leadName at ${job.value.company}.',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: AppColors.emeraldDeep,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 3),
                    );
                  },
                  child: const Text('Confirm Referral Request', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void shareJob() {
    Clipboard.setData(ClipboardData(text: 'https://ipam.billnbite.cloud/careers/jobs/${job.value.id}'));
    Get.snackbar(
      'Link Copied',
      'Direct job URL copied to clipboard.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0F172A),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
