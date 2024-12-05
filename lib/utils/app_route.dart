import 'package:flutter/cupertino.dart';

class AppRoute {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState get navigator => navigatorKey.currentState!;

  static Future to(
    Widget route, {
    RouteSettings? settings,
  }) {
    return navigator.push(CupertinoPageRoute(
        builder: (BuildContext context) => route, settings: settings));
  }

  static Future clearTopTo(
    Widget route,
  ) {
    return navigator.pushReplacement(
        CupertinoPageRoute(builder: (BuildContext context) => route));
  }

  static Future clearAll(
    Widget route,
  ) {
    return navigator.pushAndRemoveUntil(
        CupertinoPageRoute(builder: (BuildContext context) => route),
        (Route route) => false);
  }

  static void popUntil(String title) {
    return navigator.popUntil(ModalRoute.withName(title));
  }

  static void back<T extends Object?>([
    T? result,
  ]) {
    return navigator.pop(result);
  }
}