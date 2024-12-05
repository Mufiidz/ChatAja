import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_result.dart';
import '../../../data/base_state.dart';
import '../../../model/user.dart';
import '../../../repository/user_repository.dart';

part 'login_state.dart';
part 'login_cubit.mapper.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final UserRepository _userRepository;
  LoginCubit(this._userRepository) : super(LoginState());

  void login(User user) async {
    emit(state.copyWith(statusState: StatusState.loading));

    final BaseResult<User> result = await _userRepository.login(user);

    final LoginState newState = result.when(
      result: (User user) =>
          state.copyWith(statusState: StatusState.success, user: user),
      error: (String message) =>
          state.copyWith(statusState: StatusState.failure, message: message),
    );

    emit(newState);
  }
}
