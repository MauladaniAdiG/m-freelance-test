part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
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

final class UserEventAddField extends UserEvent {
  final String? name;
  final String? job;
  const UserEventAddField({
    this.name,
    this.job,
  });
  @override
  List<Object?> get props => [name, job];
}

final class UserEventAddRequest extends UserEvent {}
