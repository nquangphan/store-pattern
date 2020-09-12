import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './../Constants/dialog.dart';
import './../Constants/theme.dart' as theme;
import './../Controllers/cart.controller.dart' as cartController;
import './../Controllers/home.controller.dart';
import './../Models/home.model.dart' as home;
import './../Models/login.model.dart';
import './cart.view.dart';
import './menu.view.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({key, this.account}) : super(key: key);

  final Account account;

  @override
  State<StatefulWidget> createState() {
    return new _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  home.Table _selectedTable;

  @override
  void initState() {
    super.initState();
    Controller.instance.getTables();
    Controller.instance.startBackgroundTask();
  }

  @override
  void dispose() {
    Controller.instance.stopBackgroundTask();
    Controller.instance.closeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(5.0),
          child: StreamBuilder<List<home.Table>>(
              stream: Controller.instance.tableListStream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    runSpacing: 20,
                    spacing: 8,
                    children:
                        List<Widget>.generate(snapshot.data.length, (index) {
                      return _buildTable(context, snapshot.data[index]);
                    }),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context, home.Table table) {
    return new GestureDetector(
      onTap: () {
        setState(() {
          _selectedTable = table;
        });
        _pushCartScreen(table, context);
      },
      child: new Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          child: new Card(
            color: table.status == 1 ? Colors.green : theme.primaryColor,
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Icon(
                    table.status == 1 ? Icons.people : Icons.people_outline,
                    size: 20.0,
                    color:
                        table.status == 1 ? Colors.redAccent : Colors.redAccent,
                  ),
                ),
                // new Expanded(child: new Container()),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, bottom: 30.0, right: 16.0),
                    child: new Text(
                      'Bàn ' + table.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: theme.fontColorLight,
                          fontFamily: 'Arial',
                          fontSize: 20.0),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  void _pushCartScreen(home.Table table, BuildContext menuContext) {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) {
        return new Scaffold(
          body: new CartScreen(
            table: table,
            homeContext: context,
            account: widget.account,
            sendBillToKitchen: _sendBillToKitchen,
          ),
        );
      }),
    );
  }

  Future<void> _sendSuccess(String tablename) {
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

  Future<void> _sendFailed(String tableName) {
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

  Future<bool> _sendBillToKitchen(home.Table table) async {
    {
      if (table.foods == null || table.foods.length == 0) return false;
      // Navigator.of(context).pop();
      cartController.Controller.instance.isSend = false;
      if (await cartController.Controller.instance.hasBillOfTable(table.id)) {
        // exists bill
        int idBill =
            await cartController.Controller.instance.getIdBillByTable(table.id);
        if (await cartController.Controller.instance.updateBill(
            idBill,
            table.id,
            table.dateCheckIn,
            DateTime.parse(new DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
                .format(DateTime.now())),
            0,
            table.getTotalPrice(),
            0,
            widget.account.username)) {
          for (var food in table.foods) {
            if (await cartController.Controller.instance
                .hasBillDetailOfBill(idBill, food.id)) {
              // exists billdetail
              if (await cartController.Controller.instance
                      .updateBillDetail(idBill, food.id, food.quantity) ==
                  false) {
                await _sendFailed(table.name);
                return false;
              }
            } else {
              // not exists billdetail
              if (await cartController.Controller.instance
                      .insertBillDetail(idBill, food.id, food.quantity) ==
                  false) {
                await _sendFailed(table.name);
                return false;
              }
            }
          }
          cartController.Controller.instance.isSend = true;
          await _sendSuccess(table.name);
          return true;
        } else
          await _sendFailed(table.name);
        return false;
      } else {
        // not exists bill
        if (await cartController.Controller.instance.insertBill(
            table.id,
            table.dateCheckIn,
            DateTime.parse(new DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
                .format(DateTime.now())),
            0,
            table.getTotalPrice(),
            0,
            widget.account.username)) {
          int idBill = await cartController.Controller.instance.getIdBillMax();

          for (var food in table.foods) {
            if (await cartController.Controller.instance
                    .insertBillDetail(idBill, food.id, food.quantity) ==
                false) {
              await _sendFailed(table.name);
              return false;
            }
          }
          cartController.Controller.instance.isSend = true;
          await _sendSuccess(table.name);
          return true;
        } else
          await _sendFailed(table.name);
        return false;
      }
    }

    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: new Text('Xác nhận', style: theme.titleStyle),
    //         content: new Text(
    //             'Bạn chắc chắn muốn gửi ' + table.name + ' tới pha chế?',
    //             style: theme.contentStyle),
    //         actions: <Widget>[
    //           new FlatButton(
    //             child: new Text('Ok', style: theme.okButtonStyle),
    //             onPressed: () async {
    //               Navigator.of(context).pop();
    //               cartController.Controller.instance.isSend = false;
    //               if (await cartController.Controller.instance
    //                   .hasBillOfTable(table.id)) {
    //                 // exists bill
    //                 int idBill = await cartController.Controller.instance
    //                     .getIdBillByTable(table.id);
    //                 if (await cartController.Controller.instance.updateBill(
    //                     idBill,
    //                     table.id,
    //                     table.dateCheckIn,
    //                     DateTime.parse(new DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
    //                         .format(DateTime.now())),
    //                     0,
    //                     table.getTotalPrice(),
    //                     0,
    //                     widget.account.username)) {
    //                   for (var food in table.foods) {
    //                     if (await cartController.Controller.instance
    //                         .hasBillDetailOfBill(idBill, food.id)) {
    //                       // exists billdetail
    //                       if (await cartController.Controller.instance
    //                               .updateBillDetail(
    //                                   idBill, food.id, food.quantity) ==
    //                           false) {
    //                         _sendFailed(table.name);
    //                         return;
    //                       }
    //                     } else {
    //                       // not exists billdetail
    //                       if (await cartController.Controller.instance
    //                               .insertBillDetail(
    //                                   idBill, food.id, food.quantity) ==
    //                           false) {
    //                         _sendFailed(table.name);
    //                         return;
    //                       }
    //                     }
    //                   }
    //                   cartController.Controller.instance.isSend = true;
    //                   _sendSuccess(table.name);
    //                 } else
    //                   _sendFailed(table.name);
    //               } else {
    //                 // not exists bill
    //                 if (await cartController.Controller.instance.insertBill(
    //                     table.id,
    //                     table.dateCheckIn,
    //                     DateTime.parse(new DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
    //                         .format(DateTime.now())),
    //                     0,
    //                     table.getTotalPrice(),
    //                     0,
    //                     widget.account.username)) {
    //                   int idBill = await cartController.Controller.instance
    //                       .getIdBillMax();

    //                   for (var food in table.foods) {
    //                     if (await cartController.Controller.instance
    //                             .insertBillDetail(
    //                                 idBill, food.id, food.quantity) ==
    //                         false) {
    //                       _sendFailed(table.name);
    //                       return;
    //                     }
    //                   }
    //                   cartController.Controller.instance.isSend = true;
    //                   _sendSuccess(table.name);
    //                 } else
    //                   _sendFailed(table.name);
    //               }
    //             },
    //           ),
    //           new FlatButton(
    //             child: new Text('Hủy', style: theme.cancelButtonStyle),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           )
    //         ],
    //       );
    //     });
  }
}
