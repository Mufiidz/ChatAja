import 'dart:io';

import '../config/env.dart';

class Constants {
  static const String appName = 'ChatAja';
  static const String cookie = 'Cookie';
  static String baseUrl = Platform.isAndroid ? Env.baseUrlAndroid : Env.baseUrlIos;
  static String socketUrl = Platform.isAndroid ? Env.socketUrlAndroid : Env.socketUrlIos;
}
