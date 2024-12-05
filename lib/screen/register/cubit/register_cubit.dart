import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_result.dart';
import '../../../data/base_state.dart';
import '../../../model/user.dart';
import '../../../repository/user_repository.dart';

part 'register_state.dart';
part 'register_cubit.mapper.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final UserRepository _userRepository;
  RegisterCubit(this._userRepository) : super(RegisterState());

  void register(User user) async {
    emit(state.copyWith(statusState: StatusState.loading));

    final BaseResult<User> result = await _userRepository.register(user);

    final RegisterState newState = result.when(
      result: (User user) => state.copyWith(
          statusState: StatusState.success,
          user: user,
          message: 'Register Success'),
      error: (String message) =>
          state.copyWith(statusState: StatusState.failure, message: message),
    );

    emit(newState);
  }
}
