import 'package:flutter/material.dart';
import '../../../services/job_service.dart';
import '../models/career_job_model.dart';
import '../models/career_application_model.dart';
import '../models/career_posting_model.dart';

class CareersProvider {
  final JobService _service;

  CareersProvider({JobService? service}) : _service = service ?? JobService();

  List<CareerJobModel> getAlumniJobs() {
    return [
      const CareerJobModel(
        id: 'job_1',
        title: 'Senior Backend Engineer',
        company: 'Orange Sierra Leone',
        location: 'Hill Station HQ, Freetown (Hybrid)',
        employmentType: 'Full Time',
        preferenceBadge: 'USL Alumni Preferred',
        salary: 'SLL Equivalent / \$1,800 - \$2,500 monthly',
        alumniCount: 4,
        deadline: 'Nov 15, 2026',
        category: 'Technology',
        isVerified: true,
        isApplied: true,
        isBookmarked: false,
        isMyPosting: false,
        logoType: 'orange',
        logoText: 'Orange',
        logoBgColor: Color(0xFF0F172A),
        description:
            'Lead the architectural modernization of core fintech infrastructure supporting Orange Money Sierra Leone. Spearhead microservices scalability, high-availability transaction processing, and API integrations with central banking payment switches.',
        requirements: [
          'B.Sc. or M.Sc. in Computer Science, Software Engineering or related discipline from IPAM USL.',
          '5+ years hands-on experience building distributed systems in Go, Java or Node.js.',
          'Experience with relational and document databases (PostgreSQL, Redis, Kafka).',
          'Proven record in fintech, banking APIs, or telecommunications billing systems.',
        ],
        benefits: [
          'Competitive salary with foreign currency exchange peg.',
          'Executive health insurance covering employee and dependents.',
          'Annual professional conference stipend and tuition support.',
          'Flexible hybrid telecommuting schedule.',
        ],
      ),
      const CareerJobModel(
        id: 'job_2',
        title: 'Senior Policy Analyst - Fiscal Decentralisation',
        company: 'Ministry of Finance',
        location: 'George Street, Freetown',
        employmentType: 'Full Time',
        preferenceBadge: 'USL Alumni Preferred',
        salary: 'Civil Service Grade 8 Scale',
        alumniCount: 12,
        deadline: 'Nov 30, 2026',
        category: 'Public Administration',
        isVerified: true,
        isApplied: true,
        isBookmarked: false,
        isMyPosting: false,
        logoType: 'ministry',
        logoText: 'MOF',
        logoBgColor: Color(0xFF044E3D),
        description:
            'Advise directorate leadership on intergovernmental fiscal transfers, local government revenue autonomy, and municipal financial administration frameworks in alignment with the National Medium-Term Development Plan.',
        requirements: [
          'Master’s degree in Public Administration, Governance, or Economics from IPAM USL.',
          '7+ years experience in public sector budgeting, tax administration, or public financial management.',
          'Demonstrated expertise in econometric analysis and public expenditure reviews.',
          'Strong drafting acumen for ministerial policy memorandums and legislative briefs.',
        ],
        benefits: [
          'Civil service career tenure with pension entitlement.',
          'Government international delegation representation allowances.',
          'Subsidized postgraduate leadership programs.',
        ],
      ),
      const CareerJobModel(
        id: 'job_3',
        title: 'Lead Credit Risk Officer',
        company: 'Sierra Leone Commercial Bank',
        location: 'Siaka Stevens Street, Freetown',
        employmentType: 'Full Time',
        preferenceBadge: 'USL Alumni Preferred',
        salary: 'SLL 35,000,000 - 45,000,000 monthly',
        alumniCount: 18,
        deadline: 'Dec 01, 2026',
        category: 'Finance & Banking',
        isVerified: true,
        isApplied: false,
        isBookmarked: true,
        isMyPosting: false,
        logoType: 'slcb',
        logoText: 'SLCB',
        logoBgColor: Color(0xFF1E3A8A),
        description:
            'Oversee risk assessment of corporate credit portfolios, syndicated loans, and sovereign bond facilities. Formulate credit risk scoring methodologies and monitor prudential compliance ratios under Bank of Sierra Leone guidelines.',
        requirements: [
          'Degree in Banking & Finance, Accounting or Economics from IPAM USL; ACCA/ACIB qualification preferred.',
          '6+ years credit underwriting or enterprise risk management in commercial banking.',
          'Proficiency with IFRS 9 expected credit loss modeling.',
        ],
        benefits: [
          'Generous annual performance bonus structure.',
          'Preferential mortgage and staff concessionary credit rates.',
          'Comprehensive medical and family wellness allowance.',
        ],
      ),
      const CareerJobModel(
        id: 'job_4',
        title: 'Associate Operations & Risk Manager',
        company: 'Sierra Digital Payments (Alumni Founded)',
        companyBadge: '(Alumni Founded)',
        location: 'Wilberforce, Freetown (Hybrid)',
        employmentType: 'Full Time',
        preferenceBadge: 'USL Alumni Preferred',
        salary: '\$1,200 - \$1,600 monthly + equity',
        alumniCount: 6,
        deadline: 'Nov 25, 2026',
        category: 'Technology',
        isVerified: true,
        isApplied: false,
        isBookmarked: false,
        isMyPosting: true,
        logoType: 'sdp',
        logoText: 'SDP',
        logoBgColor: Color(0xFF042F2C),
        description:
            'Partner with executive management to optimize merchant settlement workflows, fraud detection algorithms, and operational audit trails for West Africa’s fast-growing cross-border B2B digital rail.',
        requirements: [
          'B.Sc. in Business Administration, Accounting, or Information Systems from IPAM USL.',
          '3-5 years operational management in fintech, e-commerce, or payments.',
          'Strong data manipulation skills (SQL, Python, or advanced business analytics).',
        ],
        benefits: [
          'Stock option equity pool in a high-growth Series A startup.',
          'Modern co-working hub environment in Wilberforce.',
          'Annual company off-sites in Accra and Nairobi.',
        ],
      ),
      const CareerJobModel(
        id: 'job_5',
        title: 'Senior Tax Auditor & Compliance Lead',
        company: 'National Revenue Authority',
        location: 'Wellington Street, Freetown',
        employmentType: 'Full Time',
        preferenceBadge: 'USL Alumni Preferred',
        salary: 'SLL 28,000,000 - 36,000,000 monthly',
        alumniCount: 9,
        deadline: 'Dec 10, 2026',
        category: 'Public Administration',
        isVerified: true,
        isApplied: true,
        isBookmarked: false,
        isMyPosting: false,
        logoType: 'nra',
        logoText: 'NRA',
        logoBgColor: Color(0xFF065F46),
        description:
            'Lead multi-million dollar corporate tax audits, transfer pricing examinations, and compliance reviews for multinational mining and maritime concessionaires across Sierra Leone.',
        requirements: [
          'B.Sc. in Applied Accounting or Finance from IPAM; Certified Chartered Accountant (ACCA / ICASL).',
          '5+ years conducting complex corporate tax investigations.',
          'In-depth knowledge of Sierra Leone Finance Acts and international double-taxation treaties.',
        ],
        benefits: [
          'Specialist technical allowance.',
          'Vehicle and fuel facilitation subsidy.',
          'Official overseas training with Commonwealth Tax Administrators.',
        ],
      ),
      const CareerJobModel(
        id: 'job_6',
        title: 'Head of Institutional Compliance',
        company: 'Standard Chartered Sierra Leone',
        location: 'Lightfoot Boston Street, Freetown',
        employmentType: 'Full Time',
        preferenceBadge: 'USL Alumni Preferred',
        salary: '\$2,200 - \$3,000 monthly',
        alumniCount: 14,
        deadline: 'Dec 15, 2026',
        category: 'Finance & Banking',
        isVerified: true,
        isApplied: true,
        isBookmarked: true,
        isMyPosting: true,
        logoType: 'standard_chartered',
        logoText: 'SC',
        logoBgColor: Color(0xFF1E293B),
        description:
            'Direct AML/CFT frameworks, sanctions compliance, and regulatory liaison with the Central Bank and Financial Intelligence Unit for international trade finance operations.',
        requirements: [
          'Postgraduate degree in Law, Governance, or Financial Regulation from IPAM USL.',
          'Certified Anti-Money Laundering Specialist (CAMS) credential.',
          '8+ years compliance leadership in tier-1 banking institutions.',
        ],
        benefits: [
          'International secondment opportunities across Standard Chartered Africa & Middle East.',
          'Executive pension and annual profit-sharing scheme.',
          'Comprehensive global medical and travel insurance.',
        ],
      ),
    ];
  }

