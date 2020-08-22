import 'dart:convert';
import 'dart:io';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:get_ip/get_ip.dart';

import '../Models/connectServer.dart';
import './../Models/login.model.dart';

class Controller {
  static Controller _instance;

  Account account;

  static Controller get instance {
    if (_instance == null) _instance = new Controller();
    return _instance;
  }

  Future<bool> login(String username, String password) async {
    if (account == null || account.username != username)
      account = await Model.instance.login(username);
    return account != null ? true : false;
  }

  void getServerIp({Function onLoadSuccess}) {
    var DESTINATION_ADDRESS = InternetAddress("255.255.255.255");
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
                  'http://' + serverIP + ':8090/bluecoffee/index.php';
              onLoadSuccess();
              udpSocket.close();
            }
          }
        });
        List<int> data = utf8.encode('TEST');
        udpSocket.send(data, DESTINATION_ADDRESS, 2003);
      });
    }).catchError((onError) {});
  }
}
