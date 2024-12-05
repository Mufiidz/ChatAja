import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/injection.dart';
import '../../model/room_chat.dart';
import '../../model/user.dart';
import '../../utils/export_utils.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/list_widget.dart';
import '../../widgets/snackbar_widget.dart';
import '../login/login_screen.dart';
import '../search/search_screen.dart';
import 'cubit/home_cubit.dart';
import 'item_room_chat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeCubit _cubit;

  @override
  void initState() {
    _cubit = getIt<HomeCubit>();
    _cubit.initial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
        Constants.appName,
        showBackButton: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _cubit.logOut(),
          )
        ],
      ),
      body: BlocListener<HomeCubit, HomeState>(
        bloc: _cubit,
        listener: (BuildContext context, HomeState state) {
          if (state.isSuccess && state.isLoggedOut) {
            context.snackbar.showSnackBar(SnackbarWidget(
              'You have been logged out',
              context,
              state: SnackbarState.normal,
            ));
            AppRoute.clearAll(const LoginScreen());
          }

          if (state.isError) {
            context.snackbar.showSnackBar(SnackbarWidget(
              state.message,
              context,
              state: SnackbarState.error,
            ));
          }
        },
        child: StreamBuilder<List<RoomChat>>(
          stream: _cubit.streamRoomChats,
          builder:
              (BuildContext context, AsyncSnapshot<List<RoomChat>> snapshot) {
            logger.d('snapshot: ${snapshot.hasData}');
            final List<RoomChat>? roomChats = snapshot.data;
            logger.d('snapshot: ${snapshot.data}');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (roomChats == null || roomChats.isEmpty) {
              return RefreshIndicator.adaptive(
                  onRefresh: () async => _cubit.onRefresh(),
                  child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        width: context.mediaSize.width,
                        height: context.mediaSize.height - kToolbarHeight,
                        alignment: Alignment.center,
                        child: const Text('No room chat found'),
                      )));
            }
            return RefreshIndicator.adaptive(
              onRefresh: () async => _cubit.onRefresh(),
              child: BlocSelector<HomeCubit, HomeState, User>(
                bloc: _cubit,
                selector: (HomeState state) => state.user,
                builder: (BuildContext context, User state) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: ListWidget<RoomChat>(roomChats,
                        scrollPhysics: const AlwaysScrollableScrollPhysics(),
                        separatorBuilder:
                            (BuildContext context, RoomChat item, int index) =>
                                const SizedBox(
                                  height: 8,
                                ),
                        isSeparated: true,
                        reverse: true,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, RoomChat item,
                                int index) =>
                            ItemRoomChat(roomChat: item, currentUser: state)),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add new chat',
        onPressed: () => AppRoute.to(const SearchScreen()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
