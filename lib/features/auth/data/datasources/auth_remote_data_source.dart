import '../../../../core/network/api_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/token_pair_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Result<TokenPairModel>> login(LoginRequestModel request);
  Future<Result<UserModel>> register(RegisterRequestModel request);
  Future<Result<UserModel>> getProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Result<TokenPairModel>> login(LoginRequestModel request) {
    return _apiClient.post<TokenPairModel>(
      endpoint: ApiConstants.login,
      data: request.toJson(),
      parser: (data) => TokenPairModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<UserModel>> register(RegisterRequestModel request) {
    return _apiClient.post<UserModel>(
      endpoint: ApiConstants.register,
      data: request.toJson(),
      parser: (data) => UserModel.fromJson(data as Map<String, dynamic>),
    );
  }

  @override
  Future<Result<UserModel>> getProfile() {
    return _apiClient.get<UserModel>(
      endpoint: ApiConstants.me,
      parser: (data) => UserModel.fromJson(data as Map<String, dynamic>),
    );
  }
}
