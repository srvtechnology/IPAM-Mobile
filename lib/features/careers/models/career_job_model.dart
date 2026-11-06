import 'package:flutter/material.dart';

class CareerJobModel {
  final String id;
  final String title;
  final String company;
  final String? companyBadge;
  final String location;
  final String employmentType;
  final String preferenceBadge;
  final String salary;
  final int alumniCount;
  final String deadline;
  final String category;
  final bool isVerified;
  final bool isApplied;
  final bool isBookmarked;
  final bool isMyPosting;
  final String logoType; // 'orange', 'ministry', 'sdp', 'slcb', 'nra', 'standard_chartered'
  final String logoText;
  final Color logoBgColor;
  final Color logoTextColor;
  final String description;
  final List<String> requirements;
  final List<String> responsibilities;
  final List<String> benefits;
  final String? leadAlumniName;
  final String? leadAlumniRole;
  final String? statDailyTxns;
  final String? statUptime;
  final String? statSecurity;
  final String? companyLogo;

  const CareerJobModel({
    required this.id,
    required this.title,
    required this.company,
    this.companyBadge,
    required this.location,
    this.employmentType = 'Full Time',
    this.preferenceBadge = 'USL Alumni Preferred',
    required this.salary,
    required this.alumniCount,
    required this.deadline,
    required this.category,
    this.isVerified = true,
    this.isApplied = false,
    this.isBookmarked = false,
    this.isMyPosting = false,
    required this.logoType,
    this.logoText = '',
    this.logoBgColor = const Color(0xFF0F172A),
    this.logoTextColor = Colors.white,
    this.description = '',
    this.requirements = const [],
    this.responsibilities = const [],
    this.benefits = const [],
    this.leadAlumniName,
    this.leadAlumniRole,
    this.statDailyTxns,
    this.statUptime,
    this.statSecurity,
    this.companyLogo,
  });

  CareerJobModel copyWith({
    String? id,
    String? title,
    String? company,
    String? companyBadge,
    String? location,
    String? employmentType,
    String? preferenceBadge,
    String? salary,
    int? alumniCount,
    String? deadline,
    String? category,
    bool? isVerified,
    bool? isApplied,
    bool? isBookmarked,
    bool? isMyPosting,
    String? logoType,
    String? logoText,
    Color? logoBgColor,
    Color? logoTextColor,
    String? description,
    List<String>? requirements,
    List<String>? responsibilities,
    List<String>? benefits,
    String? leadAlumniName,
    String? leadAlumniRole,
    String? statDailyTxns,
    String? statUptime,
    String? statSecurity,
    String? companyLogo,
  }) {
    return CareerJobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      companyBadge: companyBadge ?? this.companyBadge,
      location: location ?? this.location,
      employmentType: employmentType ?? this.employmentType,
      preferenceBadge: preferenceBadge ?? this.preferenceBadge,
      salary: salary ?? this.salary,
      alumniCount: alumniCount ?? this.alumniCount,
      deadline: deadline ?? this.deadline,
      category: category ?? this.category,
      isVerified: isVerified ?? this.isVerified,
      isApplied: isApplied ?? this.isApplied,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isMyPosting: isMyPosting ?? this.isMyPosting,
      logoType: logoType ?? this.logoType,
      logoText: logoText ?? this.logoText,
      logoBgColor: logoBgColor ?? this.logoBgColor,
      logoTextColor: logoTextColor ?? this.logoTextColor,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      responsibilities: responsibilities ?? this.responsibilities,
      benefits: benefits ?? this.benefits,
      leadAlumniName: leadAlumniName ?? this.leadAlumniName,
      leadAlumniRole: leadAlumniRole ?? this.leadAlumniRole,
      statDailyTxns: statDailyTxns ?? this.statDailyTxns,
      statUptime: statUptime ?? this.statUptime,
      statSecurity: statSecurity ?? this.statSecurity,
      companyLogo: companyLogo ?? this.companyLogo,
    );
  }
}
