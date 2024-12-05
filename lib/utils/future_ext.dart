import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../data/base_response.dart';
import '../data/base_result.dart';
import '../res/locale_keys.g.dart';
import 'export_utils.dart';

extension FutureExt<T> on Future<BaseResponse<T>> {
  Future<BaseResult<T>> get awaitResponse async {
    try {
      final BaseResponse<T> response = await this;
      logger.d('response: $response');
      final T? data = response.data;

      if (data == null) {
        logger.e('response: data is null');
        return ErrorResult<T>(LocaleKeys.empty_data.tr());
      }
      logger.d('response: $data');
      return DataResult<T>(data);
    } on DioException catch (dioException) {
      final Response<dynamic>? response = dioException.response;
      final DioExceptionType errorType = dioException.type;

      if (errorType == DioExceptionType.connectionTimeout) {
        return ErrorResult<T>(LocaleKeys.connection_timeout.tr());
      }

      if (errorType == DioExceptionType.connectionError) {
        return ErrorResult<T>(LocaleKeys.connection_error.tr());
      }

      logger
        ..e('response error: $response')
        ..e('response msg: ${dioException.message}');

      if (response == null) {
        return ErrorResult<T>(
            dioException.message ?? LocaleKeys.empty_response.tr());
      }

      // Convert here for error response
      logger.d('response.data: ${response.data.toString()}');
      // ignore: always_specify_types
      BaseResponse errorResponse = BaseResponse.fromJson(response.data);

      return ErrorResult<T>(errorResponse.message);
    } catch (e) {
      logger.e('response e: $e');
      return ErrorResult<T>(e.toString());
    }
  }
}

extension FutureExt2<T> on Future<T> {
  Future<BaseResult<T>> get awaitResponse async {
    try {
      final T? data = await this;

      if (data == null) {
        logger.e('response: data is null');
        return ErrorResult<T>(LocaleKeys.empty_data.tr());
      }
      logger.d('response: $data');
      return DataResult<T>(data);
    } on DioException catch (dioException) {
      final Response<dynamic>? response = dioException.response;
      final DioExceptionType errorType = dioException.type;

      if (errorType == DioExceptionType.connectionTimeout) {
        return ErrorResult<T>(LocaleKeys.connection_timeout.tr());
      }

      if (errorType == DioExceptionType.connectionError) {
        logger.e('response: ${dioException.message}');
        return ErrorResult<T>(LocaleKeys.connection_error.tr());
      }

      logger
        ..e('response(${response?.statusCode.toString()}): $response')
        ..e('response: ${dioException.message}');

      if (response == null) {
        return ErrorResult<T>(
            dioException.message ?? LocaleKeys.empty_response.tr());
      }

      // Convert here for error response
      logger.d('response.data: ${response.data.toString()}');
      // ignore: always_specify_types
      BaseResponse errorResponse = BaseResponse.fromJson(response.data);
      errorResponse = errorResponse.copyWith(statusCode: response.statusCode);

      return ErrorResult<T>(errorResponse.message,
          statusCode: errorResponse.statusCode);
    } catch (e) {
      return ErrorResult<T>(e.toString());
    }
  }
}