  List<CareerApplicationModel> getApplications() {
    return [
      const CareerApplicationModel(
        id: 'app_1',
        company: 'Sierra Digital Payments (Alumni Founded)',
        title: 'Associate Operations & Risk Manager',
        category: 'TECHNOLOGY',
        location: 'Wilberforce',
        status: 'Under Review',
        appliedDate: 'Applied just now',
        hasRegistrarTranscript: true,
        currentStage: 1,
        totalStages: 5,
        stageName: 'Application Received',
        notes: [
          'Finance degree and official GPA records with the hiring committee.',
        ],
        checklist: [
          ApplicationChecklistItem(
            text: 'Official transcript received and authenticated by USL Registrar archives.',
            isCompleted: true,
          ),
          ApplicationChecklistItem(
            text: 'Candidate portfolio under initial screening by Hiring Lead.',
            isCompleted: false,
            isPending: true,
          ),
        ],
        recruiterContact: 'recruitment@sierradigital.sl',
      ),
      const CareerApplicationModel(
        id: 'app_2',
        company: 'African Development Bank (AfDB)',
        title: 'Economics Research Fellow',
        category: 'MULTILATERAL ORG',
        location: 'Regional Headquarters',
        status: 'Application Received',
        appliedDate: 'Applied Sep 28, 2026',
        hasRegistrarTranscript: true,
        currentStage: 1,
        totalStages: 5,
        stageName: 'Application Intake',
        checklist: [
          ApplicationChecklistItem(
            text: 'Matriculation degree verified by USL Registrar archives',
            isCompleted: true,
          ),
          ApplicationChecklistItem(
            text: 'Candidate file added to 2026 Young African Scholars intake database.',
            isCompleted: false,
            isPending: true,
          ),
        ],
        recruiterContact: 'careers@afdb.org',
      ),
      const CareerApplicationModel(
        id: 'app_3',
        company: 'Orange Sierra Leone',
        title: 'Senior Backend Engineer',
        category: 'TECHNOLOGY',
        location: 'Hill Station HQ',
        status: 'Under Review',
        appliedDate: 'Applied Oct 02, 2026',
        hasRegistrarTranscript: true,
        currentStage: 2,
        totalStages: 5,
        stageName: 'Technical Assessment',
        notes: [
          'System architecture task received and forwarded to engineering directors.',
        ],
        recruiterContact: 'talent@orange.sl',
      ),
      const CareerApplicationModel(
        id: 'app_4',
        company: 'Standard Chartered Sierra Leone',
        title: 'Head of Institutional Compliance',
        category: 'FINANCE & BANKING',
        location: 'Lightfoot Boston Street',
        status: 'Interviewing',
        appliedDate: 'Applied Oct 12, 2026',
        hasRegistrarTranscript: true,
        currentStage: 3,
        totalStages: 5,
        stageName: 'Executive Panel Interview',
        notes: [
          'Panel interview confirmed for November 2nd with Managing Director.',
        ],
        recruiterContact: 'hr.sl@sc.com',
      ),
      const CareerApplicationModel(
        id: 'app_5',
        company: 'Ministry of Finance',
        title: 'Senior Policy Analyst - Fiscal Decentralisation',
        category: 'PUBLIC ADMINISTRATION',
        location: 'George Street',
        status: 'Under Review',
        appliedDate: 'Applied Oct 15, 2026',
        hasRegistrarTranscript: true,
        currentStage: 1,
        totalStages: 5,
        stageName: 'Civil Service Vetting',
        notes: [
          'Institutional vetting in progress with Public Sector Reform Unit.',
        ],
        recruiterContact: 'recruitment@mof.gov.sl',
      ),
      const CareerApplicationModel(
        id: 'app_6',
        company: 'National Revenue Authority',
        title: 'Senior Tax Auditor & Compliance Lead',
        category: 'PUBLIC ADMINISTRATION',
        location: 'Wellington Street',
        status: 'Application Received',
        appliedDate: 'Applied Oct 20, 2026',
        hasRegistrarTranscript: true,
        currentStage: 1,
        totalStages: 5,
        stageName: 'Registrar Intake',
        notes: [
          'Degree transcript and ICASL certification undergoing verification.',
        ],
        recruiterContact: 'careers@nra.gov.sl',
      ),
    ];
  }

