import 'dart:async';

import 'package:app/controller/user/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserBloc _userBloc;
  late ScrollController _scrollController;
  late Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          _userBloc.add(const UserEventLoadList(loadMore: true));
        }
      });
    _refreshCompleter = Completer<void>();
    _userBloc.add(const UserEventLoadList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userBloc,
      child: RefreshIndicator(
        onRefresh: () {
          _userBloc.add(const UserEventLoadList(refresh: true));
          return _refreshCompleter.future;
        },
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showModalBottomSheet();
            },
            child: const Icon(Icons.add),
          ),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: AppBar(),
          ),
          body: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserStateListLoaded) {
                if (state.isRefresh) {
                  _refreshCompleter.complete();
                  _refreshCompleter = Completer<void>();
                }
              }
            },
            builder: (context, state) {
              if (state is UserStateListLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: _userBloc.userListResponse.length,
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                itemBuilder: (context, i) {
                  final user = _userBloc.userListResponse[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 36.0,
                        ),
                        const SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.email,
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              user.firstName,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container();
      },
    );
  }
}
