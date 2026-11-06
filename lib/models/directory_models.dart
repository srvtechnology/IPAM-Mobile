import '../core/network/api_client.dart';

/// Represents an Alumni Member in the Directory & Networking module.
/// Corresponds to GET /api/alumni, GET /api/alumni/{id}, and GET /api/alumni/bookmarks
class AlumniDirectoryMember {
  final String id;
  final String name;
  final String? avatar;
  final int classYear;
  final String degree;
  final String? major;
  final String currentRole;
  final String company;
  final String location;
  final String country;
  final String industry;
  final bool isMentor;
  final List<String> skills;
  final String? bio;
  final String? email;
  final String? linkedin;
  final bool isVerifiedAlumni;
  final String? membershipTier;

  AlumniDirectoryMember({
    required this.id,
    required this.name,
    this.avatar,
    required this.classYear,
    required this.degree,
    this.major,
    required this.currentRole,
    required this.company,
    required this.location,
    this.country = 'Sierra Leone',
    required this.industry,
    required this.isMentor,
    required this.skills,
    this.bio,
    this.email,
    this.linkedin,
    this.isVerifiedAlumni = true,
    this.membershipTier,
  });

  String get avatarUrl {
    if (avatar == null || avatar!.isEmpty) return '';
    return ApiClient.formatUrl(avatar!);
  }

  String get displayRole {
    if (currentRole.isNotEmpty && company.isNotEmpty) {
      return '$currentRole • $company';
    }
    if (currentRole.isNotEmpty) return currentRole;
    if (company.isNotEmpty) return company;
    return 'Verified Alumnus';
  }

  factory AlumniDirectoryMember.fromJson(Map<String, dynamic> json) {
    final rawAvatar = json['avatar'] ?? json['avatarUrl'];
    return AlumniDirectoryMember(
      id: json['id']?.toString() ?? json['alumniId']?.toString() ?? '',
      name: json['name'] ?? json['fullName'] ?? '',
      avatar: rawAvatar?.toString(),
      classYear: json['classYear'] is int
          ? json['classYear']
          : int.tryParse(json['classYear']?.toString() ?? json['gradYear']?.toString() ?? '') ?? 2020,
      degree: json['degree'] ?? '',
      major: json['major'],
      currentRole: json['currentRole'] ?? json['role'] ?? json['title'] ?? '',
      company: json['company'] ?? '',
      location: json['location'] ?? json['campus'] ?? 'Freetown',
      country: json['country'] ?? 'Sierra Leone',
      industry: json['industry'] ?? json['category'] ?? 'General',
      isMentor: json['isMentor'] == true,
      skills: (json['skills'] as List? ?? []).map((e) => e.toString()).toList(),
      bio: json['bio'] ?? json['biography'],
      email: json['email'],
      linkedin: json['linkedin'],
      isVerifiedAlumni: json['isVerifiedAlumni'] ?? json['isVerified'] ?? true,
      membershipTier: json['membershipTier'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'classYear': classYear,
      'degree': degree,
      'major': major,
      'currentRole': currentRole,
      'company': company,
      'location': location,
      'country': country,
      'industry': industry,
      'isMentor': isMentor,
      'skills': skills,
      'bio': bio,
      'email': email,
      'linkedin': linkedin,
      'isVerifiedAlumni': isVerifiedAlumni,
      'membershipTier': membershipTier,
    };
  }
}

/// Represents an administrative announcement or university-wide broadcast.
/// Corresponds to GET /api/alumni/notifications
class BroadcastNotification {
  final String id;
  final String title;
  final String message;
  final String category;
  final DateTime createdAt;
  final String? actionUrl;

  BroadcastNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.createdAt,
    this.actionUrl,
  });

  factory BroadcastNotification.fromJson(Map<String, dynamic> json) {
    return BroadcastNotification(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      category: json['category'] ?? 'INFO',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      actionUrl: json['actionUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'actionUrl': actionUrl,
    };
  }
}

/// Response returned when connecting or disconnecting from an alumni member.
class ConnectResponse {
  final bool connected;
  final String? targetId;
  final String? message;

  ConnectResponse({
    required this.connected,
    this.targetId,
    this.message,
  });

  factory ConnectResponse.fromJson(Map<String, dynamic> json) {
    return ConnectResponse(
      connected: json['connected'] == true,
      targetId: json['targetId']?.toString(),
      message: json['message']?.toString(),
    );
  }
}
