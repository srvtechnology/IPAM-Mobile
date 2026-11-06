import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/core/network/api_client.dart';
import 'package:ipam_mobile/models/job_models.dart';
import 'package:ipam_mobile/services/job_service.dart';

class _MockJobApiClient extends ApiClient {
  _MockJobApiClient();

  @override
  Future<Response<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) async {
    if (url == '/api/jobs') {
      return Response<T>(
        statusCode: 200,
        body: {
          'data': [
            {
              'id': 'seed-job-1',
              'title': 'Senior Backend Engineer (Node/Go)',
              'slug': 'senior-backend-engineer',
              'company': 'Orange Sierra Leone',
              'companyLogo': 'https://ipam.billnbite.cloud/uploads/logos/orange.png',
              'location': 'Freetown (Hill Station)',
              'type': 'FULL_TIME',
              'workplaceType': 'HYBRID',
              'category': 'TECHNOLOGY',
              'salary': 'SLE 18,000 - 25,000 / month',
              'description': 'Senior Backend Engineer for telecom microservices.',
              'deadline': '2026-11-30T23:59:59.000Z',
              'alumniCount': 14,
              'isVerified': true,
              'status': 'ACTIVE',
              'applicantsCount': 8,
              'requirements': [
                '5+ years production experience with Node.js or Go',
                'Strong background in relational databases'
              ],
              'responsibilities': [
                'Architect scalable microservices',
                'Mentor junior engineering alumni'
              ],
              'isSaved': true,
              'hasApplied': false,
            },
            {
              'id': 'seed-job-2',
              'title': 'Compliance & AML Analyst',
              'company': 'Rokel Commercial Bank',
              'location': 'Freetown (Siaka Stevens St)',
              'type': 'FULL_TIME',
              'workplaceType': 'ON_SITE',
              'category': 'FINANCE_BANKING',
              'salary': 'SLE 12,000 - 16,000 / month',
              'description': 'AML risk analyst.',
              'deadline': '2026-12-15T23:59:59.000Z',
              'alumniCount': 38,
              'isVerified': true,
              'status': 'ACTIVE',
              'applicantsCount': 12,
              'isSaved': false,
              'hasApplied': true,
            }
          ]
        } as T,
      );
    }

    if (url == '/api/jobs/seed-job-1') {
      return Response<T>(
        statusCode: 200,
        body: {
          'data': {
            'id': 'seed-job-1',
            'title': 'Senior Backend Engineer (Node/Go)',
            'company': 'Orange Sierra Leone',
            'location': 'Freetown (Hill Station)',
            'type': 'FULL_TIME',
            'workplaceType': 'HYBRID',
            'salary': 'SLE 18,000 - 25,000 / month',
            'category': 'TECHNOLOGY',
            'description': 'Senior Backend Engineer for telecom microservices.',
            'requirements': ['5+ years Node.js or Go'],
            'responsibilities': ['Architect microservices'],
            'isSaved': true,
            'hasApplied': false,
          }
        } as T,
      );
    }

    if (url == '/api/jobs/saved') {
      return Response<T>(
        statusCode: 200,
        body: {
          'data': [
            {
              'id': 'seed-job-1',
              'title': 'Senior Backend Engineer (Node/Go)',
              'company': 'Orange Sierra Leone',
              'location': 'Freetown (Hill Station)',
              'type': 'FULL_TIME',
              'workplaceType': 'HYBRID',
              'salary': 'SLE 18,000 - 25,000 / month',
              'category': 'TECHNOLOGY',
              'description': 'Senior Backend Engineer for telecom microservices.',
              'isSaved': true,
            }
          ]
        } as T,
      );
    }

    if (url == '/api/jobs/my-applications') {
      return Response<T>(
        statusCode: 200,
        body: {
          'data': {
            'applications': [
              {
                'id': 'app-101',
                'jobId': 'seed-job-1',
                'applicationRef': 'IPAM-REF-2026-0042',
                'status': 'REVIEWING',
                'stage': 'In Review',
                'matchScore': 95,
                'appliedAt': '2026-10-20T10:00:00.000Z',
                'recruiterRemarks': 'Profile verified with registrar. Interview scheduled.',
                'interviewDate': '2026-11-05T14:00:00.000Z',
                'job': {
                  'id': 'seed-job-1',
                  'title': 'Senior Backend Engineer (Node/Go)',
                  'company': 'Orange Sierra Leone',
                  'location': 'Freetown (Hill Station)',
                  'type': 'FULL_TIME',
                  'workplaceType': 'HYBRID',
                  'salary': 'SLE 18,000 - 25,000 / month',
                  'category': 'TECHNOLOGY',
                  'description': 'Senior Backend Engineer for telecom microservices.',
                }
              }
            ]
          }
        } as T,
      );
    }

    return Response<T>(statusCode: 404, statusText: 'Not found');
  }

  @override
  Future<Response<T>> post<T>(
    String? url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    Progress? uploadProgress,
  }) async {
    if (url == '/api/jobs/seed-job-1/apply') {
      return Response<T>(
        statusCode: 201,
        body: {
          'data': {
            'applicationRef': 'IPAM-REF-2026-0089',
            'matchScore': 92,
            'status': 'APPLIED',
          }
        } as T,
      );
    }

    if (url == '/api/jobs/seed-job-1/save') {
      return Response<T>(
        statusCode: 200,
        body: {
          'data': {
            'saved': true,
          }
        } as T,
      );
    }

    if (url == '/api/jobs') {
      final map = body as Map<String, dynamic>;
      return Response<T>(
        statusCode: 201,
        body: {
          'data': {
            'id': 'new-job-created-99',
            'title': map['title'],
            'company': map['company'],
            'location': map['location'],
            'type': map['type'] ?? 'FULL_TIME',
            'workplaceType': map['workplaceType'] ?? 'HYBRID',
            'category': map['category'],
            'salary': map['salary'],
            'description': map['description'] ?? '',
            'status': 'ACTIVE',
            'createdAt': DateTime.now().toIso8601String(),
          }
        } as T,
      );
    }

    return Response<T>(statusCode: 400);
  }

  @override
  Future<Response<T>> patch<T>(
    String url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    Progress? uploadProgress,
  }) async {
    if (url == '/api/jobs/seed-job-1') {
      return Response<T>(
        statusCode: 200,
        body: {
          'data': {
            'id': 'seed-job-1',
            'status': (body as Map<String, dynamic>)['status'],
          }
        } as T,
      );
    }
    return Response<T>(statusCode: 400);
  }

  @override
  Future<Response<T>> delete<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) async {
    if (url == '/api/jobs/seed-job-1') {
      return Response<T>(
        statusCode: 200,
        body: {
          'data': {'deleted': true}
        } as T,
      );
    }
    return Response<T>(statusCode: 404);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockJobApiClient mockClient;
  late JobService service;

  setUp(() {
    mockClient = _MockJobApiClient();
    service = JobService(client: mockClient);
  });

  group('JobService API Integration Tests', () {
    test('fetchJobs returns parsed job openings list', () async {
      final jobs = await service.fetchJobs();
      expect(jobs.length, equals(2));
      expect(jobs[0].title, equals('Senior Backend Engineer (Node/Go)'));
      expect(jobs[0].company, equals('Orange Sierra Leone'));
      expect(jobs[0].category, equals('TECHNOLOGY'));
      expect(jobs[0].saved, isTrue);
      expect(jobs[0].requirements.length, equals(2));
      expect(jobs[1].applied, isTrue);
    });

    test('getJobDetails retrieves single job details', () async {
      final job = await service.getJobDetails('seed-job-1');
      expect(job.title, equals('Senior Backend Engineer (Node/Go)'));
      expect(job.requirements.first, equals('5+ years Node.js or Go'));
    });

    test('applyForJob returns application ref and match score', () async {
      final response = await service.applyForJob(
        'seed-job-1',
        candidateName: 'Mohamed S. Bangura',
        email: 'mohamed@ipam.edu',
      );
      expect(response, isNotNull);
      expect(response!.applicationRef, equals('IPAM-REF-2026-0089'));
      expect(response.matchScore, equals(92));
      expect(response.status, equals('APPLIED'));
    });

    test('toggleSaveJob returns updated save status', () async {
      final saved = await service.toggleSaveJob('seed-job-1');
      expect(saved, isTrue);
    });

    test('fetchSavedJobs returns saved job list', () async {
      final saved = await service.fetchSavedJobs();
      expect(saved.length, equals(1));
      expect(saved[0].title, equals('Senior Backend Engineer (Node/Go)'));
    });

    test('fetchMyApplications returns submitted application items', () async {
      final apps = await service.fetchMyApplications();
      expect(apps.length, equals(1));
      expect(apps[0].applicationRef, equals('IPAM-REF-2026-0042'));
      expect(apps[0].matchScore, equals(95));
      expect(apps[0].recruiterRemarks, contains('Profile verified'));
    });

    test('postJobVacancy successfully creates vacancy', () async {
      final newJob = await service.postJobVacancy(
        title: 'Lead Data Architect',
        company: 'Salone FinTech Hub',
        location: 'Freetown',
        salary: 'SLE 30,000 / month',
        category: 'TECHNOLOGY',
        description: 'Lead enterprise data lake and analytics for banking.',
      );
      expect(newJob, isNotNull);
      expect(newJob!.id, equals('new-job-created-99'));
      expect(newJob.title, equals('Lead Data Architect'));
    });

    test('updateJobStatus successfully modifies status', () async {
      final success = await service.updateJobStatus('seed-job-1', 'CLOSED');
      expect(success, isTrue);
    });

    test('deleteJob successfully deletes vacancy', () async {
      final success = await service.deleteJob('seed-job-1');
      expect(success, isTrue);
    });
  });

  group('Job Models and UI Mapping Tests', () {
    test('toCareerJobModel converts JobOpening to UI model correctly', () {
      final opening = JobOpening(
        id: 'job-xyz',
        title: 'Chief Compliance Officer',
        company: 'Bank of Sierra Leone',
        location: 'Freetown',
        category: 'FINANCE_BANKING',
        type: 'FULL_TIME',
        workplaceType: 'ON_SITE',
        salary: 'SLL 35,000,000 - 45,000,000',
        description: 'Responsible for oversight and regulatory compliance.',
        deadline: '2026-12-01T00:00:00.000Z',
        saved: true,
        applied: true,
      );

      final model = opening.toCareerJobModel();
      expect(model.id, equals('job-xyz'));
      expect(model.title, equals('Chief Compliance Officer'));
      expect(model.company, equals('Bank of Sierra Leone'));
      expect(model.category, equals('Finance & Banking'));
      expect(model.salary, contains('35,000,000'));
      expect(model.isBookmarked, isTrue);
      expect(model.isApplied, isTrue);
      expect(model.logoText, equals('BANK'));
    });

    test('toCareerPostingModel converts JobOpening to CareerPostingModel', () {
      final opening = JobOpening(
        id: 'job-post-1',
        title: 'Internal Audit Associate',
        company: 'KPMG Sierra Leone',
        location: 'Freetown',
        type: 'FULL_TIME',
        workplaceType: 'HYBRID',
        salary: 'SLE 15,000 / month',
        description: 'Audit associate role.',
        category: 'PUBLIC_ADMIN',
        status: 'ACTIVE',
        applicantsCount: 4,
      );

      final posting = opening.toCareerPostingModel();
      expect(posting.id, equals('job-post-1'));
      expect(posting.title, equals('Internal Audit Associate'));
      expect(posting.company, equals('KPMG Sierra Leone'));
      expect(posting.status, equals('Active'));
      expect(posting.applicantsCount, equals(4));
    });

    test('toCareerApplicationModel converts JobApplicationItem to CareerApplicationModel', () {
      final app = JobApplicationItem(
        id: 'app-99',
        jobId: 'job-1',
        applicationRef: 'IPAM-REF-2026-99',
        status: 'INTERVIEWING',
        matchScore: 94,
        interviewDate: DateTime.parse('2026-11-10T10:00:00.000Z'),
        recruiterRemarks: 'Technical round scheduled.',
        job: JobOpening(
          id: 'job-1',
          title: 'Senior Product Manager',
          company: 'Africell Sierra Leone',
          category: 'TECHNOLOGY',
          location: 'Wilberforce',
          type: 'FULL_TIME',
          workplaceType: 'HYBRID',
          salary: 'Competitive',
          description: 'Product leadership.',
        ),
      );

      final uiApp = app.toCareerApplicationModel();
      expect(uiApp.id, equals('app-99'));
      expect(uiApp.title, equals('Senior Product Manager'));
      expect(uiApp.company, equals('Africell Sierra Leone'));
      expect(uiApp.status, equals('Interviewing'));
      expect(uiApp.currentStage, equals(3));
      expect(uiApp.notes.first, contains('Technical round'));
    });

    test('toCareerApplicationModel dynamically maps APPLIED status to Stage 1 of 5', () {
      final app = JobApplicationItem(
        id: 'app-applied-1',
        jobId: 'job-1',
        applicationRef: 'IPAM-REF-298099',
        status: 'APPLIED',
        matchScore: 90,
        candidateName: 'Mohamed S. Bangura',
        degree: 'B.Sc. Banking & Finance',
        faculty: 'Management Sciences',
        gradYear: 2016,
        experienceYears: 8,
        coverNote: 'Passionate alumnus applying for backend role.',
        cvFileName: 'Mohamed_Bangura_CV.pdf',
        notes: 'Initial application submitted and sealed.',
        job: JobOpening(
          id: 'job-1',
          title: 'Senior Backend Engineer',
          company: 'Orange Sierra Leone',
          category: 'ENGINEERING',
          location: 'Freetown, Sierra Leone',
          type: 'FULL_TIME',
          workplaceType: 'HYBRID',
          salary: 'Competitive, negotiable',
          description: 'Backend role.',
        ),
      );

      final uiApp = app.toCareerApplicationModel();
      expect(uiApp.currentStage, equals(1));
      expect(uiApp.totalStages, equals(5));
      expect(uiApp.stageName, equals('Stage 1: Application Received'));
      expect(uiApp.status, equals('Application Received'));
      expect(uiApp.applicationRef, equals('IPAM-REF-298099'));
      expect(uiApp.candidateName, equals('Mohamed S. Bangura'));
      expect(uiApp.degree, equals('B.Sc. Banking & Finance'));
      expect(uiApp.notes.first, contains('Initial application submitted'));
      expect(uiApp.matchScore, equals(90));
    });

    test('toCareerApplicationModel dynamically maps REVIEWING status to Stage 2 of 5', () {
      final app = JobApplicationItem(
        id: 'app-reviewing-1',
        jobId: 'job-1',
        applicationRef: 'IPAM-REF-300123',
        status: 'REVIEWING',
        matchScore: 88,
        recruiterRemarks: 'Academic transcript authenticated.',
        job: JobOpening(
          id: 'job-1',
          title: 'Financial Analyst',
          company: 'Apex Bank',
          category: 'FINANCE_BANKING',
          location: 'Freetown',
          type: 'FULL_TIME',
          workplaceType: 'ON_SITE',
          salary: 'Competitive',
          description: 'Finance role.',
        ),
      );

      final uiApp = app.toCareerApplicationModel();
      expect(uiApp.currentStage, equals(2));
      expect(uiApp.totalStages, equals(5));
      expect(uiApp.stageName, equals('Stage 2: Technical Review'));
      expect(uiApp.status, equals('Under Review'));
      expect(uiApp.notes.first, contains('Academic transcript authenticated'));
    });
  });
}
