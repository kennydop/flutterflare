import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/constants/app_sizes.dart';
import 'package:flutterflare/core/constants/app_strings.dart';
import 'package:flutterflare/features/onboarding/viewmodels/onboarding_viewmodel.dart';
import 'package:flutterflare/features/welcome/views/welcome_view.dart';
import 'package:flutterflare/shared/widgets/buttons/button.dart';
import 'package:flutterflare/shared/widgets/dot_indicator.dart';
import 'package:go_router/go_router.dart';

/// Onboarding view that displays the app's onboarding screens
class OnboardingView extends ConsumerStatefulWidget {
  static const String routePath = '/onboarding';

  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  late final OnboardingViewModel _viewModel;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(onboardingViewModelProvider);
    _viewModel.pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _viewModel.pageController.removeListener(_onPageChanged);
    super.dispose();
  }

  void _onPageChanged() {
    if (_viewModel.pageController.page != null) {
      setState(() {
        _currentPage = _viewModel.pageController.page!.round();
      });
    }
  }

  void _onSkip() {
    _viewModel.skipToLastPage();
  }

  void _onContinue() async {
    if (_currentPage < _viewModel.pages.length - 1) {
      _viewModel.nextPage();
    } else {
      // Last page, complete onboarding
      await _viewModel.completeOnboarding();
      if (mounted) {
        context.pushReplacement(WelcomeView.routePath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(onPressed: _onSkip, child: const Text('Skip')),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _viewModel.pageController,
                itemCount: _viewModel.pages.length,
                itemBuilder: (context, index) {
                  final page = _viewModel.pages[index];
                  return Padding(
                    padding: AppSizes.gutter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppSizes.gapH24,
                        Expanded(
                          child: Image.asset(
                            page.imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                        AppSizes.gapH24,
                        Text(
                          page.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        AppSizes.gapH16,
                        SizedBox(
                          child: Text(
                            page.description,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            AppSizes.gapH16,
            // Page indicators
            Padding(
              padding: AppSizes.gutter,
              child: DotIndicator(
                dotsCount: _viewModel.pages.length,
                activeIndex: _currentPage,
                activeDotSize: AppSizes.s12,
              ),
            ),
            AppSizes.gapH16,
            // Continue button
            Padding(
              padding: AppSizes.gutter,
              child: Button(
                onPressed: _onContinue,
                child: Text(
                  _currentPage < _viewModel.pages.length - 1
                      ? AppStrings.continueText
                      : AppStrings.getStarted,
                ),
              ),
            ),
            SizedBox(
              height:
                  MediaQuery.of(context).padding.bottom > 0
                      ? MediaQuery.of(context).padding.bottom
                      : AppSizes.p16,
            ),
          ],
        ),
      ),
    );
  }
}