  List<CareerPostingModel> getMyPostings() {
    return [
      const CareerPostingModel(
        id: 'post_1',
        title: 'Financial Systems Auditor & Risk Specialist',
        company: 'Central Bank of Sierra Leone',
        category: 'FINANCE & BANKING',
        postedDate: 'Posted Oct 8, 2026',
        status: 'Active',
        location: 'Siaka Stevens Street, Freetown',
        salary: 'SLL 35,000,000 - 45,000,000 monthly',
        deadline: 'Deadline: Dec 01, 2026',
        priorityBadge: 'Priority Alumni Tier',
        applicantsCount: 3,
        hasNewApplicants: true,
        logoText: 'BSL',
        logoBgColor: Color(0xFF0F291E),
        logoTextColor: Color(0xFFF59E0B),
        applicants: [
          PostingApplicant(
            name: 'Ibrahim S. Mansaray',
            graduationClass: 'Class of 2020',
            degree: 'B.Sc. Applied Accounting (Honours)',
            status: 'Shortlisted',
            avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80',
          ),
          PostingApplicant(
            name: 'Mariama K. Kamara',
            graduationClass: 'Class of 2018',
            degree: 'M.Sc. Banking & Finance',
            status: 'Reviewing',
            avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=300&q=80',
          ),
          PostingApplicant(
            name: 'Abu Bakarr Sesay',
            graduationClass: 'Class of 2022',
            degree: 'B.Sc. Financial Services',
            status: 'New',
            avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
          ),
        ],
      ),
      const CareerPostingModel(
        id: 'post_2',
        title: 'Associate Operations & Risk Manager',
        company: 'Sierra Digital Payments (Alumni Founded)',
        category: 'TECHNOLOGY',
        postedDate: 'Posted Oct 1, 2026',
        status: 'Active',
        location: 'Wilberforce, Freetown',
        salary: '\$1,200 - \$1,600 monthly',
        deadline: 'Deadline: Nov 25, 2026',
        priorityBadge: 'Priority Alumni Tier',
        applicantsCount: 1,
        hasNewApplicants: false,
        logoText: 'SDP',
        logoBgColor: Color(0xFF042F2C),
        logoTextColor: Color(0xFFF59E0B),
        applicants: [
          PostingApplicant(
            name: 'Fatmata B. Turay',
            graduationClass: 'Class of 2021',
            degree: 'B.Sc. Business Information Technology',
            status: 'Interview Scheduled',
            avatarUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&w=300&q=80',
          ),
        ],
      ),
    ];
  }

