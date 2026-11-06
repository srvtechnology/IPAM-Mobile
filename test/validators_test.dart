import 'package:flutter_test/flutter_test.dart';
import 'package:ipam_mobile/core/utils/validators.dart';

void main() {
  group('Validators.strongPassword Unit Tests', () {
    test('returns error when password is null or empty', () {
      expect(Validators.strongPassword(null), 'Password is required');
      expect(Validators.strongPassword(''), 'Password is required');
    });

    test('returns error when password has fewer than 8 characters', () {
      expect(
        Validators.strongPassword('P@ss1'),
        'Password must be at least 8 characters',
      );
    });

    test('returns error when password lacks an uppercase letter', () {
      expect(
        Validators.strongPassword('password123!'),
        'Include at least one uppercase letter (A-Z)',
      );
    });

    test('returns error when password lacks a lowercase letter', () {
      expect(
        Validators.strongPassword('PASSWORD123!'),
        'Include at least one lowercase letter (a-z)',
      );
    });

    test('returns error when password lacks a digit', () {
      expect(
        Validators.strongPassword('PasswordSecret!'),
        'Include at least one number (0-9)',
      );
    });

    test('returns error when password lacks a special character', () {
      expect(
        Validators.strongPassword('Password1234'),
        'Include at least one special character (!@#\$%^&*)',
      );
    });

    test('returns null when password satisfies all strong password requirements', () {
      expect(Validators.strongPassword('SecretP@ss123'), isNull);
      expect(Validators.strongPassword('Alumni2026#Secure'), isNull);
      expect(Validators.strongPassword('Usl@Ipam2022!'), isNull);
    });
  });

  group('PasswordStrength Calculator Tests', () {
    test('evaluates empty password as zero score and empty label', () {
      final strength = PasswordStrength.calculate('');
      expect(strength.score, 0);
      expect(strength.isStrong, isFalse);
      expect(strength.label, '');
      expect(strength.hasMinLength, isFalse);
      expect(strength.hasUppercase, isFalse);
      expect(strength.hasLowercase, isFalse);
      expect(strength.hasDigit, isFalse);
      expect(strength.hasSpecialChar, isFalse);
    });

    test('evaluates weak passwords (score 1-2)', () {
      final strength1 = PasswordStrength.calculate('abc');
      expect(strength1.score, 1);
      expect(strength1.label, 'Weak');

      final strength2 = PasswordStrength.calculate('abcDEF');
      expect(strength2.score, 2);
      expect(strength2.label, 'Weak');
    });

    test('evaluates fair passwords (score 3)', () {
      final strength = PasswordStrength.calculate('abcDEF123');
      expect(strength.score, 4); // >=8, upper, lower, digit = 4

      final strength3 = PasswordStrength.calculate('abc12345');
      // >=8, lower, digit = 3
      expect(strength3.score, 3);
      expect(strength3.label, 'Fair');
    });

    test('evaluates good passwords (score 4)', () {
      final strength = PasswordStrength.calculate('Secret12345');
      // >=8, upper, lower, digit = 4
      expect(strength.score, 4);
      expect(strength.label, 'Good');
    });

    test('evaluates strong passwords (score 5)', () {
      final strength = PasswordStrength.calculate('SecretP@ss123');
      expect(strength.score, 5);
      expect(strength.isStrong, isTrue);
      expect(strength.label, 'Strong');
      expect(strength.hasMinLength, isTrue);
      expect(strength.hasUppercase, isTrue);
      expect(strength.hasLowercase, isTrue);
      expect(strength.hasDigit, isTrue);
      expect(strength.hasSpecialChar, isTrue);
    });
  });
}

