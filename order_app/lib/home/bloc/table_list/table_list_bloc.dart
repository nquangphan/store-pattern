import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_app/Models/home.model.dart';
import 'package:order_app/Views/cart.view.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/user_repository.dart';

part "table_list_event.dart";
part "table_list_state.dart";

class TableListBloc extends Bloc<TableListEvent, TableListState> {
  TableListBloc() : super(TableListState.LOADING) {
    _startBackgroundTask();
  }

  BehaviorSubject<List<AppTable>> _tableListController =
      BehaviorSubject<List<AppTable>>.seeded(null);

  Stream<List<AppTable>> get tableListStream => _tableListController.stream;

  bool _isStopTimer = false;
  @override
  Stream<TableListState> mapEventToState(
    TableListEvent event,
  ) async* {
    if (event is DoneLoading) {
      yield TableListState.IDLE;
    } else if(event is OpenCart){
      _pushCartScreen(event.table, event.context);
    }
  }

  void _pushCartScreen(AppTable table, BuildContext context) {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) {
        return new Scaffold(
          body: new CartScreen(
            table: table,
            homeContext: context,
            account: RepositoryProvider.of<UserRepository>(context)
                .getCurrentAccount(),
          ),
        );
      }),
    );
  }

  List<AppTable> _getTables() {
    List<AppTable> _tables;
    HomeModel.instance.tables.then((value) {
      if (value != null) {
        _tables = value;
        if (_tableListController.isClosed) {
          _tableListController = BehaviorSubject<List<AppTable>>.seeded(null);
        }
        _tableListController.sink.add(_tables);
        add(DoneLoading());
      } else {
        add(ErrorLoading());
      }
    }).catchError((onError) {
      add(ErrorLoading());
    });

    return _tables;
  }

  void stopBackgroundTask() {
    _isStopTimer = true;
  }

  void closeStream() {}

  void _startBackgroundTask() {
    _isStopTimer = false;
    const oneSec = const Duration(seconds: 5);
    Timer.periodic(oneSec, (Timer t) {
      if (_isStopTimer) {
        t.cancel();
      }
      _getTables();
    });
  }

  @override
  Future<void> close() {
    _tableListController?.close();
    return super.close();
  }
}
