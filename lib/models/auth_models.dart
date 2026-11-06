import '../core/network/models/user_model.dart';
export 'auth_dto.dart';

class LoginRequest {
  final String email;
  final String password;
  final bool rememberMe;
  final String? deviceToken;
  final String? platform;
  final String? deviceName;
  final String? appVersion;
  final bool subscribeToAll;

  LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe = true,
    this.deviceToken,
    this.platform,
    this.deviceName,
    this.appVersion,
    this.subscribeToAll = true,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'email': email,
      'password': password,
      'rememberMe': rememberMe,
    };
    if (deviceToken != null && deviceToken!.isNotEmpty) {
      map['deviceToken'] = deviceToken;
      map['platform'] = platform ?? 'android';
      if (deviceName != null) map['deviceName'] = deviceName;
      if (appVersion != null) map['appVersion'] = appVersion;
      map['subscribeToAll'] = subscribeToAll;
    }
    return map;
  }
}

class LoginResponse {
  final String id;
  final String email;
  final String studentId;
  final bool isVerifiedAlumni;
  final String membershipTier;
  final String status;
  final int savedJobsCount;
  final String token;
  final bool deviceRegistered;
  final bool topicSubscribed;
  final AlumniProfile? profile;
  final String? membershipValidUntil;
  final String? subscriptionBillingCycle;
  final bool? subscriptionAutoRenew;
  final String? createdAt;
  final String? updatedAt;

