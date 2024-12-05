import '../screen/login/login_screen.dart';
import '../utils/export_utils.dart';

abstract class BaseState {
  final String message;
  final StatusState statusState;

  const BaseState({this.message = '', this.statusState = StatusState.idle});

  bool get isLoading => statusState == StatusState.loading;
  bool get isSuccess => statusState == StatusState.success;
  bool get isError => statusState == StatusState.failure;
  bool get isIdle => statusState == StatusState.idle;

  void logout() {
    logger.d('function logout called');
    if (isError && message == 'Unauthorized') {
      AppRoute.clearAll(const LoginScreen());
    }
  }
}

enum StatusState { idle, loading, success, failure }
