import 'package:flutter/material.dart';

extension ThemeExt on ThemeData {
  bool get isDark => brightness == Brightness.dark;
}