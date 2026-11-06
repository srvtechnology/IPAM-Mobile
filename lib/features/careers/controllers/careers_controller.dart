import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/careers_provider.dart';
import '../models/career_job_model.dart';
import '../models/career_application_model.dart';
import '../models/career_posting_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/network/auth_storage_service.dart';
import '../../profile/controllers/profile_controller.dart';

class CareersController extends GetxController {
  final CareersProvider _provider = CareersProvider();
  final AuthStorageService _authStorage = Get.isRegistered<AuthStorageService>()
      ? Get.find<AuthStorageService>()
      : Get.put(AuthStorageService(), permanent: true);

  final allJobs = <CareerJobModel>[].obs;
  final applications = <CareerApplicationModel>[].obs;
  final myPostings = <CareerPostingModel>[].obs;
  final savedJobs = <CareerJobModel>[].obs;
  final savedJobIds = <String>{}.obs;
  final isLoading = false.obs;
  final isPostingVacancy = false.obs;

  // Tabs: 'All Jobs', 'Applications', 'My Postings'
  final activeTab = 'All Jobs'.obs;

  // Filter category for All Jobs
  final selectedCategory = 'All Roles'.obs;

  // Filter for Applications: 'All', 'Active', 'Interviews', 'Archived'
  final selectedApplicationFilter = 'All'.obs;

  // Filter for My Postings: 'All Postings', 'Active', 'Paused', 'Filled'
  final selectedPostingFilter = 'All Postings'.obs;

  // Expanded candidate review card id
  final expandedPostingId = RxnString();

  // Search query
  final searchQuery = ''.obs;
  final searchController = TextEditingController();
  Timer? _searchDebounce;

  final scrollController = ScrollController();

  final categories = const [
    'All Roles',
    'Saved Jobs',
    'Finance & Banking',
    'Public Administration',
    'Technology',
    'Risk & Governance',
  ];

