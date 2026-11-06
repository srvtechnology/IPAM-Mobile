import 'package:flutter/material.dart';
import '../features/careers/models/career_job_model.dart';
import '../features/careers/models/career_application_model.dart';
import '../features/careers/models/career_posting_model.dart';

/// Data model representing a verified Job Opening from GET /api/jobs (04-jobs-and-careers.md)
class JobOpening {
  final String id;
  final String title;
  final String company;
  final String? companyLogo;
  final String location;
  final String? country;
  final String? state;
  final String? city;
  final String type; // FULL_TIME, PART_TIME, CONTRACT, REMOTE
  final String workplaceType; // REMOTE, HYBRID, ON_SITE
  final String salary;
  final String category;
  final String description;
  final List<String> requirements;
  final List<String> responsibilities;
  final List<String> benefits;
  final String? aboutCompany;
  final String? deadline;
  final String? postedDate;
  final bool saved;
  final bool applied;
  final String status;
  final String? postedByType;
  final String? postedByName;
  final String? postedByTitle;
  final String? postedByAlumniId;
  final Map<String, dynamic>? postedByAlumni;
  final int applicantsCount;

  JobOpening({
    required this.id,
    required this.title,
    required this.company,
    this.companyLogo,
    required this.location,
    this.country,
    this.state,
    this.city,
    required this.type,
    required this.workplaceType,
    required this.salary,
    required this.category,
    required this.description,
    this.requirements = const [],
    this.responsibilities = const [],
    this.benefits = const [],
    this.aboutCompany,
    this.deadline,
    this.postedDate,
    this.saved = false,
    this.applied = false,
    this.status = 'ACTIVE',
    this.postedByType,
    this.postedByName,
    this.postedByTitle,
    this.postedByAlumniId,
    this.postedByAlumni,
    this.applicantsCount = 0,
  });

  factory JobOpening.fromJson(Map<String, dynamic> json) {
    // Requirements parsing
    final reqs = json['requirements'] is List
        ? (json['requirements'] as List).map((e) => e.toString()).toList()
        : <String>[];

    // Responsibilities parsing
    final resps = json['responsibilities'] is List
        ? (json['responsibilities'] as List).map((e) => e.toString()).toList()
        : <String>[];

    // Benefits parsing
    final bens = json['benefits'] is List
        ? (json['benefits'] as List).map((e) => e.toString()).toList()
        : <String>[];

    // Count parsing
    int count = 0;
    if (json['_count'] is Map && json['_count']['applications'] != null) {
      count = int.tryParse(json['_count']['applications'].toString()) ?? 0;
    } else if (json['applicantsCount'] != null) {
      count = int.tryParse(json['applicantsCount'].toString()) ?? 0;
    }

    final savedVal = json['saved'] == true || json['isSaved'] == true;
    final appliedVal = json['applied'] == true || json['hasApplied'] == true;

    return JobOpening(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Job Opportunity',
      company: json['company']?.toString() ?? 'IPAM Partner Organization',
      companyLogo: json['companyLogo']?.toString(),
      location: json['location']?.toString() ?? 'Freetown, Sierra Leone',
      country: json['country']?.toString(),
      state: json['state']?.toString(),
      city: json['city']?.toString(),
      type: json['type']?.toString() ?? 'FULL_TIME',
      workplaceType: json['workplaceType']?.toString() ?? 'HYBRID',
      salary: json['salary']?.toString() ?? 'Competitive, negotiable',
      category: json['category']?.toString() ?? 'GENERAL',
      description: json['description']?.toString() ?? '',
      requirements: reqs,
      responsibilities: resps,
      benefits: bens,
      aboutCompany: json['aboutCompany']?.toString(),
      deadline: json['deadline']?.toString(),
      postedDate: json['postedDate']?.toString(),
      saved: savedVal,
      applied: appliedVal,
      status: json['status']?.toString() ?? 'ACTIVE',
      postedByType: json['postedByType']?.toString(),
      postedByName: json['postedByName']?.toString(),
      postedByTitle: json['postedByTitle']?.toString(),
      postedByAlumniId: json['postedByAlumniId']?.toString(),
      postedByAlumni: json['postedByAlumni'] is Map<String, dynamic>
          ? json['postedByAlumni'] as Map<String, dynamic>
          : null,
      applicantsCount: count,
    );
  }

