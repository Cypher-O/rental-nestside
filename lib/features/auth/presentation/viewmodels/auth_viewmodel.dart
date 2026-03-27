import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../shared/providers/app_state_provider.dart';
import '../../../../core/enums/app_enums.dart';
import 'auth_state.dart';

class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel({
    required AuthRepository authRepository,
    required AppStateNotifier appStateNotifier,
  })  : _authRepository = authRepository,
        _appStateNotifier = appStateNotifier,
        super(AuthState.initial());

  final AuthRepository _authRepository;
  final AppStateNotifier _appStateNotifier;

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result =
        await _authRepository.login(email: email, password: password);

    if (result.isSuccess) {
      state = state.copyWith(status: AuthStatus.success, user: result.data);
      _appStateNotifier.setAuthenticated();
      return true;
    }

    state = state.copyWith(
      status: AuthStatus.failure,
      errorMessage: result.errorOrEmpty,
    );
    return false;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    String role = 'tenant',
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result = await _authRepository.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      role: role,
    );

    if (result.isSuccess) {
      state = state.copyWith(status: AuthStatus.success);
      return true;
    }

    state = state.copyWith(
      status: AuthStatus.failure,
      errorMessage: result.errorOrEmpty,
    );
    return false;
  }

  Future<void> loadProfile() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    final result = await _authRepository.getProfile();
    if (result.isSuccess) {
      state = state.copyWith(status: AuthStatus.success, user: result.data);
    } else {
      state = state.copyWith(
        status: AuthStatus.failure,
        errorMessage: result.errorOrEmpty,
      );
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _appStateNotifier.logout();
    state = AuthState.initial();
  }

  Future<void> restoreUser(SecureStorage secureStorage) async {
    final userData = await secureStorage.getUserData();
    if (userData != null) {
      state = state.copyWith(user: UserModel.fromJson(userData).toEntity());
    }
  }

  void clearError() {
    state = state.copyWith(status: AuthStatus.initial, errorMessage: null);
  }
}
