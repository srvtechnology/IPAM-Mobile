import 'package:flutter/material.dart';

class ApplicationChecklistItem {
  final String text;
  final bool isCompleted;
  final bool isPending;

  const ApplicationChecklistItem({
    required this.text,
    this.isCompleted = false,
    this.isPending = false,
  });
}

class CareerApplicationModel {
  final String id;
  final String applicationRef;
  final String company;
  final String title;
  final String category;
  final String location;
  final String status; // 'Application Received', 'Under Review', 'Interviewing', 'Offer Extended', 'Placed / Hired', 'Archived'
  final String rawStatus;
  final String appliedDate;
  final bool hasRegistrarTranscript;
  final int currentStage;
  final int totalStages;
  final String stageName;
  final List<String> notes;
  final List<ApplicationChecklistItem> checklist;
  final String? recruiterContact;
  final String? candidateName;
  final String? candidateEmail;
  final String? candidatePhone;
  final String? degree;
  final String? faculty;
  final int? gradYear;
  final int? experienceYears;
  final int matchScore;
  final String? coverNote;
  final String? cvUrl;
  final String? cvFileName;
  final DateTime? interviewDate;
  final String? offerSalary;
  final DateTime? startDate;
  final String? decisionStatus;
  final String? recruiterRemarks;

  const CareerApplicationModel({
    required this.id,
    this.applicationRef = 'IPAM-REF-000000',
    required this.company,
    required this.title,
    required this.category,
    required this.location,
    required this.status,
    this.rawStatus = 'APPLIED',
    required this.appliedDate,
    this.hasRegistrarTranscript = true,
    this.currentStage = 1,
    this.totalStages = 5,
    required this.stageName,
    this.notes = const [],
    this.checklist = const [],
    this.recruiterContact,
    this.candidateName,
    this.candidateEmail,
    this.candidatePhone,
    this.degree,
    this.faculty,
    this.gradYear,
    this.experienceYears,
    this.matchScore = 85,
    this.coverNote,
    this.cvUrl,
    this.cvFileName,
    this.interviewDate,
    this.offerSalary,
    this.startDate,
    this.decisionStatus,
    this.recruiterRemarks,
  });

  bool get isInterviewing =>
      status == 'Interviewing' || status == 'Offer Extended' || rawStatus.toUpperCase().contains('INTERVIEW');
  bool get isArchived =>
      status == 'Archived' || rawStatus.toUpperCase().contains('REJECT') || rawStatus.toUpperCase().contains('CLOSED');
  bool get isActive => !isArchived;

  Color getStatusBgColor(BuildContext context, bool isDark) {
    switch (status) {
      case 'Under Review':
        return isDark ? const Color(0xFF451A03) : const Color(0xFFFEF3C7);
      case 'Interviewing':
      case 'Offer Extended':
        return isDark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA);
      case 'Placed / Hired':
        return isDark ? const Color(0xFF064E3B) : const Color(0xFFD1FAE5);
      case 'Application Received':
      default:
        return isDark ? const Color(0xFF0C4A6E).withValues(alpha: 0.5) : const Color(0xFFE0F2FE);
    }
  }

  Color getStatusTextColor(BuildContext context, bool isDark) {
    switch (status) {
      case 'Under Review':
        return isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309);
      case 'Interviewing':
      case 'Offer Extended':
        return isDark ? const Color(0xFF34D399) : const Color(0xFF044E3D);
      case 'Placed / Hired':
        return isDark ? const Color(0xFF10B981) : const Color(0xFF065F46);
      case 'Application Received':
      default:
        return isDark ? const Color(0xFF38BDF8) : const Color(0xFF0369A1);
    }
  }

  Color getStatusBorderColor(BuildContext context, bool isDark) {
    switch (status) {
      case 'Under Review':
        return isDark ? const Color(0xFF78350F) : const Color(0xFFFDE68A);
      case 'Interviewing':
      case 'Offer Extended':
        return isDark ? const Color(0xFF065F46) : const Color(0xFFA7F3D0);
      case 'Placed / Hired':
        return isDark ? const Color(0xFF047857) : const Color(0xFF6EE7B7);
      case 'Application Received':
      default:
        return isDark ? const Color(0xFF0284C7) : const Color(0xFFBAE6FD);
    }
  }
}
