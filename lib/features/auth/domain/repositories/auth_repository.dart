import '../../../../core/network/result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Result<UserEntity>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    String role = 'tenant',
  });

  Future<Result<UserEntity>> getProfile();

  Future<Result<void>> logout();

  Future<Result<String>> getStoredToken();
}
