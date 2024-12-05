import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/injection.dart';
import '../../model/user.dart';
import '../../utils/export_utils.dart';
import '../../widgets/list_widget.dart';
import '../chat/chat_screen.dart';
import 'cubit/search_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer? _debouncer;
  final TextEditingController _controller = TextEditingController();
  late final SearchCubit _cubit;

  @override
  void initState() {
    _cubit = getIt<SearchCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SearchBar(
              controller: _controller,
              hintText: 'Username',
              onChanged: _onSearchChanged,
              onSubmitted: (String value) {
                if (value.isEmpty) return;
                _cubit.searchUser(value);
              },
              leading: IconButton(
                  onPressed: AppRoute.back,
                  icon: Icon(Platform.isAndroid
                      ? Icons.arrow_back
                      : Icons.arrow_back_ios_new)),
              trailing: <Widget>[
                IconButton(
                    onPressed: () => _controller.clear(),
                    icon: const Icon(Icons.clear))
              ],
              backgroundColor:
                  WidgetStatePropertyAll<Color?>(context.colorScheme.surface),
              elevation: const WidgetStatePropertyAll<double?>(0),
              shape: const WidgetStatePropertyAll<OutlinedBorder?>(
                  RoundedRectangleBorder()),
            ),
            Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
              bloc: _cubit,
              builder: (BuildContext context, SearchState state) {
                if (state.isLoading) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
                if (state.users.isEmpty || state.isError) {
                  return const Center(child: Text('Not found'));
                }
                return RefreshIndicator.adaptive(
                  onRefresh: () async => _cubit.searchUser(_controller.text),
                  child: ListWidget<User>(
                    state.users,
                    scrollPhysics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, User item, int index) {
                      final User(:String? username, :String email, :int? id) =
                          item;
                      return ListTile(
                        title: Text(username ?? '-'),
                        subtitle: Text(email),
                        leading: CircleAvatar(
                          child: Text(username?.substring(0, 1) ?? '-'),
                        ),
                        onTap: () {
                          if (id == null || id < 0) return;
                          AppRoute.to(ChatScreen(
                            user: item,
                          ));
                        },
                      );
                    },
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }

  void _onSearchChanged(String value) {
    if (_debouncer?.isActive ?? false) {
      _debouncer?.cancel();
    }

    _debouncer = Timer(const Duration(seconds: 1), () {
      if (value.isEmpty) return;
      _cubit.searchUser(value);
    });
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
