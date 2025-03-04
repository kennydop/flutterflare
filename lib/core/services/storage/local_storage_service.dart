import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/constants/app_constants.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

// Global instance of the local storage service
LocalStorage? _instance;

// Provider for the local storage service
final localStorageProvider = Provider<LocalStorage>((ref) {
  return _instance ??= LocalStorage._();
});

// Service for handling local storage with Hive
class LocalStorage {
  // Private constructor to enforce singleton pattern
  LocalStorage._();

  bool _isInitialized = false;
  late Box<dynamic> _preferencesBox;

  // Initialize Hive and open the preferences box
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);

      _preferencesBox = await Hive.openBox<dynamic>(
        AppConstants.preferencesBoxName,
      );
      _isInitialized = true;
    } catch (e) {
      print('Failed to initialize Hive: $e');
      rethrow;
    }
  }

  // Check if the onboarding has been completed
  bool hasOnboardingCompleted() {
    return _preferencesBox.get(
          AppConstants.onboardingCompletedKey,
          defaultValue: false,
        )
        as bool;
  }

  // Set the onboarding as completed
  Future<void> setOnboardingCompleted() async {
    await _preferencesBox.put(AppConstants.onboardingCompletedKey, true);
  }

  // Reset the onboarding completed status (for testing)
  Future<void> resetOnboardingCompleted() async {
    await _preferencesBox.put(AppConstants.onboardingCompletedKey, false);
  }
}
