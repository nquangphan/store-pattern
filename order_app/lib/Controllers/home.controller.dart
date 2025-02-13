import 'dart:convert';
import 'dart:io';

import 'package:get_ip/get_ip.dart';
import 'package:order_app/Models/connectServer.dart';
import 'package:rxdart/rxdart.dart';

import './../Models/home.model.dart';
import 'dart:async';

class HomeController {
  BehaviorSubject<List<AppTable>> _tableListController =
      BehaviorSubject<List<AppTable>>.seeded(null);

  Stream<List<AppTable>> get tableListStream => _tableListController.stream;

  BehaviorSubject<bool> _isLoading = BehaviorSubject<bool>.seeded(null);

  Stream<bool> get isLoading => _isLoading.stream;

  static HomeController _instance;
  static bool isLoadAppSuccess = true;

  bool isStopTimer = false;

  static HomeController get instance {
    if (_instance == null) _instance = new HomeController();
    return _instance;
  }

  void stopBackgroundTask() {
    isStopTimer = true;
  }

  void closeStream() {
    _tableListController?.close();
    _isLoading?.close();
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

  List<AppTable> getTables() {
    List<AppTable> _tables;
    if (_tables == null) {
      HomeModel.instance.tables.then((value) {
        _tables = value;
        if (_tableListController.isClosed) {
          _tableListController = BehaviorSubject<List<AppTable>>.seeded(null);
        }
        _tableListController.sink.add(_tables);
      });
    }

    return _tables;
  }

  void getServerIp({Function onLoadSuccess}) {
      MySqlConnection.instance.serverURL =
        'http://http://10.1.32.163/:8090/bluecoffee/index.php';
        onLoadSuccess();
    return;
    var DESTINATION_ADDRESS = InternetAddress("255.255.255.255");
    _isLoading.sink.add(true);
    String ipAddress = '';
    GetIp.ipAddress.then((value) {
      ipAddress = value;
      RawDatagramSocket.bind(InternetAddress.anyIPv4, 2003)
          .then((RawDatagramSocket udpSocket) {
        udpSocket.broadcastEnabled = true;
        udpSocket.listen((e) {
          Datagram dg = udpSocket.receive();
          if (dg != null) {
            String s = new String.fromCharCodes(dg.data);
            if (s == ipAddress) {
              String serverIP = dg.address.address;
              print("received $s");
              print('Ip address: ' + dg.address.address);
              // printTicket(serverIP, 2004);
              MySqlConnection.instance.serverURL =
                  'http://' +serverIP + ':8090/bluecoffee/index.php';
              _isLoading.sink.add(false);
              onLoadSuccess();
              udpSocket.close();
            }
          }
        });
        List<int> data = utf8.encode('TEST');
        udpSocket.send(data, DESTINATION_ADDRESS, 2003);
      });
    }).catchError((onError) {
      isLoadAppSuccess = false;
    });
  }
}
