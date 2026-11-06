import '../../directory/models/alumni_model.dart';

class CouncilLeaderModel {
  final String id;
  final String name;
  final String role;
  final String classYear;
  final String avatarUrl;
  final String bio;
  final AlumniModel? originalAlumnus;

  const CouncilLeaderModel({
    required this.id,
    required this.name,
    required this.role,
    required this.classYear,
    required this.avatarUrl,
    required this.bio,
    this.originalAlumnus,
  });

  AlumniModel toAlumniModel() {
    if (originalAlumnus != null) {
      return originalAlumnus!;
    }
    // Extract year digits if present
    final match = RegExp(r'\d{4}').firstMatch(classYear);
    final year = match != null ? int.tryParse(match.group(0)!) ?? 1998 : 1998;

    return AlumniModel(
      id: id,
      name: name,
      role: role,
      faculty: 'Faculty of Public Administration and Management',
      graduationYear: year,
      location: 'Tower Hill Campus',
      badge: 'Executive Council Leader',
      isExecutiveLeader: true,
      category: 'Executive Council',
      chapter: 'Sierra Leone',
      avatarUrl: avatarUrl,
      biography: bio,
    );
  }

  factory CouncilLeaderModel.fromAlumni(AlumniModel alumnus) {
    return CouncilLeaderModel(
      id: alumnus.id,
      name: alumnus.name,
      role: alumnus.role.split('•').first.trim(),
      classYear: 'Class of ${alumnus.graduationYear}',
      avatarUrl: alumnus.avatarUrl,
      bio: alumnus.biography ??
          alumnus.quoteText ??
          'Executive Council Member representing alumni interests and professional advancement.',
      originalAlumnus: alumnus,
    );
  }

  factory CouncilLeaderModel.fromJson(Map<String, dynamic> json) {
    final avatar = (json['image'] != null && json['image'].toString().isNotEmpty)
        ? json['image'].toString()
        : (json['avatarUrl']?.toString() ?? '');
    return CouncilLeaderModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      classYear: json['classYear']?.toString() ?? '',
      avatarUrl: avatar,
      bio: json['bio']?.toString() ?? json['quote']?.toString() ?? '',
    );
  }
}
