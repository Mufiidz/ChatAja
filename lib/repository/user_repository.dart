import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api_services.dart';
import '../data/base_result.dart';
import '../model/user.dart';
import '../utils/export_utils.dart';

abstract class UserRepository {
  Future<BaseResult<User>> login(User user);
  Future<BaseResult<User>> register(User user);
  Future<BaseResult<User>> getUser();
  Future<BaseResult<List<User>>> searchUser(String query);
  Future<bool> logout();
}

@Injectable(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final ApiServices _apiServices;
  final Dio _dio;
  final SharedPreferences _sharedPreferences;
  final String cookieKey = Constants.cookie.toLowerCase();

  UserRepositoryImpl(this._apiServices, this._dio, this._sharedPreferences);

  @override
  Future<BaseResult<User>> getUser() async {
    final String? cookie = _sharedPreferences.getString(cookieKey);
    if (cookie == null) {
      return ErrorResult<User>('Unauthorized');
    }
    final BaseResult<User> response =
        await _apiServices.getUser().awaitResponse;

    logger.d('userCheck: $response');

    if (!response.isSuccess && response.errorResult.statusCode == 401) {
      logger.d('userCheck: Unauthorized');
      _sharedPreferences.remove(cookieKey);
      _dio.options.headers.remove(Constants.cookie);
    }
    return response;
  }

  @override
  Future<BaseResult<User>> login(User user) async {
    final BaseResult<User> response =
        await _apiServices.login(user).awaitResponse;

    String? token;

    if (response.isSuccess) {
      token = response.onDataResult.token;
    }

    if (token != null) {
      final String cookie = 'token=$token';
      _sharedPreferences.setString(cookieKey, cookie);
      logger.d('cookie => $cookie');
      _dio.options.headers[Constants.cookie] = cookie;
    }
    return response;
  }

  @override
  Future<BaseResult<User>> register(User user) =>
      _apiServices.register(user).awaitResponse;

  @override
  Future<bool> logout() => Future<bool>.delayed(
      const Duration(seconds: 3), () => _sharedPreferences.remove(cookieKey));

  @override
  Future<BaseResult<List<User>>> searchUser(String query) async {
    final BaseResult<List<User>> response =
        await _apiServices.searchUser(query).awaitResponse;

    List<User> users = response.onDataResult;

    if (users.isNotEmpty) {
      return DataResult<List<User>>(users.sorted((User a, User b) =>
          (a.username ?? '-').compareTo(b.username ?? '-')));
    }
    return response;
  }
}
