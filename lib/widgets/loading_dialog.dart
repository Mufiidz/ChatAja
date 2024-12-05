import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../utils/export_utils.dart';

@singleton
class LoadingDialog {
  bool isShown = false;

  LoadingDialog();

  void show(BuildContext context, bool isLoading, {bool dismissable = false}) {
    return isLoading
        ? showLoading(context, dismissable: dismissable)
        : dismiss();
  }

  void showLoading(BuildContext context, {bool dismissable = false}) {
    if (isShown) return;
    isShown = true;
    showDialog(
        context: context,
        barrierDismissible: dismissable,
        builder: (BuildContext context) => PopScope(
            canPop: dismissable,
            onPopInvokedWithResult: (bool didPop, dynamic result) => dismiss(),
            child: Center(
                child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                        color: context.colorScheme.surface,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircularProgressIndicator.adaptive(),
                      ],
                    )))));
  }

  void dismiss() {
    if (isShown == false) return;
    isShown = false;
    AppRoute.back();
  }
}