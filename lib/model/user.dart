import 'package:dart_mappable/dart_mappable.dart';

part 'user.mapper.dart';

@MappableClass()
class User with UserMappable {
  final int? id;
  final String? username;
  final String email;
  final String password;
  final String? token;

  const User({
    this.id,
    this.username,
    this.email = '',
    this.password = '',
    this.token,
  });

  factory User.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) return UserMapper.fromJson(json);
    if (json is String) return UserMapper.fromJsonString(json);
    return throw Exception(
        "The argument type '${json.runtimeType}' can't be assigned");
  }
}
