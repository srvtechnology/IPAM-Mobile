import 'package:flutter/material.dart';

class PostingApplicant {
  final String name;
  final String graduationClass;
  final String degree;
  final String status;
  final String avatarUrl;

  const PostingApplicant({
    required this.name,
    required this.graduationClass,
    required this.degree,
    this.status = 'Applied',
    required this.avatarUrl,
  });
}

class CareerPostingModel {
  final String id;
  final String title;
  final String company;
  final String category;
  final String postedDate;
  final String status; // 'Active', 'Paused', 'Filled'
  final String location;
  final String salary;
  final String deadline;
  final String priorityBadge;
  final int applicantsCount;
  final bool hasNewApplicants;
  final String logoText;
  final Color logoBgColor;
  final Color logoTextColor;
  final List<PostingApplicant> applicants;

  const CareerPostingModel({
    required this.id,
    required this.title,
    required this.company,
    required this.category,
    required this.postedDate,
    this.status = 'Active',
    required this.location,
    required this.salary,
    required this.deadline,
    this.priorityBadge = 'Priority Alumni Tier',
    required this.applicantsCount,
    this.hasNewApplicants = false,
    required this.logoText,
    this.logoBgColor = const Color(0xFF042F2C),
    this.logoTextColor = const Color(0xFFF59E0B),
    this.applicants = const [],
  });

  bool get isActive => status == 'Active';
  bool get isPaused => status == 'Paused';
  bool get isFilled => status == 'Filled';

  CareerPostingModel copyWith({
    String? id,
    String? title,
    String? company,
    String? category,
    String? postedDate,
    String? status,
    String? location,
    String? salary,
    String? deadline,
    String? priorityBadge,
    int? applicantsCount,
    bool? hasNewApplicants,
    String? logoText,
    Color? logoBgColor,
    Color? logoTextColor,
    List<PostingApplicant>? applicants,
  }) {
    return CareerPostingModel(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      category: category ?? this.category,
      postedDate: postedDate ?? this.postedDate,
      status: status ?? this.status,
      location: location ?? this.location,
      salary: salary ?? this.salary,
      deadline: deadline ?? this.deadline,
      priorityBadge: priorityBadge ?? this.priorityBadge,
      applicantsCount: applicantsCount ?? this.applicantsCount,
      hasNewApplicants: hasNewApplicants ?? this.hasNewApplicants,
      logoText: logoText ?? this.logoText,
      logoBgColor: logoBgColor ?? this.logoBgColor,
      logoTextColor: logoTextColor ?? this.logoTextColor,
      applicants: applicants ?? this.applicants,
    );
  }
}
