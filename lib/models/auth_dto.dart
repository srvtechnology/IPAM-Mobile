class RegistrationDraft {
  final String email;
  final String studentId;
  final String password;
  final String name;
  final int classYear;
  final String degree;
  final String major;
  final String? currentRole;
  final String? company;
  final String? location;
  final String? country;
  final String? industry;
  final String? bio;
  final bool isMentor;

  RegistrationDraft({
    required this.email,
    required this.studentId,
    required this.password,
    required this.name,
    required this.classYear,
    required this.degree,
    required this.major,
    this.currentRole,
    this.company,
    this.location,
    this.country = 'Sierra Leone',
    this.industry,
    this.bio,
    this.isMentor = false,
  });

  Map<String, dynamic> toJson({required String otp}) {
    return {
      'email': email.trim().toLowerCase(),
      'studentId': studentId.trim(),
      'password': password,
      'name': name.trim(),
      'classYear': classYear,
      'degree': degree.trim(),
      'major': major.trim(),
      'currentRole': currentRole?.trim() ?? '',
      'company': company?.trim() ?? '',
      'location': location?.trim() ?? '',
      'country': country?.trim() ?? 'Sierra Leone',
      'industry': industry?.trim() ?? 'General',
      'bio': bio?.trim() ?? '',
      'isMentor': isMentor,
      'otp': otp.trim(),
    };
  }

  factory RegistrationDraft.fromJson(Map<String, dynamic> json) {
    return RegistrationDraft(
      email: json['email']?.toString() ?? '',
      studentId: json['studentId']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      classYear: json['classYear'] is int
          ? json['classYear'] as int
          : int.tryParse(json['classYear']?.toString() ?? '2022') ?? 2022,
      degree: json['degree']?.toString() ?? '',
      major: json['major']?.toString() ?? '',
      currentRole: json['currentRole']?.toString(),
      company: json['company']?.toString(),
      location: json['location']?.toString(),
      country: json['country']?.toString() ?? 'Sierra Leone',
      industry: json['industry']?.toString(),
      bio: json['bio']?.toString(),
      isMentor: json['isMentor'] == true,
    );
  }
}

