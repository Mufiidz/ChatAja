part of 'login_cubit.dart';

@MappableClass()
class LoginState extends BaseState with LoginStateMappable {
  final User? user;

  LoginState({super.message, super.statusState, this.user});
}
