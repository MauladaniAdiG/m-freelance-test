import 'package:app/model/user/user_list_request.dart';
import 'package:app/model/user/user_list_response.dart';
import 'package:app/service/user_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserEventLoadList>(_mapUserLoadList);
  }

  int _page = 1;
  final int _limit = 10;
  bool _lastPageReached = false;

  final _userService = UserService(Client());
  List<UserResponse> userListResponse = [];

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
}
