import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';
import 'package:intl/intl.dart';
import 'package:order_app/Models/connectServer.dart';
import 'package:order_app/Models/drink_model.dart';
import 'package:order_app/Models/home.model.dart' as HomeModel;
import 'package:order_app/Models/order_item.dart';
import 'package:order_app/Models/table_model.dart';
import './../Models/home.model.dart' as home;
import './../Models/cart.model.dart';
import './../Constants/theme.dart' as theme;

class Controller {
  bool isSend = false;

  static Controller _instance;

  static Controller get instance {
    if (_instance == null) _instance = new Controller();
    return _instance;
  }

  Future<bool> insertBill(
      int idTable,
      DateTime dateCheckIn,
      DateTime dateCheckOut,
      double discount,
      double totalPrice,
      int status,
      String username) {
    return Model.instance.insertBill(idTable, dateCheckIn, dateCheckOut,
        discount, totalPrice, status, username);
  }

  Future<bool> updateBill(
      int id,
      int idTable,
      DateTime dateCheckIn,
      DateTime dateCheckOut,
      double discount,
      double totalPrice,
      int status,
      String username) {
    return Model.instance.updateBill(id, idTable, dateCheckIn, dateCheckOut,
        discount, totalPrice, status, username);
  }

  Future<int> getIdBillMax() {
    return Model.instance.getIdBillMax();
  }

  Future<bool> hasBillOfTable(int idTable) {
    return Model.instance.hasBillOfTable(idTable);
  }

  Future<int> getIdBillByTable(int idTable) {
    return Model.instance.getIdBillByTable(idTable);
  }

  Future<bool> insertBillDetail(int idBill, int idFood, int quantity) {
    return Model.instance.insertBillDetail(idBill, idFood, quantity);
  }

  Future<bool> updateBillDetail(int idBill, int idFood, int quantity) {
    return Model.instance.updateBillDetail(idBill, idFood, quantity);
  }

  Future<bool> hasBillDetailOfBill(int idBill, int idFood) {
    return Model.instance.hasBillDetailOfBill(idBill, idFood);
  }

  void findPrinterAndPrintTicket(HomeModel.Table table) {
    printTicket(
        MySqlConnection.instance.serverIP, 2004, getTableForPrinter(table));
    // var DESTINATION_ADDRESS = InternetAddress("255.255.255.255");
    // String ipAddress = '';
    // GetIp.ipAddress.then((value) {
    //   ipAddress = value;
    //   RawDatagramSocket.bind(InternetAddress.anyIPv4, 2003)
    //       .then((RawDatagramSocket udpSocket) {
    //     udpSocket.broadcastEnabled = true;
    //     udpSocket.listen((e) {
    //       Datagram dg = udpSocket.receive();
    //       if (dg != null) {
    //         String s = new String.fromCharCodes(dg.data);
    //         if (s == ipAddress) {
    //           String serverIP = dg.address.address;
    //           print("received $s");
    //           print('Ip address: ' + dg.address.address);

    //           printTicket(MySqlConnection.instance.serverIP, 2004, getTableForPrinter(table));
    //           udpSocket.close();
    //         }
    //       }
    //     });
    //     List<int> data = utf8.encode('TEST');
    //     udpSocket.send(data, DESTINATION_ADDRESS, 2003);
    //   });
    // });
  }

  TableModel getTableForPrinter(HomeModel.Table table) {
    TableModel tableForPrinter = TableModel();

    tableForPrinter.id = table.id.toString();
    tableForPrinter.date = table.dateCheckIn.toString();
    tableForPrinter.tableNumber = table.name;
    tableForPrinter.orderItems = List<OrderItem>();
    table.foods.forEach((element) {
      OrderItem orderItem = OrderItem(
        drink: DrinkModel(name: element.name, price: element.price),
        quantity: element.quantity,
      );
      tableForPrinter.orderItems.add(orderItem);
    });
    return tableForPrinter;
  }

  Future<void> printTicket(String ipPrinter, int port, TableModel table) async {
    Socket.connect(ipPrinter, port, timeout: Duration(seconds: 5))
        .then((socket) {
      socket.add(
          convertCodeUnitsToUnicodeByteArray(json.encode(table).codeUnits));
      socket.destroy();
    });
  }

  List<int> convertCodeUnitsToUnicodeByteArray(List<int> codeUnits) {
    ByteBuffer buffer = new Uint8List(codeUnits.length * 2).buffer;
    ByteData bdata = new ByteData.view(buffer);
    int pos = 0;
    for (int val in codeUnits) {
      bdata.setInt16(pos, val, Endian.little);
      pos += 2;
    }
    return bdata.buffer.asUint8List();
  }

  static Future<void> _sendFailed(String tableName, BuildContext context) {
    String message = 'Gửi ' +
        tableName +
        ' tới pha chế không thành công.\nVui lòng thử lại!';
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Lỗi', style: theme.errorTitleStyle),
            content: new Text(message, style: theme.contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok', style: theme.okButtonStyle),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  static Future<void> _sendSuccess(String tablename, BuildContext context) {
    return Future.value(true);
    // String message = 'Gửi ' + tablename + ' tới pha chế thành công.';
    // return showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: new Text('Thông báo', style: theme.titleStyle),
    //         content: new Text(message, style: theme.contentStyle),
    //         actions: <Widget>[
    //           new FlatButton(
    //             child: new Text('Ok', style: theme.okButtonStyle),
    //             onPressed: () async {
    //               Navigator.of(context).pop();
    //             },
    //           )
    //         ],
    //       );
    //     });
  }

  static Future<bool> sendBillToKitchen(
      home.Table table, BuildContext context) async {
    {
      if (table.foods == null || table.foods.length == 0) return false;
      // Navigator.of(context).pop();
      Controller.instance.isSend = false;
      if (await Controller.instance.hasBillOfTable(table.id)) {
        // exists bill
        int idBill = await Controller.instance.getIdBillByTable(table.id);
        if (await Controller.instance.updateBill(
            idBill,
            table.id,
            table.dateCheckIn,
            DateTime.parse(new DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
                .format(DateTime.now())),
            0,
            table.getTotalPrice(),
            0,
            'test')) {
          for (var food in table.foods) {
            if (await Controller.instance
                .hasBillDetailOfBill(idBill, food.id)) {
              // exists billdetail
              if (await Controller.instance
                      .updateBillDetail(idBill, food.id, food.quantity) ==
                  false) {
                await _sendFailed(table.name, context);
                return false;
              }
            } else {
              // not exists billdetail
              if (await Controller.instance
                      .insertBillDetail(idBill, food.id, food.quantity) ==
                  false) {
                await _sendFailed(table.name, context);
                return false;
              }
            }
          }
          Controller.instance.isSend = true;
          await _sendSuccess(table.name, context);
          return true;
        } else
          await _sendFailed(table.name, context);
        return false;
      } else {
        // not exists bill
        if (await Controller.instance.insertBill(
            table.id,
            table.dateCheckIn,
            DateTime.parse(new DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
                .format(DateTime.now())),
            0,
            table.getTotalPrice(),
            0,
            'test')) {
          int idBill = await Controller.instance.getIdBillMax();

          for (var food in table.foods) {
            if (await Controller.instance
                    .insertBillDetail(idBill, food.id, food.quantity) ==
                false) {
              await _sendFailed(table.name, context);
              return false;
            }
          }
          Controller.instance.isSend = true;
          await _sendSuccess(table.name, context);
          return true;
        } else
          await _sendFailed(table.name, context);
        return false;
      }
    }
  }
}
