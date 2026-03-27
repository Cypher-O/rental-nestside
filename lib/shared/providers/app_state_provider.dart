import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums/app_enums.dart';

class AppState {
  const AppState({
    this.status = AppStatus.loading,
  });

  final AppStatus status;

  AppState copyWith({AppStatus? status}) {
    return AppState(status: status ?? this.status);
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(const AppState());

  void setLoading() => state = state.copyWith(status: AppStatus.loading);
  void setAuthenticated() =>
      state = state.copyWith(status: AppStatus.authenticated);
  void setUnauthenticated() =>
      state = state.copyWith(status: AppStatus.unauthenticated);
  void logout() => state = state.copyWith(status: AppStatus.unauthenticated);
}

final appStateProvider =
    StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});
