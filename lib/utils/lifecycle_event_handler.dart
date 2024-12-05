import 'package:flutter/material.dart';

import 'export_utils.dart';

abstract class LifecycleEventHandler<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    logger.d('LifecycleEventHandler initState');
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    logger.d('LifecycleEventHandler dispose');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.d('LifecycleEventHandler didChangeAppLifecycleState: $state');
    return switch (state) {
      AppLifecycleState.resumed => onResumed(),
      AppLifecycleState.inactive => onInactive(),
      AppLifecycleState.paused => onPaused(),
      AppLifecycleState.detached => onDetached(),
      AppLifecycleState.hidden => onInactive(),
    };
  }

  void onResumed() {
    logger.d('LifecycleEventHandler onResumed');
  }

  void onInactive() {
    logger.d('LifecycleEventHandler onInactive');
  }

  void onPaused() {
    logger.d('LifecycleEventHandler onPaused');
  }

  void onDetached() {
    logger.d('LifecycleEventHandler onDetached');
  }
}