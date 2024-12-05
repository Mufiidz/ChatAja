import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  Size get mediaSize => MediaQuery.of(this).size;
  ScaffoldMessengerState get snackbar => ScaffoldMessenger.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  bool get isDark => theme.brightness == Brightness.dark;
  FocusScopeNode get focusScope => FocusScope.of(this);
}