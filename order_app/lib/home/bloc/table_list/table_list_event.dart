part of 'table_list_bloc.dart';

abstract class TableListEvent extends Equatable {
  const TableListEvent();

  @override
  List<Object> get props => [];
}

class OpenCart extends TableListEvent {
  const OpenCart(this.table, this.context);

  final AppTable table;
  final BuildContext context;

  @override
  List<Object> get props => [table];
}

class ErrorLoading extends TableListEvent {
  const ErrorLoading();
}


class DoneLoading extends TableListEvent {
  const DoneLoading();
}