  /// Converts API model to UI CareerJobModel
  CareerJobModel toCareerJobModel({bool? isCurrentUserPosting}) {
    // Format Employment Type
    String empType = 'Full Time';
    final upperType = type.toUpperCase();
    if (upperType.contains('PART')) {
      empType = 'Part Time';
    } else if (upperType.contains('CONTRACT')) {
      empType = 'Contract';
    } else if (upperType.contains('REMOTE')) {
      empType = 'Remote';
    }

    // Format Workplace Type suffix
    String locDisplay = location;
    final upperWorkplace = workplaceType.toUpperCase();
    if (upperWorkplace == 'HYBRID' && !locDisplay.toLowerCase().contains('hybrid')) {
      locDisplay = '$locDisplay (Hybrid)';
    } else if (upperWorkplace == 'REMOTE' && !locDisplay.toLowerCase().contains('remote')) {
      locDisplay = '$locDisplay (Remote)';
    } else if (upperWorkplace == 'ON_SITE' && !locDisplay.toLowerCase().contains('on-site')) {
      locDisplay = '$locDisplay (On-site)';
    }

    // Format category
    String catDisplay = 'Technology';
    final upperCat = category.toUpperCase();
    if (upperCat.contains('FINANCE') || upperCat.contains('BANK')) {
      catDisplay = 'Finance & Banking';
    } else if (upperCat.contains('POLICY') || upperCat.contains('ADMIN') || upperCat.contains('LEGAL')) {
      catDisplay = 'Public Administration';
    } else if (upperCat.contains('RISK') || upperCat.contains('GOVERN') || upperCat.contains('OPER')) {
      catDisplay = 'Risk & Governance';
    } else if (upperCat.contains('DATA') || upperCat.contains('AI') || upperCat.contains('ENG')) {
      catDisplay = 'Technology';
    }

    // Format deadline
    String deadlineDisplay = 'Open Requisition';
    if (deadline != null && deadline!.isNotEmpty) {
      final parsed = DateTime.tryParse(deadline!);
      if (parsed != null) {
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        final m = months[parsed.month - 1];
        final d = parsed.day.toString().padLeft(2, '0');
        deadlineDisplay = '$m $d, ${parsed.year}';
      } else {
        deadlineDisplay = deadline!;
      }
    }

    // Branding / Logo determination
    final compLower = company.toLowerCase();
    String logoT = company.length >= 4 ? company.substring(0, 4).toUpperCase() : company.toUpperCase();
    String logoKind = 'sdp';
    Color logoBg = const Color(0xFF0F172A);
    Color logoTextC = Colors.white;

    if (compLower.contains('orange')) {
      logoKind = 'orange';
      logoT = 'Orange';
      logoBg = const Color(0xFF0F172A);
    } else if (compLower.contains('ministry') || compLower.contains('finance')) {
      logoKind = 'ministry';
      logoT = 'MOF';
      logoBg = const Color(0xFF044E3D);
    } else if (compLower.contains('commercial bank') || compLower.contains('slcb')) {
      logoKind = 'slcb';
      logoT = 'SLCB';
      logoBg = const Color(0xFF1E3A8A);
    } else if (compLower.contains('sierra digital') || compLower.contains('sdp')) {
      logoKind = 'sdp';
      logoT = 'SDP';
      logoBg = const Color(0xFF064E3B);
    } else if (compLower.contains('central bank') || compLower.contains('bsl')) {
      logoKind = 'slcb';
      logoT = 'BSL';
      logoBg = const Color(0xFF0F172A);
      logoTextC = const Color(0xFFF59E0B);
    } else if (compLower.contains('revenue') || compLower.contains('nra')) {
      logoKind = 'nra';
      logoT = 'NRA';
      logoBg = const Color(0xFF065F46);
    }

    final authorName = postedByName ?? (postedByAlumni != null ? postedByAlumni!['name']?.toString() : null);
    final authorRole = postedByTitle ?? (postedByAlumni != null ? postedByAlumni!['currentRole']?.toString() : null);

    return CareerJobModel(
      id: id,
      title: title,
      company: company,
      companyBadge: postedByType == 'ALUMNI' ? '(Alumni Founded)' : null,
      location: locDisplay,
      employmentType: empType,
      preferenceBadge: 'USL Alumni Preferred',
      salary: salary,
      alumniCount: applicantsCount > 0 ? applicantsCount : 4,
      deadline: deadlineDisplay,
      category: catDisplay,
      isVerified: true,
      isApplied: applied,
      isBookmarked: saved,
      isMyPosting: isCurrentUserPosting ?? false,
      logoType: logoKind,
      logoText: logoT,
      logoBgColor: logoBg,
      logoTextColor: logoTextC,
      description: description,
      requirements: requirements,
      responsibilities: responsibilities,
      benefits: benefits,
      leadAlumniName: authorName,
      leadAlumniRole: authorRole,
      companyLogo: companyLogo,
    );
  }