  @override
  void onInit() {
    super.onInit();
    final isAuth = _authStorage.isAuthenticated;
    allJobs.assignAll(_provider.getAlumniJobs());
    if (isAuth) {
      applications.clear();
      myPostings.clear();
    } else {
      applications.assignAll(_provider.getApplications());
      myPostings.assignAll(_provider.getMyPostings());
    }
    loadJobs();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> loadJobs() async {
    isLoading.value = true;
    try {
      final user = _authStorage.user;
      final isAuth = _authStorage.isAuthenticated;

      final results = await Future.wait([
        isAuth ? _provider.fetchSavedJobs() : Future.value(<CareerJobModel>[]),
        _provider.fetchMyApplications(isUserAuthenticated: isAuth),
        _provider.fetchMyPostings(
          currentUserId: user?.id,
          currentUserName: user?.fullName,
          isUserAuthenticated: isAuth,
        ),
      ]);

      final saved = results[0] as List<CareerJobModel>;
      final apps = results[1] as List<CareerApplicationModel>;
      final postings = results[2] as List<CareerPostingModel>;

      savedJobs.assignAll(saved);
      savedJobIds.assignAll(saved.map((j) => j.id));

      final jobs = await _provider.fetchJobs(
        query: searchQuery.value.trim().isNotEmpty ? searchQuery.value.trim() : null,
        category: (selectedCategory.value != 'All Roles' && selectedCategory.value != 'Saved Jobs')
            ? selectedCategory.value
            : null,
        currentUserId: user?.id,
        currentUserName: user?.fullName,
        savedJobIds: savedJobIds.toSet(),
      );

      if (jobs.isNotEmpty || searchQuery.value.trim().isNotEmpty || (selectedCategory.value != 'All Roles' && selectedCategory.value != 'Saved Jobs')) {
        allJobs.assignAll(jobs);
      } else if (savedJobIds.isNotEmpty) {
        // Ensure bookmarked flags remain accurate on existing jobs
        for (int i = 0; i < allJobs.length; i++) {
          final isB = savedJobIds.contains(allJobs[i].id);
          if (allJobs[i].isBookmarked != isB) {
            allJobs[i] = allJobs[i].copyWith(isBookmarked: isB);
          }
        }
      }

      applications.assignAll(apps);
      myPostings.assignAll(postings);

      if (Get.isRegistered<ProfileController>()) {
        final profileCtrl = Get.find<ProfileController>();
        profileCtrl.profile.value = profileCtrl.profile.value.copyWith(
          savedApplicationsCount: applications.length,
          postedJobsCount: myPostings.length,
        );
      }
    } catch (_) {
      // Fallback gracefully to curated defaults
    } finally {
      isLoading.value = false;
    }
  }

  int get savedJobsCount => savedJobIds.length;

  int get allJobsCount => allJobs.length;
  int get appliedCount => _authStorage.isAuthenticated
      ? applications.length
      : allJobs.where((j) => j.isApplied).length;
  int get myPostingsCount => _authStorage.isAuthenticated
      ? myPostings.length
      : allJobs.where((j) => j.isMyPosting).length;

  // Application Stats
  int get applicationsTotalCount => applications.length;
  int get applicationsReviewCount => applications.where((a) => a.status == 'Under Review').length;
  int get applicationsInterviewingCount => applications.where((a) => a.isInterviewing).length;
  int get applicationsActiveCount => applications.where((a) => a.isActive).length;
  int get applicationsArchivedCount => applications.where((a) => a.isArchived).length;

  List<CareerApplicationModel> get filteredApplications {
    switch (selectedApplicationFilter.value) {
      case 'Active':
        return applications.where((a) => a.isActive).toList();
      case 'Interviews':
        return applications.where((a) => a.isInterviewing).toList();
      case 'Archived':
        return applications.where((a) => a.isArchived).toList();
      case 'All':
      default:
        return applications.toList();
    }
  }

  // My Postings Stats
  int get totalPostedCount => myPostings.length;
  int get activeOpenCount => myPostings.where((p) => p.status == 'Active').length;
  int get totalCandidatesCount => myPostings.fold<int>(0, (sum, p) => sum + p.applicantsCount);

  int get myPostingsActiveCount => myPostings.where((p) => p.status == 'Active').length;
  int get myPostingsPausedCount => myPostings.where((p) => p.status == 'Paused').length;
  int get myPostingsFilledCount => myPostings.where((p) => p.status == 'Filled').length;

  List<CareerPostingModel> get filteredPostings {
    switch (selectedPostingFilter.value) {
      case 'Active':
        return myPostings.where((p) => p.status == 'Active').toList();
      case 'Paused':
        return myPostings.where((p) => p.status == 'Paused').toList();
      case 'Filled':
        return myPostings.where((p) => p.status == 'Filled').toList();
      case 'All Postings':
      default:
        return myPostings.toList();
    }
  }

  void selectApplicationFilter(String filter) {
    selectedApplicationFilter.value = filter;
  }

  void selectPostingFilter(String filter) {
    selectedPostingFilter.value = filter;
  }

  void togglePostingCandidates(String postingId) {
    if (expandedPostingId.value == postingId) {
      expandedPostingId.value = null;
    } else {
      expandedPostingId.value = postingId;
    }
  }

  Future<void> updatePostingStatus(String id, String newStatus) async {
    final index = myPostings.indexWhere((p) => p.id == id);
    if (index != -1) {
      final updated = myPostings[index].copyWith(status: newStatus);
      myPostings[index] = updated;
      SnackbarUtils.showSuccess(
        title: 'Status Updated',
        message: '${updated.title} marked as $newStatus.',
      );
      await _provider.updatePostingStatus(id, newStatus);
    }
  }

  Future<void> deletePosting(String id) async {
    final index = myPostings.indexWhere((p) => p.id == id);
    if (index != -1) {
      final removed = myPostings.removeAt(index);
      SnackbarUtils.showInfo(
        title: 'Requisition Removed',
        message: '${removed.title} has been archived.',
      );
      await _provider.deletePosting(id);
    }
  }

  List<CareerJobModel> get filteredJobs {
    return allJobs.where((job) {
      // 1. Tab filter
      if (activeTab.value == 'Applications' && !job.isApplied) {
        return false;
      }
      if (activeTab.value == 'My Postings' && !job.isMyPosting) {
        return false;
      }

      // 2. Category filter
      if (selectedCategory.value == 'Saved Jobs') {
        if (!job.isBookmarked && !savedJobIds.contains(job.id)) {
          return false;
        }
      } else if (selectedCategory.value != 'All Roles') {
        if (selectedCategory.value == 'Risk & Governance') {
          if (!job.category.contains('Risk') && !job.title.contains('Risk') && !job.title.contains('Compliance')) {
            return false;
          }
        } else if (job.category != selectedCategory.value) {
          return false;
        }
      }

      // 3. Search query filter
      final query = searchQuery.value.trim().toLowerCase();
      if (query.isNotEmpty) {
        final inTitle = job.title.toLowerCase().contains(query);
        final inCompany = job.company.toLowerCase().contains(query);
        final inLocation = job.location.toLowerCase().contains(query);
        final inCategory = job.category.toLowerCase().contains(query);
        if (!inTitle && !inCompany && !inLocation && !inCategory) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void switchTab(String tab) {
    activeTab.value = tab;
    if (tab == 'Applications') {
      _refreshApplications();
    } else if (tab == 'My Postings') {
      _refreshPostings();
    }
  }

  Future<void> _refreshApplications() async {
    try {
      final isAuth = _authStorage.isAuthenticated;
      final apps = await _provider.fetchMyApplications(isUserAuthenticated: isAuth);
      applications.assignAll(apps);
      if (Get.isRegistered<ProfileController>()) {
        final profileCtrl = Get.find<ProfileController>();
        profileCtrl.profile.value = profileCtrl.profile.value.copyWith(
          savedApplicationsCount: applications.length,
        );
      }
    } catch (_) {}
  }

  Future<void> _refreshPostings() async {
    try {
      final user = _authStorage.user;
      final isAuth = _authStorage.isAuthenticated;
      final postings = await _provider.fetchMyPostings(
        currentUserId: user?.id,
        currentUserName: user?.fullName,
        isUserAuthenticated: isAuth,
      );
      myPostings.assignAll(postings);
      if (Get.isRegistered<ProfileController>()) {
        final profileCtrl = Get.find<ProfileController>();
        profileCtrl.profile.value = profileCtrl.profile.value.copyWith(
          postedJobsCount: myPostings.length,
        );
      }
    } catch (_) {}
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    _fetchFilteredJobs();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _fetchFilteredJobs();
    });
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    _searchDebounce?.cancel();
    _fetchFilteredJobs();
  }

  Future<void> _fetchFilteredJobs() async {
    try {
      final user = _authStorage.user;
      String? apiCat;
      if (selectedCategory.value != 'All Roles' && selectedCategory.value != 'Saved Jobs') {
        final cat = selectedCategory.value.toUpperCase();
        if (cat.contains('FINANCE')) {
          apiCat = 'FINANCE_BANKING';
        } else if (cat.contains('PUBLIC')) {
          apiCat = 'PUBLIC_ADMIN';
        } else if (cat.contains('TECH')) {
          apiCat = 'TECHNOLOGY';
        } else if (cat.contains('RISK')) {
          apiCat = 'RISK_MANAGEMENT';
        } else {
          apiCat = cat;
        }
      }

      final jobs = await _provider.fetchJobs(
        query: searchQuery.value.trim().isNotEmpty ? searchQuery.value.trim() : null,
        category: apiCat,
        currentUserId: user?.id,
        savedJobIds: savedJobIds.toSet(),
      );

      if (jobs.isNotEmpty) {
        allJobs.assignAll(jobs);
      }
    } catch (_) {}
  }

  Future<void> toggleBookmark(CareerJobModel job) async {
    final willBeSaved = !savedJobIds.contains(job.id) && !job.isBookmarked;

    // 1. Optimistic UI updates
    if (willBeSaved) {
      savedJobIds.add(job.id);
      if (!savedJobs.any((j) => j.id == job.id)) {
        savedJobs.add(job.copyWith(isBookmarked: true));
      }
    } else {
      savedJobIds.remove(job.id);
      savedJobs.removeWhere((j) => j.id == job.id);
    }

    final index = allJobs.indexWhere((j) => j.id == job.id);
    if (index != -1) {
      allJobs[index] = allJobs[index].copyWith(isBookmarked: willBeSaved);
    }

    final message = willBeSaved
        ? 'Saved ${job.title} to your bookmarks'
        : 'Removed ${job.title} from bookmarks';

    if (Get.context != null) {
      Get.snackbar(
        'Bookmark Updated',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.emeraldDeep,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      );
    }

    // 2. Call API & reconcile with server state
    try {
      final isSavedOnServer = await _provider.toggleSaveJob(job.id);
      if (isSavedOnServer != willBeSaved) {
        if (isSavedOnServer) {
          savedJobIds.add(job.id);
          if (!savedJobs.any((j) => j.id == job.id)) {
            savedJobs.add(job.copyWith(isBookmarked: true));
          }
        } else {
          savedJobIds.remove(job.id);
          savedJobs.removeWhere((j) => j.id == job.id);
        }
        final idx = allJobs.indexWhere((j) => j.id == job.id);
        if (idx != -1) {
          allJobs[idx] = allJobs[idx].copyWith(isBookmarked: isSavedOnServer);
        }
      }
    } catch (_) {
      // Rollback on network failure
      if (willBeSaved) {
        savedJobIds.remove(job.id);
        savedJobs.removeWhere((j) => j.id == job.id);
      } else {
        savedJobIds.add(job.id);
        if (!savedJobs.any((j) => j.id == job.id)) {
          savedJobs.add(job.copyWith(isBookmarked: true));
        }
      }
      final idx = allJobs.indexWhere((j) => j.id == job.id);
      if (idx != -1) {
        allJobs[idx] = allJobs[idx].copyWith(isBookmarked: !willBeSaved);
      }
    }

    if (Get.isRegistered<ProfileController>()) {
      final profileCtrl = Get.find<ProfileController>();
      profileCtrl.profile.value = profileCtrl.profile.value.copyWith(
        savedApplicationsCount: applications.length,
      );
    }
  }

  Future<void> applyJob(CareerJobModel job, {String? coverNote}) async {
    final index = allJobs.indexWhere((j) => j.id == job.id);
    if (index != -1) {
      allJobs[index] = job.copyWith(isApplied: true);

      final user = _authStorage.user;
      final candidateName = (user?.fullName != null && user!.fullName.isNotEmpty) ? user.fullName : 'Mohamed S. Bangura';
      final email = (user?.email != null && user!.email.isNotEmpty) ? user.email : 'demo.alumni@ipam.edu';
      final phone = user?.phone ?? '+232 76 112233';
      final degree = user?.degree ?? 'B.Sc. Banking & Finance';
      final faculty = user?.department ?? 'Faculty of Management Sciences';
      final gradYear = user?.graduationYear ?? 2016;

      final newApp = await _provider.applyForJob(
        job.id,
        candidateName: candidateName,
        email: email,
        phone: phone,
        degree: degree,
        faculty: faculty,
        gradYear: gradYear,
        coverNote: coverNote,
      );

      if (newApp != null) {
        final existingIdx = applications.indexWhere((a) => a.id == newApp.id);
        if (existingIdx != -1) {
          applications[existingIdx] = newApp;
        } else {
          applications.insert(0, newApp);
        }
      }

      if (Get.isRegistered<ProfileController>()) {
        final profileCtrl = Get.find<ProfileController>();
        profileCtrl.profile.value = profileCtrl.profile.value.copyWith(
          savedApplicationsCount: applications.length,
        );
      }

      if (Get.context != null) {
        Get.snackbar(
          'Application Submitted! 🎉',
          'Your verified IPAM USL profile was transmitted directly to ${job.company}.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.emeraldDeep,
          colorText: Colors.white,
          icon: const Icon(Icons.verified, color: AppColors.jadeAccent),
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }

  Future<bool> addVacancy({
    required String title,
    required String company,
    required String location,
    required String salary,
    required String category,
    String description = '',
    String type = 'FULL_TIME',
    String workplaceType = 'HYBRID',
    List<String>? requirements,
    String? deadline,
  }) async {
    isPostingVacancy.value = true;
    final tempId = 'job_${DateTime.now().millisecondsSinceEpoch}';

    final newJob = CareerJobModel(
      id: tempId,
      title: title,
      company: company,
      companyBadge: '(Alumni Founded)',
      location: location,
      salary: salary,
      alumniCount: 1,
      deadline: deadline ?? 'Dec 31, 2026',
      category: category,
      isVerified: true,
      isApplied: false,
      isBookmarked: false,
      isMyPosting: true,
      logoType: 'sdp',
      logoText: company.length >= 3 ? company.substring(0, 3).toUpperCase() : 'IPAM',
      logoBgColor: AppColors.emeraldDeep,
      description: description.isNotEmpty ? description : 'Newly posted alumni vacancy by IPAM founder network.',
    );

    allJobs.insert(0, newJob);

    final newPosting = CareerPostingModel(
      id: tempId,
      title: title,
      company: company,
      category: category.toUpperCase(),
      postedDate: 'Posted just now',
      status: 'Active',
      location: location,
      salary: salary,
      deadline: deadline ?? 'Dec 31, 2026',
      priorityBadge: 'Priority Alumni Tier',
      applicantsCount: 0,
      hasNewApplicants: false,
      logoText: company.length >= 3 ? company.substring(0, 3).toUpperCase() : 'IPAM',
      logoBgColor: AppColors.emeraldDeep,
      logoTextColor: Colors.white,
    );
    myPostings.insert(0, newPosting);

    if (Get.isRegistered<ProfileController>()) {
      final profileCtrl = Get.find<ProfileController>();
      profileCtrl.profile.value = profileCtrl.profile.value.copyWith(
        postedJobsCount: myPostings.length,
      );
    }

    switchTab('My Postings');

    try {
      final createdPosting = await _provider.postVacancy(
        title: title,
        company: company,
        location: location,
        salary: salary,
        category: category,
        description: description.isNotEmpty ? description : 'Newly posted alumni vacancy by IPAM founder network.',
        type: type,
        workplaceType: workplaceType,
        requirements: requirements,
        deadline: deadline,
      );

      if (createdPosting != null && createdPosting.id.isNotEmpty) {
        final jobIdx = allJobs.indexWhere((j) => j.id == tempId);
        if (jobIdx != -1) {
          allJobs[jobIdx] = allJobs[jobIdx].copyWith(id: createdPosting.id);
        }
        final postIdx = myPostings.indexWhere((p) => p.id == tempId);
        if (postIdx != -1) {
          myPostings[postIdx] = createdPosting;
        }
      }

      return true;
    } catch (e) {
      if (_authStorage.isAuthenticated) {
        allJobs.removeWhere((j) => j.id == tempId);
        myPostings.removeWhere((p) => p.id == tempId);
        if (Get.isRegistered<ProfileController>()) {
          final profileCtrl = Get.find<ProfileController>();
          profileCtrl.profile.value = profileCtrl.profile.value.copyWith(
            postedJobsCount: myPostings.length,
          );
        }
        if (Get.context != null) {
          Get.snackbar(
            'Failed to Publish Vacancy',
            e.toString().replaceAll('Exception: ', ''),
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.errorLight,
            colorText: AppColors.error,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(16),
          );
        }
        return false;
      }
      return true;
    } finally {
      isPostingVacancy.value = false;
    }
  }
}
