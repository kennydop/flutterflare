import 'package:flutterflare/core/constants/app_constants.dart';
import 'package:flutterflare/core/validators/validation_result.dart';

class FormValidator {
  static final RegExp _emailRegex = RegExp(AppConstants.emailRegex);
  static const String _validSymbols =
      r'''!@#\$%&*\/\\?\(\)\{\}\[\]\|`¬¦"^'<>:;~_\-+=,.''';

  /// Validates an email address
  static ValidationResult validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return ValidationResult.invalid('Email is required');
    }

    if (!_emailRegex.hasMatch(email)) {
      return ValidationResult.invalid('Please enter a valid email address');
    }

    return ValidationResult.valid();
  }

  /// Validates a password with complexity requirements
  static ValidationResult validatePassword(String? password) {
    if (password == null || password.trim().isEmpty) {
      return ValidationResult.invalid('Password is required');
    }

    final validationSteps =
        List.filled(5, 1); // 1 = neutral, 0 = invalid, 2 = valid
    String? error;

    // Check uppercase
    if (RegExp(r'[A-Z]').hasMatch(password)) {
      validationSteps[0] = 2;
    } else {
      validationSteps[0] = 0;
      error = 'Password must contain at least one uppercase letter';
    }

    // Check lowercase
    if (RegExp(r'[a-z]').hasMatch(password)) {
      validationSteps[1] = 2;
    } else {
      validationSteps[1] = 0;
      error = error ?? 'Password must contain at least one lowercase letter';
    }

    // Check numbers
    if (RegExp(r'[0-9]').hasMatch(password)) {
      validationSteps[2] = 2;
    } else {
      validationSteps[2] = 0;
      error = error ?? 'Password must contain at least one number';
    }

    // Check symbols
    if (RegExp('[$_validSymbols]').hasMatch(password)) {
      validationSteps[3] = 2;
    } else {
      validationSteps[3] = 0;
      error = error ?? 'Password must contain at least one symbol';
    }

    // Check length
    if (password.length >= AppConstants.minPasswordLength) {
      validationSteps[4] = 2;
    } else {
      validationSteps[4] = 0;
      error = error ??
          'Password must be at least ${AppConstants.minPasswordLength} characters';
    }

    // Check overall validity
    final isValid = !validationSteps.contains(0) &&
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&' +
                _validSymbols +
                r']{' +
                AppConstants.minPasswordLength.toString() +
                r',}$')
            .hasMatch(password);

    if (!isValid && error == null) {
      // Check for invalid characters
      final invalidChars = RegExp(r'[^' + _validSymbols + r'\w\d]')
          .allMatches(password)
          .map((m) => m.group(0)!)
          .toList();

      if (invalidChars.isNotEmpty) {
        error = 'Invalid character(s): ${invalidChars.join(', ')}';
      }
    }

    return ValidationResult.withSteps(
      isValid: isValid,
      error: error,
      validationSteps: validationSteps,
    );
  }

  /// Validates a required field
  static ValidationResult validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult.invalid('$fieldName is required');
    }
    return ValidationResult.valid();
  }

  /// Validates a phone number
  static ValidationResult validatePhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return ValidationResult.invalid('Phone number is required');
    }

    // Basic phone validation - can be enhanced based on requirements
    if (!RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(phone)) {
      return ValidationResult.invalid('Please enter a valid phone number');
    }

    return ValidationResult.valid();
  }

  /// Validates a numeric value
  static ValidationResult validateNumeric(
    String? value, {
    String? fieldName,
    double? min,
    double? max,
  }) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult.invalid('${fieldName ?? 'Value'} is required');
    }

    final number = double.tryParse(value);
    if (number == null) {
      return ValidationResult.invalid('Please enter a valid number');
    }

    if (min != null && number < min) {
      return ValidationResult.invalid(
          'Value must be greater than or equal to $min');
    }

    if (max != null && number > max) {
      return ValidationResult.invalid(
          'Value must be less than or equal to $max');
    }

    return ValidationResult.valid();
  }

  /// Validates a URL
  static ValidationResult validateUrl(String? url) {
    if (url == null || url.trim().isEmpty) {
      return ValidationResult.invalid('URL is required');
    }

    final uri = Uri.tryParse(url);
    if (uri == null || !uri.isAbsolute) {
      return ValidationResult.invalid('Please enter a valid URL');
    }

    return ValidationResult.valid();
  }

  /// Validates text length
  static ValidationResult validateLength(
    String? value, {
    String? fieldName,
    int? minLength,
    int? maxLength,
  }) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult.invalid('${fieldName ?? 'Value'} is required');
    }

    if (minLength != null && value.length < minLength) {
      return ValidationResult.invalid(
          '${fieldName ?? 'Value'} must be at least $minLength characters');
    }

    if (maxLength != null && value.length > maxLength) {
      return ValidationResult.invalid(
          '${fieldName ?? 'Value'} must not exceed $maxLength characters');
    }

    return ValidationResult.valid();
  }
}
