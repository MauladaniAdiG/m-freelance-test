part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

final class UserEventLoadList extends UserEvent {
  final bool loadMore;
  final bool refresh;
  const UserEventLoadList({
    this.loadMore = false,
    this.refresh = false,
  });

  @override
  List<Object> get props => [loadMore, refresh];
}
