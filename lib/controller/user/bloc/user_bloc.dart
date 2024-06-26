import 'package:app/model/user/user_list_request.dart';
import 'package:app/model/user/user_list_response.dart';
import 'package:app/model/user/user_post_request.dart';
import 'package:app/service/user_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserEventLoadList>(_mapUserLoadList);
    on<UserEventAddField>(_mapUserAddField);
    on<UserEventAddRequest>(_mapUserRequestAdd);
  }

  int _page = 1;
  final int _limit = 10;
  bool _lastPageReached = false;

  final _userService = UserService(Client());
  List<UserResponse> userListResponse = [];

  String? _name;
  String? _job;

  Future<void> _mapUserLoadList(
    UserEventLoadList event,
    Emitter<UserState> emit,
  ) async {
    try {
      if (event.refresh) {
        _page = 1;
        _lastPageReached = false;
        userListResponse = [];
      }
      if (_lastPageReached) return;
      if (!event.loadMore) emit(UserStateListLoading());
      final request = UserListRequest(
        page: _page,
        limit: _limit,
      );
      final response = await _userService.requestLoadUserList(request);
      userListResponse.addAll(response.userList);
      emit(UserStateListLoaded(isRefresh: event.refresh));
      if (response.userList.length < _limit) {
        _lastPageReached = true;
        return;
      }
      _page++;
    } catch (e) {
      emit(UserStateListError(e.toString()));
    }
  }

  Future<void> _mapUserAddField(
    UserEventAddField event,
    Emitter<UserState> emit,
  ) async {
    _name = event.name ?? _name;
    _job = event.job ?? _job;
    final isChecked = (_name?.isNotEmpty ?? false) && (_job?.isNotEmpty ?? false);
    emit(UserStateFieldChecked(isChecked: isChecked));
  }

  Future<void> _mapUserRequestAdd(
    UserEventAddRequest event,
    Emitter<UserState> emit,
  ) async {
    try {
      final request = UserPostRequest(name: _name ?? '', job: _job ?? '');
      final response = await _userService.requestAddUser(request);
      emit(UserStateAddSuccess());
      response.firstName = response.name;
      response.email = '${response.name}@gmail.com';
      userListResponse.add(response);
      emit(UserStateListLoaded());
    } catch (e) {
      emit(UserStateAddError(e.toString()));
    }
  }
}