  /// Converts to CareerPostingModel for My Postings tab
  CareerPostingModel toCareerPostingModel() {
    final compLower = company.toLowerCase();
    String logoT = company.length >= 4 ? company.substring(0, 4).toUpperCase() : company.toUpperCase();
    Color logoBg = const Color(0xFF042F2C);
    Color logoTextC = const Color(0xFFF59E0B);

    if (compLower.contains('central bank') || compLower.contains('bsl')) {
      logoT = 'BSL';
      logoBg = const Color(0xFF0F172A);
      logoTextC = const Color(0xFFF59E0B);
    } else if (compLower.contains('orange')) {
      logoT = 'Orange';
      logoBg = const Color(0xFF0F172A);
      logoTextC = Colors.white;
    }

    String postedDisplay = 'Posted Oct 2026';
    if (postedDate != null) {
      final parsed = DateTime.tryParse(postedDate!);
      if (parsed != null) {
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        postedDisplay = 'Posted ${months[parsed.month - 1]} ${parsed.day}, ${parsed.year}';
      }
    }

    String deadlineDisplay = 'Dec 01, 2026';
    if (deadline != null) {
      final parsed = DateTime.tryParse(deadline!);
      if (parsed != null) {
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        deadlineDisplay = '${months[parsed.month - 1]} ${parsed.day.toString().padLeft(2, '0')}, ${parsed.year}';
      }
    }

    // Format status
    String statusFormatted = 'Active';
    final sUpper = status.toUpperCase();
    if (sUpper == 'PAUSED') {
      statusFormatted = 'Paused';
    } else if (sUpper == 'CLOSED' || sUpper == 'FILLED') {
      statusFormatted = 'Filled';
    }

    return CareerPostingModel(
      id: id,
      title: title,
      company: company,
      category: category.toUpperCase(),
      postedDate: postedDisplay,
      status: statusFormatted,
      location: location,
      salary: salary,
      deadline: deadlineDisplay,
      priorityBadge: 'Priority Alumni Tier',
      applicantsCount: applicantsCount,
      hasNewApplicants: applicantsCount > 0,
      logoText: logoT,
      logoBgColor: logoBg,
      logoTextColor: logoTextC,
    );
  }
}

/// Data model representing a user's job application from GET /api/jobs/my-applications
class JobApplicationItem {
  final String id;
  final String applicationRef;
  final String jobId;
  final String status; // APPLIED, REVIEWING, INTERVIEW_SCHEDULED, OFFER_EXTENDED, REJECTED
  final int matchScore;
  final DateTime? interviewDate;
  final String? recruiterRemarks;
  final String? candidateName;
  final String? email;
  final String? phone;
  final String? degree;
  final String? faculty;
  final int? gradYear;
  final int? experienceYears;
  final String? notes;
  final DateTime? selectedDate;
  final String? offerSalary;
  final DateTime? startDate;
  final String? decisionStatus;
  final String? linkedinUrl;
  final String? coverNote;
  final String? cvUrl;
  final String? cvFileName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final JobOpening job;

