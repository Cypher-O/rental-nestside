import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';
import '../utils/logger.dart';
import '../../app/flavors.dart';
import '../../shared/providers/app_state_provider.dart';

// Overridden in bootstrap
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in bootstrap');
});

final loggerProvider = Provider<Logger>((ref) => Logger.instance);

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage.instance;
});

final localStorageProvider = Provider<LocalStorage>((ref) {
  return LocalStorage(ref.read(sharedPreferencesProvider));
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: FlavorConfig.shared.apiBaseUrl,
    secureStorage: ref.read(secureStorageProvider),
    logger: ref.read(loggerProvider),
    onUnauthenticated: () {
      ref.read(appStateProvider.notifier).setUnauthenticated();
    },
  );
});
