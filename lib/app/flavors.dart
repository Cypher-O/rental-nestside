enum Flavor { dev, production }

class FlavorConfig {
  FlavorConfig._({
    required this.flavor,
    required this.apiBaseUrl,
    required this.paystackPublicKey,
    required this.appName,
  });

  final Flavor flavor;
  final String apiBaseUrl;
  final String paystackPublicKey;
  final String appName;

  static late FlavorConfig _instance;
  static FlavorConfig get shared => _instance;

  static void create({
    required Flavor flavor,
    required String apiBaseUrl,
    required String paystackPublicKey,
    required String appName,
  }) {
    _instance = FlavorConfig._(
      flavor: flavor,
      apiBaseUrl: apiBaseUrl,
      paystackPublicKey: paystackPublicKey,
      appName: appName,
    );
  }

  bool get isDevelopment => flavor == Flavor.dev;
  bool get isProduction => flavor == Flavor.production;
}
