import '../../../../core/network/result.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorage secureStorage,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage;

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.login(
      LoginRequestModel(email: email, password: password),
    );

    if (result.isFailure) return Result.failure(result.errorOrEmpty);

    final tokens = result.data!;
    await _secureStorage.saveAccessToken(tokens.accessToken);
    await _secureStorage.saveRefreshToken(tokens.refreshToken);

    // Fetch user profile after login
    final profileResult = await _remoteDataSource.getProfile();
    if (profileResult.isFailure) {
      return Result.failure(profileResult.errorOrEmpty);
    }

    final user = profileResult.data!;
    await _secureStorage.saveUserData(user.toJson());
    return Result.success(user.toEntity());
  }

  @override
  Future<Result<UserEntity>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    String role = 'tenant',
  }) async {
    final result = await _remoteDataSource.register(
      RegisterRequestModel(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        role: role,
      ),
    );

    if (result.isFailure) return Result.failure(result.errorOrEmpty);
    return Result.success(result.data!.toEntity());
  }

  @override
  Future<Result<UserEntity>> getProfile() async {
    final result = await _remoteDataSource.getProfile();
    if (result.isFailure) return Result.failure(result.errorOrEmpty);
    return Result.success(result.data!.toEntity());
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _secureStorage.clearAll();
      return Result.success(null);
    } catch (_) {
      await _secureStorage.clearAll();
      return Result.success(null);
    }
  }

  @override
  Future<Result<String>> getStoredToken() async {
    final token = await _secureStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      return Result.failure('No stored token');
    }
    return Result.success(token);
  }
}
