// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import '../features/splash/screens/splash_screen.dart';
import '../features/splash/bindings/splash_binding.dart';
import '../features/auth/screens/welcome_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/otp_verification_screen.dart';
import '../features/auth/screens/pending_approval_screen.dart';
import '../features/auth/bindings/auth_binding.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/dashboard/binding/dashboard_binding.dart';
import '../features/directory/screens/directory_screen.dart';
import '../features/directory/bindings/directory_binding.dart';
import '../features/careers/screens/careers_screen.dart';
import '../features/careers/bindings/careers_binding.dart';
import '../features/events/screens/events_screen.dart';
import '../features/events/bindings/events_binding.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/bindings/profile_binding.dart';
import '../features/directory/screens/member_details_screen.dart';
import '../features/directory/bindings/member_details_binding.dart';

import '../features/careers/screens/career_applications_screen.dart';
import '../features/careers/screens/career_my_postings_screen.dart';
import '../features/careers/screens/job_details_screen.dart';
import '../features/careers/bindings/job_details_binding.dart';
import '../features/events/screens/event_details_screen.dart';
import '../features/events/bindings/event_details_binding.dart';

import '../features/profile/screens/virtual_pass_screen.dart';
import '../features/profile/screens/qr_scanner_screen.dart';
import '../features/giving/screens/giving_screen.dart';
import '../features/giving/bindings/giving_binding.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/notifications/bindings/notifications_binding.dart';

class Routes {
  static const SPLASH = '/';
  static const WELCOME = '/welcome';
  static const LOGIN = '/auth/login';
  static const REGISTER = '/auth/register';
  static const FORGOT_PASSWORD = '/auth/forgot-password';
  static const OTP_VERIFICATION = '/auth/otp-verification';
  static const PENDING_APPROVAL = '/auth/pending-approval';
  static const DASHBOARD = '/dashboard';
  static const DIRECTORY = '/directory';
  static const CAREERS = '/careers';
  static const CAREER_APPLICATIONS = '/careers/applications';
  static const CAREER_MY_POSTINGS = '/careers/my-postings';
  static const EVENTS = '/events';
  static const EVENT_DETAILS = '/events/details';
  static const PROFILE = '/profile';
  static const MEMBER_DETAILS = '/directory/member-details';
  static const VIRTUAL_PASS = '/pass';
  static const QR_SCANNER = '/pass/scanner';
  static const GIVING = '/giving';
  static const JOB_DETAILS = '/careers/job-details';
  static const NOTIFICATIONS = '/notifications';
}

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.WELCOME,
      page: () => const WelcomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.OTP_VERIFICATION,
      page: () => const OtpVerificationScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.PENDING_APPROVAL,
      page: () => const PendingApprovalScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.DIRECTORY,
      page: () => const DirectoryScreen(),
      binding: DirectoryBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.CAREERS,
      page: () => const CareersScreen(),
      binding: CareersBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.CAREER_APPLICATIONS,
      page: () => const CareerApplicationsScreen(),
      binding: CareersBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.CAREER_MY_POSTINGS,
      page: () => const CareerMyPostingsScreen(),
      binding: CareersBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.EVENTS,
      page: () => const EventsScreen(),
      binding: EventsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.EVENT_DETAILS,
      page: () => const EventDetailsScreen(),
      binding: EventDetailsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.MEMBER_DETAILS,
      page: () => const MemberDetailsScreen(),
      binding: MemberDetailsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.VIRTUAL_PASS,
      page: () => const VirtualPassScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.QR_SCANNER,
      page: () => const QrScannerScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.GIVING,
      page: () => const GivingScreen(),
      binding: GivingBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.JOB_DETAILS,
      page: () => const JobDetailsScreen(),
      binding: JobDetailsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.NOTIFICATIONS,
      page: () => const NotificationsScreen(),
      binding: NotificationsBinding(),
      transition: Transition.rightToLeft,
    ),
    // Route aliases for push notification deep linking
    GetPage(
      name: '/virtual-pass',
      page: () => const VirtualPassScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/jobs',
      page: () => const CareerApplicationsScreen(),
      binding: CareersBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/card-tracker',
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
