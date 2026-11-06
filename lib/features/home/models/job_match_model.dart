import 'package:flutter/material.dart';
import '../../careers/models/career_job_model.dart';

class JobMatchModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String employmentType;
  final Color accentColor;
  final CareerJobModel? originalJob;
  final String salary;
  final String description;
  final List<String> requirements;

  const JobMatchModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    this.employmentType = 'Full Time',
    required this.accentColor,
    this.originalJob,
    this.salary = '',
    this.description = '',
    this.requirements = const [],
  });

  factory JobMatchModel.fromCareerJob(CareerJobModel job, {Color? accentColor}) {
    Color color = accentColor ?? const Color(0xFF059669);
    final compLower = job.company.toLowerCase();
    if (compLower.contains('orange')) {
      color = const Color(0xFF059669);
    } else if (compLower.contains('ministry') ||
        compLower.contains('finance') ||
        compLower.contains('policy')) {
      color = const Color(0xFFD97706);
    } else if (compLower.contains('bank') || compLower.contains('standard')) {
      color = const Color(0xFF2563EB);
    }

    return JobMatchModel(
      id: job.id,
      title: job.title,
      company: job.company,
      location: job.location,
      employmentType: job.employmentType,
      accentColor: color,
      originalJob: job,
      salary: job.salary,
      description: job.description,
      requirements: job.requirements,
    );
  }

  factory JobMatchModel.fromJson(Map<String, dynamic> json) {
    return JobMatchModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      location: json['location'] ?? '',
      employmentType: json['employmentType'] ?? 'Full Time',
      accentColor: json['accentColor'] != null
          ? Color(int.parse(json['accentColor'].toString()))
          : const Color(0xFF059669),
      salary: json['salary']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  CareerJobModel toCareerJob() {
    if (originalJob != null) {
      return originalJob!;
    }
    return CareerJobModel(
      id: id,
      title: title,
      company: company,
      location: location,
      employmentType: employmentType,
      salary: salary.isNotEmpty ? salary : 'Competitive, negotiable',
      alumniCount: 4,
      deadline: 'Open Requisition',
      category: 'General',
      isVerified: true,
      logoType: company.length >= 4 ? company.substring(0, 4).toLowerCase() : 'ipam',
      logoText: company.length >= 4 ? company.substring(0, 4).toUpperCase() : company.toUpperCase(),
      description: description,
      requirements: requirements,
    );
  }
}
