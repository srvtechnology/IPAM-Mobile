import 'dart:convert';

/// Digital Virtual ID Pass model representing university membership credential
class VirtualPass {
  final String id;
  final String studentId;
  final String name;
  final String? avatar;
  final String degree;
  final String major;
  final int classYear;
  final String membershipTier;
  final bool isVerifiedAlumni;
  final String qrPayload;
  final String? membershipValidUntil;
  final String? issuedAt;
  final String institution;

  VirtualPass({
    required this.id,
    required this.studentId,
    required this.name,
    this.avatar,
    required this.degree,
    required this.major,
    required this.classYear,
    required this.membershipTier,
    required this.isVerifiedAlumni,
    required this.qrPayload,
    this.membershipValidUntil,
    this.issuedAt,
    required this.institution,
  });

  factory VirtualPass.fromJson(Map<String, dynamic> json) {
    return VirtualPass(
      id: json['id']?.toString() ?? '',
      studentId: json['studentId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      avatar: json['avatar']?.toString(),
      degree: json['degree']?.toString() ?? '',
      major: json['major']?.toString() ?? '',
      classYear: json['classYear'] is int
          ? json['classYear'] as int
          : int.tryParse(json['classYear']?.toString() ?? '0') ?? 0,
      membershipTier: json['membershipTier']?.toString() ?? 'STANDARD',
      isVerifiedAlumni: json['isVerifiedAlumni'] == true,
      qrPayload: json['qrPayload']?.toString() ?? '',
      membershipValidUntil: json['membershipValidUntil']?.toString(),
      issuedAt: json['issuedAt']?.toString(),
      institution: json['institution']?.toString() ??
          'Institute of Public Administration and Management (IPAM)',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'name': name,
      if (avatar != null) 'avatar': avatar,
      'degree': degree,
      'major': major,
      'classYear': classYear,
      'membershipTier': membershipTier,
      'isVerifiedAlumni': isVerifiedAlumni,
      'qrPayload': qrPayload,
      if (membershipValidUntil != null) 'membershipValidUntil': membershipValidUntil,
      if (issuedAt != null) 'issuedAt': issuedAt,
      'institution': institution,
    };
  }

  /// Default demo pass when offline or waiting for backend response
  factory VirtualPass.fallback({
    String? id,
    String? name,
    String? studentId,
    String? degree,
    int? classYear,
    String? membershipTier,
  }) {
    final finalId = (id != null && id.isNotEmpty) ? id : 'cmuznxfl90007o63lnxqupalc';
    final finalName = name ?? 'Mohamed S. Bangura';
    final finalStudentId = studentId ?? 'IPAM-2019-0142';
    final finalYear = classYear ?? 2022;
    final finalDegree = degree ?? 'B.Sc. Applied Accounting';
    final finalTier = membershipTier ?? 'PLATINUM';

    final payloadMap = {
      'schema': 'IPAM_PASS_V1',
      'id': finalId,
      'studentId': finalStudentId,
      'name': finalName,
      'tier': finalTier,
      'issuedAt': '2026-10-15T08:00:00.000Z',
    };

    return VirtualPass(
      id: finalId,
      studentId: finalStudentId,
      name: finalName,
      avatar: null,
      degree: finalDegree,
      major: 'Financial Accounting',
      classYear: finalYear,
      membershipTier: finalTier,
      isVerifiedAlumni: true,
      membershipValidUntil: '2027-10-15T00:00:00.000Z',
      issuedAt: '2026-10-15T08:00:00.000Z',
      institution: 'Institute of Public Administration and Management (IPAM)',
      qrPayload: jsonEncode(payloadMap),
    );
  }
}

/// Verification result returned by the public pass verification endpoint
class VerificationResult {
  final bool valid;
  final String status;
  final String message;
  final String verifiedAt;
  final Map<String, dynamic>? user;

  VerificationResult({
    required this.valid,
    required this.status,
    required this.message,
    required this.verifiedAt,
    this.user,
  });

  factory VerificationResult.fromJson(Map<String, dynamic> json) {
    return VerificationResult(
      valid: json['valid'] == true,
      status: json['status']?.toString() ?? 'UNKNOWN',
      message: json['message']?.toString() ?? '',
      verifiedAt: json['verifiedAt']?.toString() ?? '',
      user: json['user'] is Map<String, dynamic>
          ? json['user'] as Map<String, dynamic>
          : (json['user'] is Map ? Map<String, dynamic>.from(json['user']) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'valid': valid,
      'status': status,
      'message': message,
      'verifiedAt': verifiedAt,
      if (user != null) 'user': user,
    };
  }

  String get displayName => user?['name']?.toString() ?? 'Alumnus';
  String get studentRegistrationId => user?['studentId']?.toString() ?? '';
  String get tier => user?['membershipTier']?.toString() ?? 'STANDARD';
  String get degree => user?['degree']?.toString() ?? '';
  int get graduationYear => user?['classYear'] is int
      ? user!['classYear'] as int
      : int.tryParse(user?['classYear']?.toString() ?? '0') ?? 0;
  bool get isVerified => user?['isVerifiedAlumni'] == true;
}