  /// Dynamic API: Fetches user's saved/bookmarked jobs from GET /api/jobs/saved
  Future<List<CareerJobModel>> fetchSavedJobs() async {
    try {
      final savedOpenings = await _service.fetchSavedJobs();
      return savedOpenings.map((o) => o.toCareerJobModel()).toList();
    } catch (_) {
      return [];
    }
  }

  /// Dynamic API: Fetches live jobs from GET /api/jobs with fallback to curated list
  Future<List<CareerJobModel>> fetchJobs({
    String? query,
    String? category,
    String? type,
    String? workplaceType,
    String? currentUserId,
    String? currentUserName,
    Set<String>? savedJobIds,
  }) async {
    try {
      final openings = await _service.fetchJobs(
        query: query,
        category: category,
        type: type,
        workplaceType: workplaceType,
      );

      if (openings.isNotEmpty) {
        return openings.map((o) {
          final isMyPost = (currentUserId != null &&
                  currentUserId.isNotEmpty &&
                  (o.postedByAlumniId == currentUserId ||
                      o.postedByAlumni?['id'] == currentUserId ||
                      o.postedByAlumni?['userId'] == currentUserId)) ||
              (currentUserName != null &&
                  currentUserName.isNotEmpty &&
                  (o.postedByName?.toLowerCase() == currentUserName.toLowerCase() ||
                      o.postedByAlumni?['name']?.toString().toLowerCase() ==
                          currentUserName.toLowerCase()));
          final isSaved = (savedJobIds != null && savedJobIds.contains(o.id)) || o.saved;
          final model = o.toCareerJobModel(isCurrentUserPosting: isMyPost);
          return isSaved ? model.copyWith(isBookmarked: true) : model;
        }).toList();
      } else if (query != null || category != null) {
        return [];
      }
    } catch (_) {}

    final fallback = getAlumniJobs();
    if (savedJobIds != null && savedJobIds.isNotEmpty) {
      return fallback.map((j) {
        if (savedJobIds.contains(j.id)) {
          return j.copyWith(isBookmarked: true);
        }
        return j;
      }).toList();
    }
    return fallback;
  }

  /// Dynamic API: Fetches user's active job applications from GET /api/jobs/my-applications
  Future<List<CareerApplicationModel>> fetchMyApplications({bool isUserAuthenticated = false}) async {
    try {
      final apiApplications = await _service.fetchMyApplications();
      return apiApplications.map((a) => a.toCareerApplicationModel()).toList();
    } catch (_) {}

    return isUserAuthenticated ? [] : getApplications();
  }

