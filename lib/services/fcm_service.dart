import '../core/services/notification_service.dart';

export '../core/services/notification_service.dart';

/// FcmService provides a clean compatibility wrapper around NotificationService
/// matching the specification in Module 14 (3.2).
class FcmService {
  final NotificationService _service;

  FcmService({NotificationService? service})
      : _service = service ?? NotificationService.instance;

  Future<void> initialize() async {
    await _service.init();
  }

  Future<void> registerTokenWithBackend(String token) async {
    await _service.syncTokenWithBackend(token);
  }

  Future<void> unregisterTokenOnLogout() async {
    await _service.unregisterOnLogout();
  }
}

