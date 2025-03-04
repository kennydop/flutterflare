import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/services/storage/local_storage_service.dart';
import 'package:flutterflare/features/onboarding/models/onboarding_page_model.dart';

final onboardingViewModelProvider = Provider<OnboardingViewModel>((ref) {
  final localStorage = ref.watch(localStorageProvider);
  return OnboardingViewModel(localStorage: localStorage);
});

// ViewModel for managing onboarding state
class OnboardingViewModel {
  final LocalStorage _localStorage;
  final PageController pageController = PageController();

  // Constructor
  OnboardingViewModel({required LocalStorage localStorage})
    : _localStorage = localStorage;

  // Get the onboarding pages
  List<OnboardingPageModel> get pages => onboardingPages;

  // Check if onboarding has been completed
  bool hasOnboardingCompleted() {
    return _localStorage.hasOnboardingCompleted();
  }

  // Mark onboarding as completed
  Future<void> completeOnboarding() async {
    await _localStorage.setOnboardingCompleted();
  }

  // Go to the next page
  void nextPage() {
    if (pageController.page!.toInt() < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Skip to the last page
  void skipToLastPage() {
    pageController.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Dispose resources
  void dispose() {
    pageController.dispose();
  }
}
