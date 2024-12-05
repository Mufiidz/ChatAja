import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/env.dart';
import '../data/api_services.dart';
import '../utils/export_utils.dart';

@module
@injectable
abstract class AppModule {
  @preResolve
  Future<Dio> dio() async {
    logger.d('Dio Called');

    final SharedPreferences preferences = await prefs;
    final String token =
        preferences.getString(Constants.cookie.toLowerCase()) ?? '';

    final BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
      contentType: ContentType.json.value,
    );

    if (token.isNotEmpty) {
      options.headers[Constants.cookie] = token;
    }

    final Dio dio = Dio(options);

    if (kReleaseMode) return dio;

    final PrettyDioLogger dioLogger = PrettyDioLogger(
        requestHeader: true, requestBody: true, responseBody: true);

    dio.interceptors.addAll(<Interceptor>[dioLogger]);
    return dio;
  }

  ApiServices apiServices(Dio dio) => ApiServices(dio, baseUrl: Constants.baseUrl);

  @singleton
  @preResolve
  Future<SharedPreferences> get prefs async =>
      await SharedPreferences.getInstance();
}
