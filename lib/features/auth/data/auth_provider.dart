import '../../../core/network/models/api_response_model.dart';
import '../../../models/auth_models.dart';
import '../../../services/auth_service.dart';

class AuthProvider {
  final AuthService _authService;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService();

  Future<ApiResponse<LoginResponse>> login({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    try {
      final loginData = await _authService.login(
        email,
        password,
        rememberMe: rememberMe,
      );
      return ApiResponse<LoginResponse>(
        success: true,
        message: 'Signed in successfully',
        data: loginData,
        statusCode: 200,
      );
    } on AccountPendingApprovalException {
      rethrow;
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      return ApiResponse<LoginResponse>.error(message: msg);
    }
  }

  Future<ApiResponse<RegisterResponse>> register({
    required String email,
    required String studentId,
    required String password,
    required String name,
    required int classYear,
    required String degree,
    required String major,
    required String otp,
    String? currentRole,
    String? company,
    String? location,
    String? country,
    String? industry,
    String? bio,
    bool isMentor = false,
  }) async {
    try {
      final request = RegisterRequest(
        email: email,
        studentId: studentId,
        password: password,
        name: name,
        classYear: classYear,
        degree: degree,
        major: major,
        otp: otp,
        currentRole: currentRole,
        company: company,
        location: location,
        country: country ?? 'Sierra Leone',
        industry: industry,
        bio: bio,
        isMentor: isMentor,
      );

      final result = await _authService.register(request);
      return ApiResponse<RegisterResponse>(
        success: true,
        message: result.message,
        data: result,
        statusCode: 201,
      );
    } on UserAlreadyExistsException catch (e) {
      return ApiResponse<RegisterResponse>.error(
        message: e.message,
        statusCode: 409,
        error: 'USER_ALREADY_EXISTS',
      );
    } on AccountPendingApprovalException {
      rethrow;
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      return ApiResponse<RegisterResponse>.error(message: msg);
    }
  }

  Future<LoginResponse?> checkSession() async {
    return _authService.checkSession();
  }

  Future<ApiResponse<bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _authService.changePassword(currentPassword, newPassword);
      return ApiResponse<bool>(
        success: true,
        message: 'Password changed successfully',
        data: true,
        statusCode: 200,
      );
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      return ApiResponse<bool>.error(message: msg);
    }
  }

  Future<ApiResponse<bool>> logout() async {
    try {
      await _authService.logout();
      return ApiResponse<bool>(
        success: true,
        message: 'Logged out successfully',
        data: true,
        statusCode: 200,
      );
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      return ApiResponse<bool>.error(message: msg);
    }
  }

  Future<ApiResponse<bool>> sendRegistrationOtp({
    required String email,
    required String name,
    String? studentId,
    String purpose = 'REGISTRATION',
  }) async {
    try {
      await _authService.sendRegistrationOtp(
        email: email,
        name: name,
        studentId: studentId,
        purpose: purpose,
      );
      return ApiResponse<bool>(
        success: true,
        message: 'A 6-digit dynamic verification code has been dispatched to $email.',
        data: true,
        statusCode: 200,
      );
    } on UserAlreadyExistsException catch (e) {
      return ApiResponse<bool>.error(
        message: e.message,
        statusCode: 409,
        error: 'USER_ALREADY_EXISTS',
      );
    } on AccountPendingApprovalException catch (e) {
      return ApiResponse<bool>.error(
        message: e.message,
        statusCode: 409,
        error: 'PENDING_APPROVAL',
      );
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      return ApiResponse<bool>.error(message: msg);
    }
  }

  Future<ApiResponse<bool>> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _authService.resetPasswordWithOtp(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      return ApiResponse<bool>(
        success: true,
        message: 'Password reset successfully. You can now log in with your new password.',
        data: true,
        statusCode: 200,
      );
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      return ApiResponse<bool>.error(message: msg);
    }
  }

  Future<ApiResponse<bool>> forgotPassword(String email) async {
    try {
      await _authService.requestPasswordResetOtp(email);
      return ApiResponse<bool>(
        success: true,
        message: 'A 6-digit dynamic password reset verification code has been dispatched to your email.',
        data: true,
        statusCode: 200,
      );
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      return ApiResponse<bool>.error(message: msg);
    }
  }
}
