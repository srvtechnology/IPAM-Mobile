import '../../../core/network/api_client.dart';

class AlumniModel {
  final String id;
  final String name;
  final String role;
  final String faculty;
  final int graduationYear;
  final String location;
  final String badge;
  final bool isMentor;
  final bool isExecutiveLeader;
  final bool isVerified;
  final String category;
  final String chapter;
  final String avatarUrl;
  final String? email;
  final String? degree;
  final String? major;
  final String? company;
  final String? currentRole;
  final String? country;
  final String? industry;
  final List<String> skills;
  final bool isConnected;
  final String? honorific;
  final String? registrationNumber;
  final String? campus;
  final String? seniority;
  final String? councilRole;
  final String? fellowsMentored;
  final String? membershipType;
  final String? quoteHeader;
  final String? quoteText;
  final String? biography;
  final String? officeLocation;
  final String? officeHours;
  final String? linkedin;

  AlumniModel({
    required this.id,
    required this.name,
    required this.role,
    required this.faculty,
    required this.graduationYear,
    required this.location,
    required this.badge,
    this.isMentor = false,
    this.isExecutiveLeader = false,
    this.isVerified = true,
    required this.category,
    required this.chapter,
    required this.avatarUrl,
    this.email,
    this.degree,
    this.major,
    this.company,
    this.currentRole,
    this.country,
    this.industry,
    this.skills = const [],
    this.isConnected = false,
    this.honorific,
    this.registrationNumber,
    this.campus,
    this.seniority,
    this.councilRole,
    this.fellowsMentored,
    this.membershipType,
    this.quoteHeader,
    this.quoteText,
    this.biography,
    this.officeLocation,
    this.officeHours,
    this.linkedin,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final f = parts[0].isNotEmpty ? parts[0][0] : '';
      final l = parts.last.isNotEmpty ? parts.last[0] : '';
      return '$f$l'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'AL';
  }

  String get displayRole {
    if (role.isNotEmpty) return role;
    if ((currentRole != null && currentRole!.isNotEmpty) &&
        (company != null && company!.isNotEmpty)) {
      return '$currentRole • $company';
    }
    if (currentRole != null && currentRole!.isNotEmpty) return currentRole!;
    if (company != null && company!.isNotEmpty) return company!;
    return 'Verified Alumnus';
  }

  String get displayFullName {
    if (honorific != null && honorific!.isNotEmpty) {
      if (!name.contains(honorific!)) {
        return '$name, $honorific';
      }
    }
    return name;
  }

  String get displayRegistrationNumber =>
      registrationNumber ??
      'USL/IPAM/${(graduationYear - 4).toString().padLeft(2, '0')}/${id.padLeft(4, '0')}';

  String get displayCampus => campus ?? '$location, Sierra Leone';

  String get displaySeniority =>
      seniority ?? '${DateTime.now().year - graduationYear}+ Years';

  String get displayCouncilRole =>
      councilRole ?? (isExecutiveLeader ? 'Executive' : 'Council Leadership');

  String get displayFellowsMentored =>
      fellowsMentored ?? (isMentor ? '50+ Fellows' : '25+ Fellows');

  String get displayMembershipType =>
      membershipType ?? (isExecutiveLeader ? 'Life Member' : 'Giving Circle Patron');

  String get displayQuoteHeader =>
      quoteHeader ?? (isExecutiveLeader ? 'PRESIDENTIAL ADDRESS' : 'ALUMNI LEADERSHIP STATEMENT');

  String get displayQuoteText =>
      quoteText ??
      '“Empowering the next generation of Sierra Leonean administrators and corporate pioneers through global solidarity.”';

  String get displayBiography =>
      biography ??
      '$name enrolled at IPAM’s Tower Hill campus in ${(graduationYear - 4)}, graduating at the pinnacle of their cohort in $graduationYear. Driven by a resolute commitment to civic transformation, they pursued advanced studies in Public Policy and Governance, pioneering administrative efficiency models for emerging markets. Over the past two decades, they have spearheaded institutional modernizations, anti-corruption frameworks, and fiscal auditing standards across Sierra Leone and the ECOWAS sub-region. Under their stewardship, the IPAM USL Global Alumni Network has unified international chapters spanning London, Washington D.C., Banjul, and Freetown—bolstering institutional endowment funds and scholarship programs for meritorious young scholars.';

  String get displayEmail =>
      email ??
      '${name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '')}@ipam.usl.edu.sl';

  String get displayOfficeLocation =>
      officeLocation ?? 'Secretariat Office, IPAM Tower Hill';

  String get displayOfficeHours => officeHours ?? 'Tue & Thu 14:00 GMT';

  String get displayLinkedin =>
      linkedin ??
      'linkedin.com/in/${name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-')}';

  AlumniModel copyWith({
    String? id,
    String? name,
    String? role,
    String? faculty,
    int? graduationYear,
    String? location,
    String? badge,
    bool? isMentor,
    bool? isExecutiveLeader,
    bool? isVerified,
    String? category,
    String? chapter,
    String? avatarUrl,
    String? email,
    String? degree,
    String? major,
    String? company,
    String? currentRole,
    String? country,
    String? industry,
    List<String>? skills,
    bool? isConnected,
    String? honorific,
    String? registrationNumber,
    String? campus,
    String? seniority,
    String? councilRole,
    String? fellowsMentored,
    String? membershipType,
    String? quoteHeader,
    String? quoteText,
    String? biography,
    String? officeLocation,
    String? officeHours,
    String? linkedin,
  }) {
    return AlumniModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      faculty: faculty ?? this.faculty,
      graduationYear: graduationYear ?? this.graduationYear,
      location: location ?? this.location,
      badge: badge ?? this.badge,
      isMentor: isMentor ?? this.isMentor,
      isExecutiveLeader: isExecutiveLeader ?? this.isExecutiveLeader,
      isVerified: isVerified ?? this.isVerified,
      category: category ?? this.category,
      chapter: chapter ?? this.chapter,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
      degree: degree ?? this.degree,
      major: major ?? this.major,
      company: company ?? this.company,
      currentRole: currentRole ?? this.currentRole,
      country: country ?? this.country,
      industry: industry ?? this.industry,
      skills: skills ?? this.skills,
      isConnected: isConnected ?? this.isConnected,
      honorific: honorific ?? this.honorific,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      campus: campus ?? this.campus,
      seniority: seniority ?? this.seniority,
      councilRole: councilRole ?? this.councilRole,
      fellowsMentored: fellowsMentored ?? this.fellowsMentored,
      membershipType: membershipType ?? this.membershipType,
      quoteHeader: quoteHeader ?? this.quoteHeader,
      quoteText: quoteText ?? this.quoteText,
      biography: biography ?? this.biography,
      officeLocation: officeLocation ?? this.officeLocation,
      officeHours: officeHours ?? this.officeHours,
      linkedin: linkedin ?? this.linkedin,
    );
  }

  factory AlumniModel.defaultAminata() {
    return AlumniModel(
      id: '1',
      name: 'Prof. Aminata Bangura, Ph.D.',
      honorific: 'FCPA',
      role: 'President, Alumni Association & Professor of Public Governance',
      faculty: 'Faculty of Public Administration and Management',
      graduationYear: 1998,
      location: 'Tower Hill Campus',
      campus: 'Tower Hill Campus, Freetown, Sierra Leone',
      badge: 'Executive Council Leader',
      isExecutiveLeader: true,
      isMentor: true,
      isVerified: true,
      category: 'Executive Council',
      chapter: 'Sierra Leone',
      avatarUrl:
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=300&q=80',
      degree: 'Ph.D. Public Policy & Governance',
      registrationNumber: 'USL/IPAM/94/0821',
      seniority: '26+ Years',
      councilRole: 'Executive',
      fellowsMentored: '50+ Fellows',
      membershipType: 'Life Member',
      quoteHeader: 'PRESIDENTIAL ADDRESS',
      quoteText:
          '“Empowering the next generation of Sierra Leonean administrators and corporate pioneers through global solidarity.”',
      biography:
          'Prof. Aminata Bangura enrolled at IPAM’s Tower Hill campus in 1994, graduating at the pinnacle of her cohort in 1998. Driven by a resolute commitment to civic transformation, she pursued doctoral studies in Public Policy and Governance, pioneering administrative efficiency models for emerging markets. Over the past two decades, she has spearheaded state apparatus modernizations, anti-corruption frameworks, and fiscal auditing standards across Sierra Leone and the ECOWAS sub-region. Under her stewardship, the IPAM USL Global Alumni Network has unified international chapters spanning London, Washington D.C., Banjul, and Freetown—bolstering institutional endowment funds and scholarship programs for meritorious young scholars.',
      email: 'a.bangura@ipam.usl.edu.sl',
      officeLocation: 'Secretariat Office, IPAM Tower Hill',
      officeHours: 'Tue & Thu 14:00 GMT',
      linkedin: 'linkedin.com/in/prof-aminata-bangura',
    );
  }

  factory AlumniModel.fromJson(Map<String, dynamic> json) {
    // 1. Graduation / Class Year
    final rawYear = json['classYear'] ?? json['graduationYear'] ?? json['gradYear'];
    final int gradYear = rawYear is int
        ? rawYear
        : int.tryParse(rawYear?.toString() ?? '') ?? 2020;

    // 2. Roles, Company, and Display Role
    final currentRole = json['currentRole']?.toString() ?? '';
    final company = json['company']?.toString() ?? '';
    String role = json['role'] ?? json['title'] ?? '';
    if (role.isEmpty) {
      if (currentRole.isNotEmpty && company.isNotEmpty) {
        role = '$currentRole • $company';
      } else if (currentRole.isNotEmpty) {
        role = currentRole;
      } else if (company.isNotEmpty) {
        role = company;
      } else {
        role = 'Verified Alumnus';
      }
    }

    // 3. Faculty / Department
    final faculty = json['faculty'] ??
        json['major'] ??
        json['department'] ??
        json['degree'] ??
        'Faculty of Public Administration and Management';

    // 4. Location & Chapter
    final location = json['location'] ?? json['campus'] ?? 'Tower Hill Campus';
    final country = json['country']?.toString() ?? 'Sierra Leone';

    String chapter = json['chapter'] ?? '';
    if (chapter.isEmpty) {
      final locLower = '$location $country'.toLowerCase();
      if (locLower.contains('uk') || locLower.contains('london') || locLower.contains('kingdom')) {
        chapter = 'United Kingdom';
      } else if (locLower.contains('nairobi') || locLower.contains('ghana') || locLower.contains('nigeria') || locLower.contains('west africa')) {
        chapter = 'West Africa';
      } else if (locLower.contains('usa') || locLower.contains('america') || locLower.contains('canada')) {
        chapter = 'North America';
      } else {
        chapter = 'Sierra Leone';
      }
    }

    // 5. Category & Industry
    final industry = json['industry']?.toString() ?? json['category']?.toString() ?? 'General';
    String category = json['category'] ?? '';
    final bool isExec = json['isExecutiveLeader'] == true ||
        role.toLowerCase().contains('president') ||
        role.toLowerCase().contains('director') ||
        role.toLowerCase().contains('council') ||
        industry.toLowerCase().contains('governance');

    if (category.isEmpty) {
      final indLower = industry.toLowerCase();
      if (indLower.contains('finance') || indLower.contains('bank') || indLower.contains('treasury')) {
        category = 'Finance & Accounting';
      } else if (indLower.contains('admin') || indLower.contains('policy') || indLower.contains('development')) {
        category = 'Public Admin';
      } else if (isExec) {
        category = 'Executive Council';
      } else {
        category = 'Executive Council';
      }
    }

    // 6. Mentor Status & Badge
    final bool isMentor = json['isMentor'] == true;
    String badge = json['badge'] ?? '';
    if (badge.isEmpty) {
      if (isExec) {
        badge = 'Executive Council Leader';
      } else if (isMentor) {
        badge = 'Active Mentor';
      } else {
        badge = 'USL Verified';
      }
    }

    // 7. Avatar
    final rawAvatar = json['avatar'] ?? json['avatarUrl'];
    final String avatarUrl = (rawAvatar != null && rawAvatar.toString().trim().isNotEmpty)
        ? ApiClient.formatUrl(rawAvatar.toString().trim())
        : '';

    // 8. Skills
    final skills = (json['skills'] as List? ?? [])
        .map((e) => e.toString())
        .where((s) => s.isNotEmpty)
        .toList();

    return AlumniModel(
      id: json['id']?.toString() ?? json['alumniId']?.toString() ?? '',
      name: json['name'] ?? json['fullName'] ?? '',
      role: role,
      faculty: faculty,
      graduationYear: gradYear,
      location: location,
      badge: badge,
      isMentor: isMentor,
      isExecutiveLeader: isExec,
      isVerified: json['isVerified'] ?? json['isVerifiedAlumni'] ?? true,
      category: category,
      chapter: chapter,
      avatarUrl: avatarUrl,
      email: json['email'],
      degree: json['degree'],
      major: json['major'],
      company: company.isNotEmpty ? company : null,
      currentRole: currentRole.isNotEmpty ? currentRole : null,
      country: country,
      industry: industry,
      skills: skills,
      isConnected: json['isConnected'] == true,
      honorific: json['honorific'],
      registrationNumber: json['registrationNumber'],
      campus: json['campus'],
      seniority: json['seniority'],
      councilRole: json['councilRole'],
      fellowsMentored: json['fellowsMentored'],
      membershipType: json['membershipType'],
      quoteHeader: json['quoteHeader'],
      quoteText: json['quoteText'],
      biography: json['bio'] ?? json['biography'],
      officeLocation: json['officeLocation'],
      officeHours: json['officeHours'],
      linkedin: json['linkedin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'faculty': faculty,
      'graduationYear': graduationYear,
      'location': location,
      'badge': badge,
      'isMentor': isMentor,
      'isExecutiveLeader': isExecutiveLeader,
      'isVerified': isVerified,
      'category': category,
      'chapter': chapter,
      'avatarUrl': avatarUrl,
      'email': email,
      'degree': degree,
      'major': major,
      'company': company,
      'currentRole': currentRole,
      'country': country,
      'industry': industry,
      'skills': skills,
      'isConnected': isConnected,
      'honorific': honorific,
      'registrationNumber': registrationNumber,
      'campus': campus,
      'seniority': seniority,
      'councilRole': councilRole,
      'fellowsMentored': fellowsMentored,
      'membershipType': membershipType,
      'quoteHeader': quoteHeader,
      'quoteText': quoteText,
      'biography': biography,
      'officeLocation': officeLocation,
      'officeHours': officeHours,
      'linkedin': linkedin,
    };
  }
}