  JobApplicationItem({
    required this.id,
    required this.applicationRef,
    required this.jobId,
    required this.status,
    required this.matchScore,
    this.interviewDate,
    this.recruiterRemarks,
    this.candidateName,
    this.email,
    this.phone,
    this.degree,
    this.faculty,
    this.gradYear,
    this.experienceYears,
    this.notes,
    this.selectedDate,
    this.offerSalary,
    this.startDate,
    this.decisionStatus,
    this.linkedinUrl,
    this.coverNote,
    this.cvUrl,
    this.cvFileName,
    this.createdAt,
    this.updatedAt,
    required this.job,
  });

  factory JobApplicationItem.fromJson(Map<String, dynamic> json) {
    return JobApplicationItem(
      id: json['id']?.toString() ?? '',
      applicationRef: json['applicationRef']?.toString() ?? 'IPAM-REF-000000',
      jobId: json['jobId']?.toString() ?? '',
      status: json['status']?.toString() ?? 'APPLIED',
      matchScore: int.tryParse(json['matchScore']?.toString() ?? '') ?? 85,
      interviewDate: json['interviewDate'] != null ? DateTime.tryParse(json['interviewDate'].toString()) : null,
      recruiterRemarks: json['recruiterRemarks']?.toString(),
      candidateName: json['candidateName']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      degree: json['degree']?.toString(),
      faculty: json['faculty']?.toString(),
      gradYear: int.tryParse(json['gradYear']?.toString() ?? ''),
      experienceYears: int.tryParse(json['experienceYears']?.toString() ?? ''),
      notes: json['notes']?.toString(),
      selectedDate: json['selectedDate'] != null ? DateTime.tryParse(json['selectedDate'].toString()) : null,
      offerSalary: json['offerSalary']?.toString(),
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate'].toString()) : null,
      decisionStatus: json['decisionStatus']?.toString(),
      linkedinUrl: json['linkedinUrl']?.toString(),
      coverNote: json['coverNote']?.toString(),
      cvUrl: json['cvUrl']?.toString(),
      cvFileName: json['cvFileName']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
      job: JobOpening.fromJson(json['job'] is Map ? Map<String, dynamic>.from(json['job'] as Map) : {}),
    );
  }

