
import 'dart:io';

import 'package:flutter/material.dart';

import '../../utils/app_route.dart';

class BackButtonWidget extends StatelessWidget {
  final Function()? onClick;
  final Color? color;
  const BackButtonWidget({super.key, this.onClick, this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onClick ?? (() => AppRoute.back()),
        icon: Icon(
          Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
          color: color,
        ));
  }
}
