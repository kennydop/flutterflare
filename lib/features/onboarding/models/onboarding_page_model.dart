// Model representing an onboarding page
class OnboardingPageModel {
  // Title of the onboarding page
  final String title;

  // Description of the onboarding page
  final String description;

  // Image asset path for the onboarding page
  final String imagePath;

  // Constructor
  const OnboardingPageModel({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

// List of onboarding pages
final List<OnboardingPageModel> onboardingPages = [
  const OnboardingPageModel(
    title: "Welcome to\nFlutterFlare!",
    description: "Your rocket-powered launchpad for\nmobile apps.",
    imagePath: 'assets/images/rocket.png',
  ),
  const OnboardingPageModel(
    title: "Blazing Fast\nDevelopment",
    description:
        "Forget weeks of setup. With FlutterFlare, you'll have your core infrastructure ready in hours.\nYou code only what matters!",
    imagePath: 'assets/images/speed-radar.png',
  ),
  const OnboardingPageModel(
    title: "Ready to\nIgnite?",
    description: "Your app is just moments away from becoming real.",
    imagePath: 'assets/images/fire.png',
  ),
];
