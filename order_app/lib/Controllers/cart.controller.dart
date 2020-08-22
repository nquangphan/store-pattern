import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get_ip/get_ip.dart';
import 'package:order_app/Models/connectServer.dart';
import 'package:order_app/Models/drink_model.dart';
import 'package:order_app/Models/home.model.dart' as HomeModel;
import 'package:order_app/Models/order_item.dart';
import 'package:order_app/Models/table_model.dart';

import './../Models/cart.model.dart';

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
}
