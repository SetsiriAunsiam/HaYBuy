import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration service for managing app-wide environment variables
class EnvironmentConfig {
  // Private constructor
  EnvironmentConfig._();

  // Singleton instance
  static final EnvironmentConfig _instance = EnvironmentConfig._();
  static EnvironmentConfig get instance => _instance;

  // Initialize the environment configuration
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  // App Configuration
  String get appName => dotenv.env['APP_NAME'] ?? 'HaYBuy';
  String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';
  String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';

  // Check if we're in development mode
  bool get isDevelopment => environment == 'development';
  bool get isProduction => environment == 'production';
  bool get isStaging => environment == 'staging';

  // API Configuration
  String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.haybuy.com';
  int get apiTimeout => int.tryParse(dotenv.env['API_TIMEOUT'] ?? '') ?? 30000;

  // Firebase Configuration (if you want to use .env for Firebase)
  String? get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'];
  String? get firebaseAuthDomain => dotenv.env['FIREBASE_AUTH_DOMAIN'];
  String? get firebaseProjectId => dotenv.env['FIREBASE_PROJECT_ID'];

  // Third-party Services
  String get paymentGatewayUrl => dotenv.env['PAYMENT_GATEWAY_URL'] ?? '';
  String get analyticsId => dotenv.env['ANALYTICS_ID'] ?? '';

  // Feature Flags
  bool get enableAnalytics =>
      dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true';
  bool get enableCrashlytics =>
      dotenv.env['ENABLE_CRASHLYTICS']?.toLowerCase() == 'true';
  bool get enableDebugMode =>
      dotenv.env['ENABLE_DEBUG_MODE']?.toLowerCase() == 'true';

  // Social Media Links
  String get facebookUrl => dotenv.env['FACEBOOK_URL'] ?? '';
  String get twitterUrl => dotenv.env['TWITTER_URL'] ?? '';
  String get instagramUrl => dotenv.env['INSTAGRAM_URL'] ?? '';

  // Support Configuration
  String get supportEmail =>
      dotenv.env['SUPPORT_EMAIL'] ?? 'support@haybuy.com';
  String get supportPhone => dotenv.env['SUPPORT_PHONE'] ?? '';

  // Utility method to get any environment variable
  String? getEnv(String key) => dotenv.env[key];

  // Utility method to get environment variable with default value
  String getEnvWithDefault(String key, String defaultValue) =>
      dotenv.env[key] ?? defaultValue;

  // Debug method to print all environment variables (use only in development)
  void printAllEnvVars() {
    if (isDevelopment) {
      print('=== Environment Variables ===');
      dotenv.env.forEach((key, value) {
        // Don't print sensitive information
        if (key.contains('API_KEY') ||
            key.contains('SECRET') ||
            key.contains('PASSWORD')) {
          print('$key: ***HIDDEN***');
        } else {
          print('$key: $value');
        }
      });
      print('=============================');
    }
  }
}
