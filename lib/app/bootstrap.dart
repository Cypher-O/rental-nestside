import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/di/service_locator.dart';
import '../core/utils/logger.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../shared/providers/app_state_provider.dart';
import 'app.dart';

Future<void> bootstrap({required bool enableLogging}) async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.init(isEnabled: enableLogging);

  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );

  await _initializeAuth(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const RentalApp(),
    ),
  );
}

Future<void> _initializeAuth(ProviderContainer container) async {
  final secureStorage = container.read(secureStorageProvider);
  final appStateNotifier = container.read(appStateProvider.notifier);

  final accessToken = await secureStorage.getAccessToken();
  if (accessToken != null && accessToken.isNotEmpty) {
    appStateNotifier.setAuthenticated();
    await container.read(authViewModelProvider.notifier).restoreUser(secureStorage);
  } else {
    appStateNotifier.setUnauthenticated();
  }
}
