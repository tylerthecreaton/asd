import 'package:flutter_test/flutter_test.dart';
import 'package:asd/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateEmail', () {
      test('should return error when email is empty', () {
        expect(Validators.validateEmail(''), isNotNull);
        expect(Validators.validateEmail(null), isNotNull);
        expect(Validators.validateEmail('   '), isNotNull);
      });

      test('should return error for invalid email format', () {
        expect(Validators.validateEmail('notanemail'), isNotNull);
        expect(Validators.validateEmail('test@'), isNotNull);
        expect(Validators.validateEmail('@test.com'), isNotNull);
        expect(Validators.validateEmail('test@test'), isNotNull);
      });

      test('should return null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), isNull);
        expect(Validators.validateEmail('user.name@domain.co.th'), isNull);
        expect(Validators.validateEmail('test123@test-domain.com'), isNull);
      });
    });

    group('validatePassword', () {
      test('should return error when password is empty', () {
        expect(Validators.validatePassword(''), isNotNull);
        expect(Validators.validatePassword(null), isNotNull);
      });

      test('should return error when password is too short', () {
        expect(Validators.validatePassword('1234567'), isNotNull);
        expect(Validators.validatePassword('short'), isNotNull);
      });

      test('should return null for valid password', () {
        expect(Validators.validatePassword('12345678'), isNull);
        expect(Validators.validatePassword('strongPassword123'), isNull);
      });
    });

    group('validateRequired', () {
      test('should return error when value is empty', () {
        expect(Validators.validateRequired(''), isNotNull);
        expect(Validators.validateRequired(null), isNotNull);
        expect(Validators.validateRequired('   '), isNotNull);
      });

      test('should return null for non-empty value', () {
        expect(Validators.validateRequired('value'), isNull);
        expect(Validators.validateRequired('123'), isNull);
      });

      test('should include field name in error message', () {
        final error = Validators.validateRequired('', fieldName: 'ชื่อ');
        expect(error, contains('ชื่อ'));
      });
    });

    group('validatePhoneNumber', () {
      test('should return null for empty value (optional field)', () {
        expect(Validators.validatePhoneNumber(''), isNull);
        expect(Validators.validatePhoneNumber(null), isNull);
      });

      test('should return error for invalid phone format', () {
        expect(Validators.validatePhoneNumber('123456789'), isNotNull);
        expect(Validators.validatePhoneNumber('12345678901'), isNotNull);
        expect(Validators.validatePhoneNumber('1234567890'), isNotNull);
        expect(Validators.validatePhoneNumber('abcdefghij'), isNotNull);
      });

      test('should return null for valid Thai phone number', () {
        expect(Validators.validatePhoneNumber('0812345678'), isNull);
        expect(Validators.validatePhoneNumber('0987654321'), isNull);
      });
    });

    group('validateConfirmPassword', () {
      test('should return error when confirm password is empty', () {
        expect(Validators.validateConfirmPassword('', 'password'), isNotNull);
        expect(Validators.validateConfirmPassword(null, 'password'), isNotNull);
      });

      test('should return error when passwords do not match', () {
        expect(
          Validators.validateConfirmPassword('password1', 'password2'),
          isNotNull,
        );
      });

      test('should return null when passwords match', () {
        expect(
          Validators.validateConfirmPassword('password123', 'password123'),
          isNull,
        );
      });
    });

    group('validateName', () {
      test('should return error when name is empty', () {
        expect(Validators.validateName(''), isNotNull);
        expect(Validators.validateName(null), isNotNull);
        expect(Validators.validateName('   '), isNotNull);
      });

      test('should return error when name is too short', () {
        expect(Validators.validateName('A'), isNotNull);
      });

      test('should return null for valid name', () {
        expect(Validators.validateName('John'), isNull);
        expect(Validators.validateName('สมชาย ใจดี'), isNull);
        expect(Validators.validateName('AB'), isNull);
      });

      test('should include field name in error message', () {
        final error = Validators.validateName('', fieldName: 'ชื่อเล่น');
        expect(error, contains('ชื่อเล่น'));
      });
    });
  });
}
