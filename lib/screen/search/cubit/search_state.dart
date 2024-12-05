part of 'search_cubit.dart';

@MappableClass()
class SearchState extends BaseState with SearchStateMappable {
  final String? query;
  final List<User> users;

  SearchState(
      {super.message,
      super.statusState,
      this.query,
      this.users = const <User>[]});
}
