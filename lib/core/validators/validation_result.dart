class ValidationResult {
  final bool isValid;
  final String? error;
  final List<int>? validationSteps;

  const ValidationResult({
    required this.isValid,
    this.error,
    this.validationSteps,
  });

  factory ValidationResult.valid() => const ValidationResult(isValid: true);

  factory ValidationResult.invalid(String error) => ValidationResult(
        isValid: false,
        error: error,
      );

  factory ValidationResult.withSteps({
    required bool isValid,
    String? error,
    required List<int> validationSteps,
  }) =>
      ValidationResult(
        isValid: isValid,
        error: error,
        validationSteps: validationSteps,
      );
}
