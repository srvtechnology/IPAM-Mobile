import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ipam_mobile/core/network/api_client.dart';
import 'package:ipam_mobile/core/network/auth_storage_service.dart';
import 'package:ipam_mobile/core/network/models/user_model.dart';
import 'package:ipam_mobile/models/auth_models.dart';
import 'package:ipam_mobile/services/auth_service.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  group('Auth Data Models Tests', () {
    test('LoginResponse correctly parses real server JSON payload', () {
      final json = {
        'data': {
          'id': 'cmv163kf90007l42gvm5h5uom',
          'email': 'demo.alumni@ipam.edu',
          'studentId': 'IPAM-2015-0042',
          'isVerifiedAlumni': true,
          'status': 'APPROVED',
          'rejectionReason': null,
          'membershipTier': 'SILVER_LIFETIME',
          'membershipValidUntil': '2027-12-31T00:00:00.000Z',
          'subscriptionBillingCycle': 'ANNUAL',
          'subscriptionAutoRenew': true,
          'token': 'mock_jwt_token_123',
          'savedJobsCount': 5,
          'profile': {
            'id': 'cmv163kf90008l42gqg9mnv0s',
            'userId': 'cmv163kf90007l42gvm5h5uom',
            'name': 'Alex Sesay',
            'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
            'classYear': 2015,
            'degree': 'BSc Public Administration',
            'major': 'Public Policy',
            'currentRole': 'Program Manager',
            'company': 'UNDP Sierra Leone',
            'location': 'Freetown',
            'country': 'Sierra Leone',
            'industry': 'Development',
            'isMentor': true,
            'bio': 'Passionate about public sector reform.',
            'skills': [
              {'id': 1, 'skill': 'Policy Analysis'},
              {'id': 2, 'skill': 'Project Management'}
            ]
          }
        }
      };

      final response = LoginResponse.fromJson(json);

      expect(response.id, 'cmv163kf90007l42gvm5h5uom');
      expect(response.email, 'demo.alumni@ipam.edu');
      expect(response.studentId, 'IPAM-2015-0042');
      expect(response.isVerifiedAlumni, isTrue);
      expect(response.membershipTier, 'SILVER_LIFETIME');
      expect(response.status, 'APPROVED');
      expect(response.savedJobsCount, 5);
      expect(response.token, 'mock_jwt_token_123');

      final profile = response.profile;
      expect(profile, isNotNull);
      expect(profile!.name, 'Alex Sesay');
      expect(profile.classYear, 2015);
      expect(profile.degree, 'BSc Public Administration');
      expect(profile.major, 'Public Policy');
      expect(profile.isMentor, isTrue);
      expect(profile.skills, contains('Policy Analysis'));
      expect(profile.skills, contains('Project Management'));

      // Check toUserModel conversion
      final user = response.toUserModel();
      expect(user.fullName, 'Alex Sesay');
      expect(user.email, 'demo.alumni@ipam.edu');
      expect(user.membershipNumber, 'IPAM-2015-0042');
      expect(user.isVerified, isTrue);
      expect(user.hasDigitalCard, isTrue);
      expect(user.degree, 'BSc Public Administration');
      expect(user.department, 'Public Policy');
    });

    test('UserModel.fromJson parses nested server profile and alumniRecord', () {
      final json = {
        'id': 'cmv163kf90007l42gvm5h5uom',
        'email': 'demo.alumni@ipam.edu',
        'studentId': 'IPAM-2015-0042',
        'isVerifiedAlumni': true,
        'status': 'APPROVED',
        'membershipTier': 'SILVER_LIFETIME',
        'profile': {
          'name': 'Alex Sesay',
          'avatar': 'https://images.unsplash.com/avatar.jpg',
          'classYear': 2015,
          'degree': 'BSc Public Administration',
          'major': 'Public Policy',
          'currentRole': 'Program Manager',
          'company': 'UNDP Sierra Leone',
          'location': 'Freetown',
        },
        'alumniRecord': {
          'regNo': 'IPAM-2015-0042',
          'digitalPassIssued': true,
        }
      };

      final user = UserModel.fromJson(json);
      expect(user.fullName, 'Alex Sesay');
      expect(user.email, 'demo.alumni@ipam.edu');
      expect(user.graduationYear, 2015);
      expect(user.degree, 'BSc Public Administration');
      expect(user.department, 'Public Policy');
      expect(user.membershipNumber, 'IPAM-2015-0042');
      expect(user.currentCompany, 'UNDP Sierra Leone');
      expect(user.currentRole, 'Program Manager');
      expect(user.isVerified, isTrue);
      expect(user.hasDigitalCard, isTrue);
    });

    test('RegisterRequest serializes with required and optional fields', () {
      final req = RegisterRequest(
        email: 'jane.doe@alumni.ipam.edu',
        studentId: 'IPAM-2022-8492',
        password: 'Password123!',
        name: 'Jane Doe',
        classYear: 2022,
        degree: 'B.Sc. Applied Computing',
        major: 'Software Engineering',
        otp: '813707',
        currentRole: 'Software Engineer',
        company: 'Apex Technologies',
        location: 'Freetown',
        country: 'Sierra Leone',
        industry: 'Technology',
        bio: 'Passionate about civic tech.',
        isMentor: true,
      );

      final json = req.toJson();
      expect(json['email'], 'jane.doe@alumni.ipam.edu');
      expect(json['studentId'], 'IPAM-2022-8492');
      expect(json['password'], 'Password123!');
      expect(json['name'], 'Jane Doe');
      expect(json['classYear'], 2022);
      expect(json['degree'], 'B.Sc. Applied Computing');
      expect(json['major'], 'Software Engineering');
      expect(json['otp'], '813707');
      expect(json['isMentor'], isTrue);
    });

    test('RegistrationDraft serializes to JSON with dynamic OTP', () {
      final draft = RegistrationDraft(
        email: 'jane.doe@alumni.ipam.edu',
        studentId: 'IPAM-2022-8492',
        password: 'Password123!',
        name: 'Jane Doe',
        classYear: 2022,
        degree: 'B.Sc. Applied Computing',
        major: 'Software Engineering',
        currentRole: 'Software Engineer',
        company: 'Apex Technologies',
        location: 'Freetown',
        country: 'Sierra Leone',
        industry: 'Technology',
        bio: 'Passionate about mobile apps and civic tech.',
        isMentor: true,
      );

      final json = draft.toJson(otp: '654321');
      expect(json['email'], 'jane.doe@alumni.ipam.edu');
      expect(json['otp'], '654321');
      expect(json['studentId'], 'IPAM-2022-8492');
      expect(json['isMentor'], isTrue);
    });

    test('ChangePasswordRequest serializes correctly', () {
      final req = ChangePasswordRequest(
        currentPassword: 'Password123!',
        newPassword: 'NewSecurePassword456!',
      );

      final json = req.toJson();
      expect(json['currentPassword'], 'Password123!');
      expect(json['newPassword'], 'NewSecurePassword456!');
    });
  });

  group('ApiClient Base URL and Config Tests', () {
    test('ApiClient currentBaseUrl points to https://ipam.billnbite.cloud', () {
      expect(ApiClient.currentBaseUrl, 'https://ipam.billnbite.cloud');
      expect(ApiClient.formatUrl('/api/auth/alumni/login'),
          'https://ipam.billnbite.cloud/api/auth/alumni/login');
      expect(ApiClient.formatUrl('api/auth/alumni/me'),
          'https://ipam.billnbite.cloud/api/auth/alumni/me');
    });
  });

  group('Auth Exceptions Tests', () {
    test('UserAlreadyExistsException formats clean message and exposes fields', () {
      final ex = UserAlreadyExistsException(
        message: 'An account with this email address already exists. Please sign in.',
        email: 'test@example.com',
        studentId: 'IPAM-2022-001',
        field: 'email',
      );

      expect(ex.message, 'An account with this email address already exists. Please sign in.');
      expect(ex.toString(), 'An account with this email address already exists. Please sign in.');
      expect(ex.email, 'test@example.com');
      expect(ex.studentId, 'IPAM-2022-001');
      expect(ex.field, 'email');
    });

    test('AccountPendingApprovalException retains status and message', () {
      final ex = AccountPendingApprovalException(
        email: 'pending@example.com',
        studentId: 'IPAM-2024-999',
        message: 'Your registration is currently pending administrator approval.',
        status: 'PENDING',
      );

      expect(ex.status, 'PENDING');
      expect(ex.email, 'pending@example.com');
      expect(ex.toString(), 'Your registration is currently pending administrator approval.');
    });
  });

  group('AuthService Tests', () {
    test('AuthService can be instantiated and exposes contract methods', () {
      Get.put(AuthStorageService());
      Get.put(ApiClient());

      final service = AuthService();
      expect(service, isNotNull);
    });
  });
}
