import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_result.dart';
import '../../../data/base_state.dart';
import '../../../model/user.dart';
import '../../../repository/user_repository.dart';

part 'splash_state.dart';
part 'splash_cubit.mapper.dart';

@injectable
class SplashCubit extends Cubit<SplashState> {
  final UserRepository _userRepository;
  SplashCubit(this._userRepository) : super(SplashState());

  void initial() async {
    emit(state.copyWith(statusState: StatusState.loading));

    final BaseResult<User?> result = await _userRepository.getUser();

    final SplashState newState = result.when(
      result: (User? user) =>
          state.copyWith(statusState: StatusState.success),
      error: (String message) =>
          state.copyWith(statusState: StatusState.failure, message: message),
    );

    emit(newState);
  }
}
