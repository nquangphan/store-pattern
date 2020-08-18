part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class OpenTableDetail extends HomeEvent {
  const OpenTableDetail();
}


class DoneLoading extends HomeEvent {
  const DoneLoading(this.account);

  final Account account;
}


class ErrorLoading extends HomeEvent {
  const ErrorLoading();
}