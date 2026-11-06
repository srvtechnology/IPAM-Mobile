class ApiEndpoints {
  // Auth
  static const String login = '/api/auth/alumni/login';
  static const String register = '/api/auth/alumni/register';
  static const String logout = '/api/auth/alumni/logout';
  static const String me = '/api/auth/alumni/me';
  static const String changePassword = '/api/auth/alumni/change-password';
  static const String refreshToken = '/api/auth/refresh';
  static const String profile = '/api/profile';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';
  static const String sendOtp = '/api/auth/2fa/send-otp';

  // Alumni Directory & Networking (05-alumni-directory-and-networking.md)
  static const String alumniDirectory = '/api/alumni';
  static String alumniDetail(String id) => '/api/alumni/$id';
  static const String alumniBookmarks = '/api/alumni/bookmarks';
  static String alumniConnect(String id) => '/api/alumni/$id/connect';
  // Push Notifications & Device Tokens
  static const String alumniNotifications = '/api/alumni/notifications';
  static String markNotificationRead(String id) => '/api/alumni/notifications/$id/read';
  static const String markAllNotificationsRead = '/api/alumni/notifications/read-all';
  static const String registerToken = '/api/notifications/register-token';
  static const String unregisterToken = '/api/notifications/unregister-token';
  static const String notificationDevices = '/api/notifications/devices';

  // Events & Ticketing (03-events-and-ticketing.md)
  static const String events = '/api/events';
  static String eventDetail(String id) => '/api/events/$id';
  static String eventRegister(String id) => '/api/events/$id/register';
  static const String myEventRegistrations = '/api/events/my-registrations';
  static String myEventRegistrationDetail(String bookingRef) => '/api/events/my-registrations/$bookingRef';
  static const String eventProposals = '/api/event-proposals';
  static const String eventRsvp = '/api/events/rsvp';

  // Digital ID & Card Issuance
  static const String alumniPass = '/api/alumni/pass';
  static const String verifyPass = '/api/alumni/pass/verify';
  static const String digitalPass = '/api/alumni/digital-pass';
  static const String orderCard = '/api/alumni/orders/card';

  // Jobs & Opportunities (04-jobs-and-careers.md)
  static const String jobs = '/api/jobs';
  static String jobDetail(String id) => '/api/jobs/$id';
  static String jobApply(String id) => '/api/jobs/$id/apply';
  static String jobSave(String id) => '/api/jobs/$id/save';
  static const String savedJobs = '/api/jobs/saved';
  static const String myJobApplications = '/api/jobs/my-applications';
  static const String upload = '/api/upload';

  // Donations & Giving (08-donations-and-giving.md)
  static const String donations = '/api/donations';

  // Membership & Subscriptions (09-membership-and-subscriptions.md)
  static const String subscription = '/api/subscription';

  // Leadership & Hero Content
  static const String leadership = '/api/leadership';
  static const String heroSlides = '/api/hero-slides';
  static const String banners = '/api/banners';
}
