import 'dart:async';

import 'package:app/controller/user/bloc/user_bloc.dart';
import 'package:app/mixin/app_util.dart';
import 'package:app/style/m_button.dart';
import 'package:app/style/m_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AppUtil {
  late UserBloc _userBloc;
  late ScrollController _scrollController;
  late Completer<void> _refreshCompleter;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();

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
    _nameController.addListener(() {
      _userBloc.add(UserEventAddField(name: _nameController.text.trim()));
    });
    _jobController.addListener(() {
      _userBloc.add(UserEventAddField(job: _jobController.text.trim()));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobController.dispose();
    super.dispose();
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
              } else if (state is UserStateAddSuccess) {
                _showDialog(
                  message: localize('add_user_success_dialog_title'),
                  isBack: true,
                );
              } else if (state is UserStateListError) {
                _showDialog(message: state.message);
              } else if (state is UserStateAddError) {
                _showDialog(message: state.message);
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

  void _showDialog({
    required String message,
    bool isBack = false,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    ).then((_) {
      if (isBack) {
        popPage(context);
      }
    });
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: _userBloc,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MForm(
                  controller: _nameController,
                  label: const Text(
                    'name',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                MForm(
                  controller: _jobController,
                  label: const Text(
                    'job',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<UserBloc, UserState>(
                    buildWhen: (_, current) => current is UserStateFieldChecked,
                    builder: (context, state) {
                      final isChecked = state is UserStateFieldChecked && state.isChecked;
                      return MButton(
                        onPressed: !isChecked
                            ? null
                            : () {
                                _userBloc.add(UserEventAddRequest());
                              },
                        backgroundColor: !isChecked ? Colors.grey : Colors.purple[400],
                        label: Text(
                          localize('add_user_title_button'),
                          style: TextStyle(
                            color: !isChecked ? Colors.black : Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _nameController.clear();
      _jobController.clear();
    });
  }
}
