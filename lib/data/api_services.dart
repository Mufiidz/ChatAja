import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../model/user.dart';
import '../utils/constants.dart';
import '../utils/endpoint.dart';
import 'base_response.dart';
import 'chat_response.dart';

part 'api_services.g.dart';

@RestApi()
abstract class ApiServices {
  @factoryMethod
  factory ApiServices(@factoryParam Dio dio, {@factoryParam String baseUrl}) =
      _ApiServices;

  @POST(Endpoint.register)
  Future<User> register(@Body() User user);

  @POST(Endpoint.login)
  Future<BaseResponse<User>> login(@Body() User user);

  @GET(Endpoint.currentUser)
  Future<User> getUser({@Header(Constants.cookie) String? token});

  @GET(Endpoint.searchUser)
  Future<BaseResponse<List<User>>> searchUser(@Query('q') String? query);

  @GET(Endpoint.message)
  Future<BaseResponse<ChatResponse>> getMessages({@Query('id') int? id});
}
