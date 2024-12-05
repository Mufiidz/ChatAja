import 'package:dart_mappable/dart_mappable.dart';

part 'base_response.mapper.dart';

@MappableClass(ignoreNull: true)
class BaseResponse<T> with BaseResponseMappable<T> {
  final int? statusCode;
  final bool success;
  final String message;
  final T? data;

  BaseResponse({
    this.success = false,
    this.message = '',
    this.data,
    this.statusCode,
  });

  factory BaseResponse.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return BaseResponseMapper.fromJson(json);
    if (json is String) return BaseResponseMapper.fromJsonString(json);
    return throw Exception(
        "The argument type '${json.runtimeType}' can't be assigned");
  }
}
