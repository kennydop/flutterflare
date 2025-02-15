import 'package:flutterflare/core/validators/validators.dart';

extension StringX on String {
  /// Checks if the string is a valid email
  bool get isValidEmail => FormValidator.validateEmail(this).isValid;

  /// Checks if the string is a valid URL
  bool get isValidUrl => FormValidator.validateUrl(this).isValid;

  /// Checks if the string is numeric
  bool get isNumeric => double.tryParse(this) != null;

  /// Checks if the string is a valid phone number
  bool get isValidPhone => FormValidator.validatePhone(this).isValid;

  /// Capitalizes the first letter of the string
  String get capitalizeFirst =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';

  /// Capitalizes the first letter of each word in the string
  String get titleCase =>
      split(' ').map((word) => word.capitalizeFirst).join(' ');

  /// Removes all whitespace from the string
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Checks if the string contains only letters
  bool get isAlpha => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Checks if the string contains only letters and numbers
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Converts the string to a slug (lowercase, no spaces, no special characters)
  String get toSlug => toLowerCase()
      .trim()
      .replaceAll(RegExp(r'[^\w\s-]'), '')
      .replaceAll(RegExp(r'[-\s]+'), '-');

  /// Truncates the string to the specified length with ellipsis
  String truncate(int length, {String suffix = '...'}) {
    if (this.length <= length) return this;
    return '${substring(0, length)}$suffix';
  }

  /// Checks if the string is empty or only contains whitespace
  bool get isBlank => trim().isEmpty;

  /// Checks if the string is not empty and contains more than just whitespace
  bool get isNotBlank => !isBlank;

  /// Removes all special characters from the string
  String get removeSpecialCharacters => replaceAll(RegExp(r'[^\w\s]+'), '');

  /// Extracts all numbers from the string
  String get extractNumbers => replaceAll(RegExp(r'[^0-9]'), '');

  /// Checks if the string is a valid password
  ValidationResult get validatePassword => FormValidator.validatePassword(this);

  /// Converts the string to a boolean
  bool? toBool() {
    final lower = toLowerCase().trim();
    if (lower == 'true' || lower == '1' || lower == 'yes') return true;
    if (lower == 'false' || lower == '0' || lower == 'no') return false;
    return null;
  }

  /// Converts the string to an integer
  int? toInt() => int.tryParse(this);

  /// Converts the string to a double
  double? toDouble() => double.tryParse(this);
}
