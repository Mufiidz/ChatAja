import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env.dev', useConstantCase: true)
abstract class Env {
  @EnviedField()
  static const String baseUrlAndroid = _Env.baseUrlAndroid;

  @EnviedField()
  static const String baseUrlIos = _Env.baseUrlIos;

  @EnviedField()
  static const String socketUrlAndroid = _Env.socketUrlAndroid;

  @EnviedField()
  static const String socketUrlIos = _Env.socketUrlIos;
}
