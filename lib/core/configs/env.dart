import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env.dev', obfuscate: true, useConstantCase: true)
final class Env {
  @EnviedField()
  static final String apiUrl = _Env.apiUrl;

  @EnviedField()
  static final bool enableAnalytics = _Env.enableAnalytics;

  @EnviedField()
  static final bool enableCrashlytics = _Env.enableCrashlytics;

  @EnviedField()
  static final String stripePublishableKey = _Env.stripePublishableKey;

  @EnviedField()
  static final String stripeSecretKey = _Env.stripeSecretKey;

  @EnviedField()
  static final String paystackSecretKey = _Env.paystackSecretKey;

  @EnviedField()
  static final String paystackPublicKey = _Env.paystackPublicKey;

  @EnviedField()
  static final String algoliaAppId = _Env.algoliaAppId;

  @EnviedField()
  static final String algoliaApiKey = _Env.algoliaApiKey;
}
