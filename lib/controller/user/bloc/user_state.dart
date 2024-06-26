part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

final class UserStateListLoaded extends UserState {
  final bool isRefresh;
  final int timestamp;
  UserStateListLoaded({this.isRefresh = false}) : timestamp = DateTime.now().millisecondsSinceEpoch;
  @override
  List<Object> get props => [isRefresh, timestamp];
}

final class UserStateListLoading extends UserState {}

final class UserStateListError extends UserState {
  final String message;
  final int timestamp;
  UserStateListError(this.message) : timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object> get props => [message, timestamp];
}

final class UserStateFieldChecked extends UserState {
  final bool isChecked;
  const UserStateFieldChecked({this.isChecked = false});
  @override
  List<Object> get props => [isChecked];
}

final class UserStateAddSuccess extends UserState {
  final int timestamp;
  UserStateAddSuccess() : timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object> get props => [timestamp];
}

final class UserStateAddError extends UserState {
  final String message;
  final int timestamp;
  UserStateAddError(this.message) : timestamp = DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object> get props => [message, timestamp];
}
