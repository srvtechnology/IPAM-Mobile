class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final int? graduationYear;
  final String? degree;
  final String? department;
  final String? membershipNumber;
  final String? avatarUrl;
  final String? currentCompany;
  final String? currentRole;
  final String? location;
  final bool isVerified;
  final bool hasDigitalCard;
  final String role;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.graduationYear,
    this.degree,
    this.department,
    this.membershipNumber,
    this.avatarUrl,
    this.currentCompany,
    this.currentRole,
    this.location,
    this.isVerified = false,
    this.hasDigitalCard = false,
    this.role = 'alumni',
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> rawJson) {
    final effective = rawJson.containsKey('data') && rawJson['data'] is Map<String, dynamic>
        ? rawJson['data'] as Map<String, dynamic>
        : rawJson;

    final profile = effective['profile'] is Map<String, dynamic>
        ? effective['profile'] as Map<String, dynamic>
        : null;

    final alumniRecord = effective['alumniRecord'] is Map<String, dynamic>
        ? effective['alumniRecord'] as Map<String, dynamic>
        : null;

    final name = profile?['name'] ??
        alumniRecord?['name'] ??
        effective['fullName'] ??
        effective['name'] ??
        '';

    final gradYear = profile?['classYear'] ??
        alumniRecord?['gradYear'] ??
        effective['graduationYear'] ??
        effective['classYear'];

    final degree = profile?['degree'] ??
        alumniRecord?['degree'] ??
        effective['degree'];

    final department = profile?['major'] ??
        alumniRecord?['faculty'] ??
        effective['department'] ??
        effective['major'];

    final memberNumber = effective['studentId'] ??
        alumniRecord?['regNo'] ??
        effective['membershipNumber'] ??
        effective['memberId'];

    final avatar = profile?['avatar'] ??
        alumniRecord?['avatarUrl'] ??
        effective['avatarUrl'] ??
        effective['avatar'];

    final company = profile?['company'] ??
        effective['currentCompany'] ??
        effective['company'];

    final role = profile?['currentRole'] ??
        effective['currentRole'] ??
        effective['role_title'] ??
        effective['designation'];

    final location = profile?['location'] ?? effective['location'];

    final isVerified = effective['isVerifiedAlumni'] == true ||
        effective['isVerified'] == true ||
        effective['verified'] == true ||
        alumniRecord?['status'] == 'APPROVED';

    final hasDigitalPass = effective['hasDigitalCard'] == true ||
        alumniRecord?['digitalPassIssued'] == true ||
        isVerified;

    return UserModel(
      id: effective['id']?.toString() ?? profile?['id']?.toString() ?? '',
      fullName: name.toString(),
      email: effective['email']?.toString() ?? alumniRecord?['email']?.toString() ?? '',
      phone: effective['phone'] ?? alumniRecord?['phone'],
      graduationYear: gradYear is int
          ? gradYear
          : int.tryParse(gradYear?.toString() ?? ''),
      degree: degree?.toString(),
      department: department?.toString(),
      membershipNumber: memberNumber?.toString(),
      avatarUrl: avatar?.toString(),
      currentCompany: company?.toString(),
      currentRole: role?.toString(),
      location: location?.toString(),
      isVerified: isVerified,
      hasDigitalCard: hasDigitalPass,
      role: effective['status']?.toString() ?? effective['membershipTier']?.toString() ?? effective['role']?.toString() ?? 'alumni',
      createdAt: effective['createdAt'] != null ? DateTime.tryParse(effective['createdAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'graduationYear': graduationYear,
      'degree': degree,
      'department': department,
      'membershipNumber': membershipNumber,
      'avatarUrl': avatarUrl,
      'currentCompany': currentCompany,
      'currentRole': currentRole,
      'location': location,
      'isVerified': isVerified,
      'hasDigitalCard': hasDigitalCard,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    int? graduationYear,
    String? degree,
    String? department,
    String? membershipNumber,
    String? avatarUrl,
    String? currentCompany,
    String? currentRole,
    String? location,
    bool? isVerified,
    bool? hasDigitalCard,
    String? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      graduationYear: graduationYear ?? this.graduationYear,
      degree: degree ?? this.degree,
      department: department ?? this.department,
      membershipNumber: membershipNumber ?? this.membershipNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      currentCompany: currentCompany ?? this.currentCompany,
      currentRole: currentRole ?? this.currentRole,
      location: location ?? this.location,
      isVerified: isVerified ?? this.isVerified,
      hasDigitalCard: hasDigitalCard ?? this.hasDigitalCard,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
