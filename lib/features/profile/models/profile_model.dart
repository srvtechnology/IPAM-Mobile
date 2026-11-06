class ProfileModel {
  final String id;
  final String fullName;
  final String degree;
  final int graduationYear;
  final String degreeCohort;
  final String currentRole;
  final String currentCompany;
  final String location;
  final String avatarUrl;
  final int yearsAlumni;
  final String givingCircle;
  final String cohortRole;
  final String memberId;
  final String expires;
  final String campus;
  final String membershipTier;
  final bool isVerified;
  final bool isSynchronized;
  final int duesAmountPaid;
  final int registeredEventsCount;
  final int savedApplicationsCount;
  final int postedJobsCount;
  final bool isMentorAvailable;
  final bool biometricAuthEnabled;
  final bool directoryVisibilityEnabled;
  final String major;
  final String industrySector;
  final String country;
  final String linkedinUrl;
  final List<String> skills;
  final String bio;

  const ProfileModel({
    required this.id,
    required this.fullName,
    required this.degree,
    required this.graduationYear,
    required this.degreeCohort,
    required this.currentRole,
    required this.currentCompany,
    required this.location,
    required this.avatarUrl,
    required this.yearsAlumni,
    required this.givingCircle,
    required this.cohortRole,
    required this.memberId,
    required this.expires,
    this.campus = 'IPAM • Tower Hill Campus',
    this.membershipTier = 'PLATINUM',
    this.isVerified = true,
    this.isSynchronized = true,
    this.duesAmountPaid = 150,
    this.registeredEventsCount = 2,
    this.savedApplicationsCount = 4,
    this.postedJobsCount = 2,
    this.isMentorAvailable = true,
    this.biometricAuthEnabled = true,
    this.directoryVisibilityEnabled = true,
    this.major = 'Banking & Finance',
    this.industrySector = 'Banking & Financial Services',
    this.country = 'Sierra Leone',
    this.linkedinUrl = 'https://linkedin.com/in/mohamed-bangura',
    this.skills = const [
      'Financial Auditing',
      'Tax Compliance',
      'Strategic Governance',
      'Risk Management',
    ],
    this.bio = 'Senior Financial Analyst at Central Bank of Sierra Leone with extensive experience in macro-prudential oversight and regulatory compliance.',
  });

  ProfileModel copyWith({
    String? id,
    String? fullName,
    String? degree,
    int? graduationYear,
    String? degreeCohort,
    String? currentRole,
    String? currentCompany,
    String? location,
    String? avatarUrl,
    int? yearsAlumni,
    String? givingCircle,
    String? cohortRole,
    String? memberId,
    String? expires,
    String? campus,
    String? membershipTier,
    bool? isVerified,
    bool? isSynchronized,
    int? duesAmountPaid,
    int? registeredEventsCount,
    int? savedApplicationsCount,
    int? postedJobsCount,
    bool? isMentorAvailable,
    bool? biometricAuthEnabled,
    bool? directoryVisibilityEnabled,
    String? major,
    String? industrySector,
    String? country,
    String? linkedinUrl,
    List<String>? skills,
    String? bio,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      degree: degree ?? this.degree,
      graduationYear: graduationYear ?? this.graduationYear,
      degreeCohort: degreeCohort ?? this.degreeCohort,
      currentRole: currentRole ?? this.currentRole,
      currentCompany: currentCompany ?? this.currentCompany,
      location: location ?? this.location,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      yearsAlumni: yearsAlumni ?? this.yearsAlumni,
      givingCircle: givingCircle ?? this.givingCircle,
      cohortRole: cohortRole ?? this.cohortRole,
      memberId: memberId ?? this.memberId,
      expires: expires ?? this.expires,
      campus: campus ?? this.campus,
      membershipTier: membershipTier ?? this.membershipTier,
      isVerified: isVerified ?? this.isVerified,
      isSynchronized: isSynchronized ?? this.isSynchronized,
      duesAmountPaid: duesAmountPaid ?? this.duesAmountPaid,
      registeredEventsCount: registeredEventsCount ?? this.registeredEventsCount,
      savedApplicationsCount: savedApplicationsCount ?? this.savedApplicationsCount,
      postedJobsCount: postedJobsCount ?? this.postedJobsCount,
      isMentorAvailable: isMentorAvailable ?? this.isMentorAvailable,
      biometricAuthEnabled: biometricAuthEnabled ?? this.biometricAuthEnabled,
      directoryVisibilityEnabled: directoryVisibilityEnabled ?? this.directoryVisibilityEnabled,
      major: major ?? this.major,
      industrySector: industrySector ?? this.industrySector,
      country: country ?? this.country,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      skills: skills ?? this.skills,
      bio: bio ?? this.bio,
    );
  }

  static ProfileModel defaultMohamedProfile() {
    return const ProfileModel(
      id: 'usr_mohamed_bangura_2016',
      fullName: 'Mohamed S. Bangura',
      degree: 'B.Sc. Banking & Finance',
      graduationYear: 2016,
      degreeCohort: 'B.Sc. Banking & Finance (Class of 2016)',
      currentRole: 'Senior Financial Analyst at Central Bank of Sierra Leone',
      currentCompany: 'Central Bank of Sierra Leone',
      location: 'Freetown, Sierra Leone',
      avatarUrl: '',
      yearsAlumni: 10,
      givingCircle: 'Active',
      cohortRole: 'Mentor',
      memberId: 'IPAM-ALUM-2016-8841',
      expires: 'DEC 2028',
      campus: 'IPAM • Tower Hill Campus',
      isVerified: true,
      isSynchronized: true,
      duesAmountPaid: 150,
      registeredEventsCount: 2,
      savedApplicationsCount: 4,
      postedJobsCount: 2,
      isMentorAvailable: true,
      biometricAuthEnabled: true,
      directoryVisibilityEnabled: true,
      major: 'Banking & Finance',
      industrySector: 'Banking & Financial Services',
      country: 'Sierra Leone',
      linkedinUrl: 'https://linkedin.com/in/mohamed-bangura',
      skills: [
        'Financial Auditing',
        'Tax Compliance',
        'Strategic Governance',
        'Risk Management',
      ],
      bio:
          'Senior Financial Analyst at Central Bank of Sierra Leone with extensive experience in macro-prudential oversight and regulatory compliance.',
    );
  }
}
