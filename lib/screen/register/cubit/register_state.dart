part of 'register_cubit.dart';

@MappableClass()
class RegisterState extends BaseState with RegisterStateMappable {
  final User? user;

  RegisterState({super.message, super.statusState, this.user});
}