  LoginResponse({
    required this.id,
    required this.email,
    required this.studentId,
    required this.isVerifiedAlumni,
    required this.membershipTier,
    required this.status,
    this.savedJobsCount = 0,
    required this.token,
    this.deviceRegistered = false,
    this.topicSubscribed = false,
    this.profile,
    this.membershipValidUntil,
    this.subscriptionBillingCycle,
    this.subscriptionAutoRenew,
    this.createdAt,
    this.updatedAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // If the json wraps the payload inside "data", unwrap it
    final map = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return LoginResponse(
      id: map['id']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      studentId: map['studentId']?.toString() ??
          map['regNo']?.toString() ??
          map['membershipNumber']?.toString() ??
          '',
      isVerifiedAlumni: map['isVerifiedAlumni'] == true ||
          map['isVerified'] == true ||
          map['verified'] == true,
      membershipTier: map['membershipTier']?.toString() ?? 'STANDARD',
      status: map['status']?.toString() ?? 'PENDING',
      savedJobsCount: map['savedJobsCount'] is int
          ? map['savedJobsCount'] as int
          : int.tryParse(map['savedJobsCount']?.toString() ?? '0') ?? 0,
      token: map['token']?.toString() ?? '',
      deviceRegistered: map['deviceRegistered'] == true,
      topicSubscribed: map['topicSubscribed'] == true,
      profile: map['profile'] != null && map['profile'] is Map<String, dynamic>
          ? AlumniProfile.fromJson(map['profile'] as Map<String, dynamic>)
          : null,
      membershipValidUntil: map['membershipValidUntil']?.toString(),
      subscriptionBillingCycle: map['subscriptionBillingCycle']?.toString(),
      subscriptionAutoRenew: map['subscriptionAutoRenew'] as bool?,
      createdAt: map['createdAt']?.toString(),
      updatedAt: map['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'studentId': studentId,
      'isVerifiedAlumni': isVerifiedAlumni,
      'membershipTier': membershipTier,
      'status': status,
      'savedJobsCount': savedJobsCount,
      'token': token,
      'profile': profile?.toJson(),
      'membershipValidUntil': membershipValidUntil,
      'subscriptionBillingCycle': subscriptionBillingCycle,
      'subscriptionAutoRenew': subscriptionAutoRenew,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  UserModel toUserModel() {
    return UserModel(
      id: id,
      fullName: profile?.name.isNotEmpty == true ? profile!.name : email,
      email: email,
      phone: null,
      graduationYear: profile?.classYear,
      degree: profile?.degree,
      department: profile?.major,
      membershipNumber: studentId,
      avatarUrl: profile?.avatar,
      currentCompany: profile?.company,
      currentRole: profile?.currentRole,
      location: profile?.location,
      isVerified: isVerifiedAlumni,
      hasDigitalCard: isVerifiedAlumni,
      role: status,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
    );
  }
}

class AlumniProfile {
  final String? id;
  final String? userId;
  final String name;
  final String? avatar;
  final int classYear;
  final String degree;
  final String major;
  final String currentRole;
  final String company;
  final String location;
  final String country;
  final String industry;
  final String bio;
  final bool isMentor;
  final String? linkedin;
  final List<String> skills;

  AlumniProfile({
    this.id,
    this.userId,
    required this.name,
    this.avatar,
    required this.classYear,
    required this.degree,
    required this.major,
    required this.currentRole,
    required this.company,
    required this.location,
    this.country = 'Sierra Leone',
    this.industry = '',
    this.bio = '',
    required this.isMentor,
    this.linkedin,
    this.skills = const [],
  });

  factory AlumniProfile.fromJson(Map<String, dynamic> json) {
    List<String> parsedSkills = [];
    if (json['skills'] is List) {
      for (final s in (json['skills'] as List)) {
        if (s is String) {
          parsedSkills.add(s);
        } else if (s is Map && s['skill'] != null) {
          parsedSkills.add(s['skill'].toString());
        }
      }
    }

    return AlumniProfile(
      id: json['id']?.toString(),
      userId: json['userId']?.toString(),
      name: json['name']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? json['avatarUrl']?.toString(),
      classYear: json['classYear'] is int
          ? json['classYear'] as int
          : int.tryParse(json['classYear']?.toString() ?? '0') ?? 0,
      degree: json['degree']?.toString() ?? '',
      major: json['major']?.toString() ?? json['faculty']?.toString() ?? '',
      currentRole: json['currentRole']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      country: json['country']?.toString() ?? 'Sierra Leone',
      industry: json['industry']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      isMentor: json['isMentor'] == true,
      linkedin: json['linkedin']?.toString(),
      skills: parsedSkills,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      'name': name,
      if (avatar != null) 'avatar': avatar,
      'classYear': classYear,
      'degree': degree,
      'major': major,
      'currentRole': currentRole,
      'company': company,
      'location': location,
      'country': country,
      'industry': industry,
      'bio': bio,
      'isMentor': isMentor,
      if (linkedin != null) 'linkedin': linkedin,
      'skills': skills,
    };
  }
}

class RegisterRequest {
  final String email;
  final String studentId;
  final String password;
  final String name;
  final int classYear;
  final String degree;
  final String major;
  final String otp;
  final String? currentRole;
  final String? company;
  final String? location;
  final String? country;
  final String? industry;
  final String? bio;
  final bool isMentor;

  RegisterRequest({
    required this.email,
    required this.studentId,
    required this.password,
    required this.name,
    required this.classYear,
    required this.degree,
    required this.major,
    required this.otp,
    this.currentRole,
    this.company,
    this.location,
    this.country = 'Sierra Leone',
    this.industry,
    this.bio,
    this.isMentor = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email.trim(),
      'studentId': studentId.trim(),
      'password': password,
      'name': name.trim(),
      'classYear': classYear,
      'degree': degree.trim(),
      'major': major.trim(),
      'otp': otp.trim(),
      if (currentRole != null && currentRole!.trim().isNotEmpty) 'currentRole': currentRole!.trim(),
      if (company != null && company!.trim().isNotEmpty) 'company': company!.trim(),
      if (location != null && location!.trim().isNotEmpty) 'location': location!.trim(),
      if (country != null && country!.trim().isNotEmpty) 'country': country!.trim(),
      if (industry != null && industry!.trim().isNotEmpty) 'industry': industry!.trim(),
      if (bio != null && bio!.trim().isNotEmpty) 'bio': bio!.trim(),
      'isMentor': isMentor,
    };
  }
}

class RegisterResponse {
  final String message;
  final String status;

  RegisterResponse({
    required this.message,
    required this.status,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    final map = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return RegisterResponse(
      message: map['message']?.toString() ?? 'Registration submitted successfully.',
      status: map['status']?.toString() ?? 'PENDING',
    );
  }
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }
}

class AccountPendingApprovalException implements Exception {
  final String email;
  final String message;
  final String? studentId;
  final String? status;

  AccountPendingApprovalException({
    required this.email,
    required this.message,
    this.studentId,
    this.status = 'PENDING',
  });

  @override
  String toString() => message;
}

class UserAlreadyExistsException implements Exception {
  final String message;
  final String? email;
  final String? studentId;
  final String? field;

  UserAlreadyExistsException({
    required this.message,
    this.email,
    this.studentId,
    this.field,
  });

  @override
  String toString() => message;
}
