class Validators {
  static String? required(String? value, {String message = 'This field is required'}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Strong password validation for registration & password changes.
  /// Enforces: min 8 chars, 1 uppercase, 1 lowercase, 1 digit, and 1 special symbol.
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Include at least one uppercase letter (A-Z)';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Include at least one lowercase letter (a-z)';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Include at least one number (0-9)';
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\\/\[\]~`]').hasMatch(value)) {
      return 'Include at least one special character (!@#\$%^&*)';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (value.trim().length < 8) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? graduationYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Graduation year is required';
    }
    final year = int.tryParse(value.trim());
    if (year == null || year < 1960 || year > DateTime.now().year + 6) {
      return 'Please enter a valid 4-digit graduation year';
    }
    return null;
  }
}

/// Evaluates real-time criteria score and status for password inputs.
class PasswordStrength {
  final bool hasMinLength; // >= 8
  final bool hasUppercase; // [A-Z]
  final bool hasLowercase; // [a-z]
  final bool hasDigit; // [0-9]
  final bool hasSpecialChar; // [!@#$%^&*...]

  const PasswordStrength({
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasDigit,
    required this.hasSpecialChar,
  });

  int get score {
    int s = 0;
    if (hasMinLength) s++;
    if (hasUppercase) s++;
    if (hasLowercase) s++;
    if (hasDigit) s++;
    if (hasSpecialChar) s++;
    return s;
  }

  bool get isStrong => score == 5;

  String get label {
    switch (score) {
      case 0:
        return '';
      case 1:
      case 2:
        return 'Weak';
      case 3:
        return 'Fair';
      case 4:
        return 'Good';
      case 5:
        return 'Strong';
      default:
        return '';
    }
  }

  static PasswordStrength calculate(String password) {
    if (password.isEmpty) {
      return const PasswordStrength(
        hasMinLength: false,
        hasUppercase: false,
        hasLowercase: false,
        hasDigit: false,
        hasSpecialChar: false,
      );
    }
    return PasswordStrength(
      hasMinLength: password.length >= 8,
      hasUppercase: RegExp(r'[A-Z]').hasMatch(password),
      hasLowercase: RegExp(r'[a-z]').hasMatch(password),
      hasDigit: RegExp(r'[0-9]').hasMatch(password),
      hasSpecialChar: RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\\/\[\]~`]').hasMatch(password),
    );
  }
}
