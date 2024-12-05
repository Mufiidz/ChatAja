import 'package:flutter/material.dart';

import '../utils/export_utils.dart';

class SnackbarWidget extends SnackBar {
  final SnackbarState state;
  final String message;
  final Color? textColor;
  final BuildContext context;
  SnackbarWidget(this.message, this.context,
      {super.key,
      this.state = SnackbarState.normal,
      this.textColor,
      super.action,
      super.dismissDirection,
      super.duration})
      : super(
            content: Text(
              message,
              style: TextStyle(color: textColor),
            ),
            backgroundColor: getBackgroundColor(state, context));

  static Color? getBackgroundColor(SnackbarState state, BuildContext context) {
    return switch (state) {
      SnackbarState.success => Colors.green[700],
      SnackbarState.error => context.colorScheme.error,
      _ => null
    };
  }
}

enum SnackbarState { normal, success, error }