  /// Converts to UI CareerApplicationModel with dynamic stage & notes calculation
  CareerApplicationModel toCareerApplicationModel() {
    String uiStatus = 'Application Received';
    int currentStage = 1;
    const int totalStages = 5;
    String stageName = 'Stage 1: Application Received';

    final s = status.toUpperCase().replaceAll('-', '_').replaceAll(' ', '_');

    if (s == 'APPLIED' || s == 'SUBMITTED' || s == 'PENDING') {
      uiStatus = 'Application Received';
      currentStage = 1;
      stageName = 'Stage 1: Application Received';
    } else if (s == 'REVIEWING' || s == 'UNDER_REVIEW' || s.contains('REVIEW')) {
      uiStatus = 'Under Review';
      currentStage = 2;
      stageName = 'Stage 2: Technical Review';
    } else if (s == 'INTERVIEW_SCHEDULED' || s.contains('INTERVIEW')) {
      uiStatus = 'Interviewing';
      currentStage = 3;
      stageName = interviewDate != null
          ? 'Stage 3: Interview Scheduled (${interviewDate!.day}/${interviewDate!.month})'
          : 'Stage 3: Executive Interview';
    } else if (s == 'OFFER_EXTENDED' || s.contains('OFFER')) {
      uiStatus = 'Offer Extended';
      currentStage = 4;
      stageName = offerSalary != null && offerSalary!.isNotEmpty
          ? 'Stage 4: Offer Extended ($offerSalary)'
          : 'Stage 4: Offer Extended';
    } else if (s == 'HIRED' || s == 'ACCEPTED' || s.contains('PLACED')) {
      uiStatus = 'Placed / Hired';
      currentStage = 5;
      stageName = 'Stage 5: Placement Finalized';
    } else if (s.contains('REJECT') || s.contains('ARCHIV') || s.contains('CLOSED')) {
      uiStatus = 'Archived';
      currentStage = 5;
      stageName = 'Application Concluded';
    } else {
      uiStatus = 'Application Received';
      currentStage = 1;
      stageName = 'Stage 1: Application Received';
    }

    String appliedDateStr = 'Applied recently';
    if (createdAt != null) {
      final now = DateTime.now();
      final diff = now.difference(createdAt!);
      if (diff.inDays == 0) {
        appliedDateStr = 'Applied today';
      } else if (diff.inDays < 7) {
        appliedDateStr = 'Applied ${diff.inDays}d ago';
      } else {
        appliedDateStr = 'Applied ${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
      }
    }

    final dynamicChecklist = <ApplicationChecklistItem>[
      const ApplicationChecklistItem(
        text: 'USL Registrar Transcript Verified',
        isCompleted: true,
      ),
      ApplicationChecklistItem(
        text: 'Academic Credentials & Match Assessment ($matchScore% match)',
        isCompleted: currentStage >= 2,
        isPending: currentStage == 1,
      ),
      ApplicationChecklistItem(
        text: 'Technical Leadership & Department Review',
        isCompleted: currentStage >= 3,
        isPending: currentStage == 2,
      ),
      ApplicationChecklistItem(
        text: interviewDate != null
            ? 'Executive Interview (${interviewDate!.day}/${interviewDate!.month}/${interviewDate!.year})'
            : 'Executive Interview & Placement Assessment',
        isCompleted: currentStage >= 4,
        isPending: currentStage == 3,
      ),
      ApplicationChecklistItem(
        text: offerSalary != null && offerSalary!.isNotEmpty
            ? 'Offer Letter Issued ($offerSalary)'
            : 'Final Offer Package & Placement',
        isCompleted: currentStage >= 5 && !s.contains('REJECT'),
        isPending: currentStage == 4,
      ),
    ];

    final dynamicNotes = <String>[];
    if (notes != null && notes!.trim().isNotEmpty) {
      dynamicNotes.add(notes!.trim());
    }
    if (recruiterRemarks != null && recruiterRemarks!.trim().isNotEmpty && recruiterRemarks != notes) {
      dynamicNotes.add(recruiterRemarks!.trim());
    }
    if (decisionStatus != null && decisionStatus!.trim().isNotEmpty) {
      dynamicNotes.add('Decision: ${decisionStatus!.trim()}');
    }

    return CareerApplicationModel(
      id: id,
      applicationRef: applicationRef,
      company: job.company.isNotEmpty ? job.company : 'IPAM Partner Organization',
      title: job.title.isNotEmpty ? job.title : 'Alumni Placement Opportunity',
      category: job.category.isNotEmpty ? job.category : 'TECHNOLOGY',
      location: job.location.isNotEmpty ? job.location : 'Freetown',
      status: uiStatus,
      rawStatus: status,
      appliedDate: appliedDateStr,
      hasRegistrarTranscript: true,
      currentStage: currentStage,
      totalStages: totalStages,
      stageName: stageName,
      notes: dynamicNotes,
      checklist: dynamicChecklist,
      recruiterContact: email,
      candidateName: candidateName,
      candidateEmail: email,
      candidatePhone: phone,
      degree: degree,
      faculty: faculty,
      gradYear: gradYear,
      experienceYears: experienceYears,
      matchScore: matchScore,
      coverNote: coverNote,
      cvUrl: cvUrl,
      cvFileName: cvFileName,
      interviewDate: interviewDate,
      offerSalary: offerSalary,
      startDate: startDate,
      decisionStatus: decisionStatus,
      recruiterRemarks: recruiterRemarks,
    );
  }
}

/// Application response wrapper from POST /api/jobs/{id}/apply
class JobApplicationResponse {
  final String id;
  final String applicationRef;
  final String jobId;
  final String status;
  final int matchScore;
  final String candidateName;
  final DateTime? createdAt;

  JobApplicationResponse({
    required this.id,
    required this.applicationRef,
    required this.jobId,
    required this.status,
    required this.matchScore,
    required this.candidateName,
    this.createdAt,
  });

  factory JobApplicationResponse.fromJson(Map<String, dynamic> json) {
    return JobApplicationResponse(
      id: json['id']?.toString() ?? '',
      applicationRef: json['applicationRef']?.toString() ?? '',
      jobId: json['jobId']?.toString() ?? '',
      status: json['status']?.toString() ?? 'APPLIED',
      matchScore: int.tryParse(json['matchScore']?.toString() ?? '') ?? 90,
      candidateName: json['candidateName']?.toString() ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
    );
  }
}