  /// Dynamic API: Fetches user's posted requisitions from GET /api/jobs
  Future<List<CareerPostingModel>> fetchMyPostings({
    String? currentUserId,
    String? currentUserName,
    bool isUserAuthenticated = false,
  }) async {
    try {
      final allOpenings = await _service.fetchJobs();
      final myOpenings = allOpenings.where((o) {
        if (currentUserId != null && currentUserId.isNotEmpty) {
          if (o.postedByAlumniId == currentUserId ||
              o.postedByAlumni?['id'] == currentUserId ||
              o.postedByAlumni?['userId'] == currentUserId) {
            return true;
          }
        }
        if (currentUserName != null && currentUserName.isNotEmpty) {
          final authorName = (o.postedByName ?? o.postedByAlumni?['name']?.toString() ?? '').toLowerCase();
          if (authorName.isNotEmpty && authorName == currentUserName.toLowerCase()) {
            return true;
          }
        }
        return false;
      }).toList();

      return myOpenings.map((o) => o.toCareerPostingModel()).toList();
    } catch (_) {}

    return isUserAuthenticated ? [] : getMyPostings();
  }

  /// Dynamic API: Toggles saving a job
  Future<bool> toggleSaveJob(String jobId) async {
    return await _service.toggleSaveJob(jobId);
  }

  /// Dynamic API: Submits application for a job
  Future<CareerApplicationModel?> applyForJob(
    String jobId, {
    required String candidateName,
    required String email,
    String? phone,
    String? degree,
    String? faculty,
    int? gradYear,
    int? experienceYears,
    List<String>? skills,
    String? linkedinUrl,
    String? coverNote,
    String? cvUrl,
    String? cvFileName,
  }) async {
    try {
      final response = await _service.applyForJob(
        jobId,
        candidateName: candidateName,
        email: email,
        phone: phone,
        degree: degree,
        faculty: faculty,
        gradYear: gradYear,
        experienceYears: experienceYears,
        skills: skills,
        linkedinUrl: linkedinUrl,
        coverNote: coverNote,
        cvUrl: cvUrl,
        cvFileName: cvFileName,
      );

      if (response != null) {
        return CareerApplicationModel(
          id: response.id,
          applicationRef: response.applicationRef,
          company: 'Applied Organization',
          title: 'Career Opportunity',
          category: 'TECHNOLOGY',
          location: 'Freetown, Sierra Leone',
          status: 'Application Received',
          rawStatus: response.status,
          appliedDate: 'Applied just now',
          hasRegistrarTranscript: true,
          currentStage: 1,
          totalStages: 5,
          stageName: 'Stage 1: Application Received',
          notes: ['Application Reference: ${response.applicationRef}'],
          checklist: const [
            ApplicationChecklistItem(text: 'USL Registrar Transcript Verified', isCompleted: true),
            ApplicationChecklistItem(text: 'Academic Credentials & Match Assessment', isPending: true),
            ApplicationChecklistItem(text: 'Technical Leadership Evaluation', isCompleted: false),
            ApplicationChecklistItem(text: 'Executive Interview & Placement', isCompleted: false),
            ApplicationChecklistItem(text: 'Final Offer Package & Placement', isCompleted: false),
          ],
          candidateName: candidateName,
          candidateEmail: email,
          candidatePhone: phone,
          degree: degree,
          faculty: faculty,
          gradYear: gradYear,
          experienceYears: experienceYears,
          matchScore: response.matchScore,
          coverNote: coverNote,
          cvUrl: cvUrl,
          cvFileName: cvFileName,
        );
      }
    } catch (_) {}

    return null;
  }

  /// Dynamic API: Publishes vacancy to network
  Future<CareerPostingModel?> postVacancy({
    required String title,
    required String company,
    required String location,
    required String salary,
    required String category,
    required String description,
    String type = 'FULL_TIME',
    String workplaceType = 'HYBRID',
    List<String>? requirements,
    String? deadline,
  }) async {
    final created = await _service.postJobVacancy(
      title: title,
      company: company,
      location: location,
      salary: salary,
      category: category,
      description: description,
      type: type,
      workplaceType: workplaceType,
      requirements: requirements,
      deadline: deadline,
    );

    if (created != null) {
      return created.toCareerPostingModel();
    }
    return null;
  }

  /// Dynamic API: Updates job status
  Future<bool> updatePostingStatus(String jobId, String status) async {
    return await _service.updateJobStatus(jobId, status);
  }

  /// Dynamic API: Deletes job
  Future<bool> deletePosting(String jobId) async {
    return await _service.deleteJob(jobId);
  }
}
