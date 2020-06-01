import 'package:rxdart/rxdart.dart';

import './../Models/home.model.dart';
import 'dart:async';

class Controller {
  BehaviorSubject<List<Table>> _tableListController =
      BehaviorSubject<List<Table>>.seeded(null);

  Stream<List<Table>> get tableListStream => _tableListController.stream;

  static Controller _instance;

  bool isStopTimer = false;

  static Controller get instance {
    if (_instance == null) _instance = new Controller();
    return _instance;
  }

  void stopBackgroundTask() {
    isStopTimer = true;
  }

  void closeStream() {
    _tableListController?.close();
  }

  void startBackgroundTask() {
    isStopTimer = false;
    const oneSec = const Duration(seconds: 5);
    Timer.periodic(oneSec, (Timer t) {
      if (isStopTimer) {
        t.cancel();
      }
      getTables();
    });
  }

  List<Table> getTables() {
    List<Table> _tables;
    if (_tables == null) {
      Model.instance.tables.then((value) {
        _tables = value;
        if(_tableListController.isClosed){
          _tableListController = BehaviorSubject<List<Table>>.seeded(null);
        }
        _tableListController.sink.add(_tables);
      });
    }

    return _tables;
  }
}
