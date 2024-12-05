import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_result.dart';
import '../../../data/base_state.dart';
import '../../../model/user.dart';
import '../../../repository/user_repository.dart';

part 'search_state.dart';
part 'search_cubit.mapper.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  final UserRepository _userRepository;
  SearchCubit(this._userRepository) : super(SearchState());

  void searchUser(String? query) async {
    emit(state.copyWith(statusState: StatusState.loading));

    if (query == null) {
      emit(state.copyWith(statusState: StatusState.idle));
      return;
    }

    final BaseResult<List<User>> result =
        await _userRepository.searchUser(query);

    final SearchState newState = result.when(
      result: (List<User> users) =>
          state.copyWith(statusState: StatusState.idle, users: users),
      error: (String message) => state.copyWith(
          statusState: StatusState.failure, message: message, users: <User>[]),
    );

    emit(newState);
  }
}
