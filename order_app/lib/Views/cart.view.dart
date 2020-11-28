import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:order_app/Constants/theme.dart';
import 'package:order_app/Views/menu.view.dart';
import 'package:user_repository/user_repository.dart';

import './../Constants/dialog.dart';
import './../Controllers/cart.controller.dart';
import './../Controllers/history.controller.dart';
import './../Models/home.model.dart' ;
import './../Models/menu.model.dart' ;
import './../Controllers/menu.controller.dart' ;

class CartScreen extends StatefulWidget {
  CartScreen(
      {key, this.table, this.homeContext, this.account})
      : super(key: key);

  final Account account;
  final AppTable table;
  final BuildContext homeContext;

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  double _discount;
  TextEditingController _textController = TextEditingController();
  Future<List<Food>> futureFoods;
  @override
  void initState() {
    _discount = 0.0;

    super.initState();
    if (widget.table.status == 1) {
      futureFoods =
          MenuController.instance.getListFoodByTable(widget.table);
    }
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('app_icon');
    var ios = IOSInitializationSettings();
    var initSetting = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initSetting);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _pushMenuScreen(widget.table);
        },
        child: new Icon(Icons.add_shopping_cart),
        tooltip: 'Add To Cart',
        backgroundColor: fontColor,
      ),
      appBar: new AppBar(
        title: new Text(
          'Bàn • ' + widget.table.name,
          style: new TextStyle(color: accentColor, fontFamily: 'Arial'),
        ),
        iconTheme: new IconThemeData(color: accentColor),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.send),
            color: accentColor,
            onPressed: () {
              _sendBillToKitchen(widget.table);
            },
          )
        ],
      ),
      body: widget.table.status == 1
          ? FutureBuilder<List<Food>>(
              future: futureFoods,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(child: _buildListFoods(context)),
                        _buildControls(context),
                      ],
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })
          : Container(
              child: Column(
                children: <Widget>[
                  Expanded(child: _buildListFoods(context)),
                  _buildControls(context),
                ],
              ),
            ),
    );
  }

  
  void _sendBillToKitchen(AppTable table) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Xác nhận', style: titleStyle),
            content: new Text(
                'Bạn chắc chắn muốn gửi ' + table.name + ' tới pha chế?',
                style: contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok', style: okButtonStyle),
                onPressed: () async {
                  Navigator.of(context).pop();
                  CartController.instance.isSend = false;
                  if (await CartController.instance.hasBillOfTable(table.id)) {
                    // exists bill
                    int idBill = await CartController.instance
                        .getIdBillByTable(table.id);
                    if (await CartController.instance.updateBill(
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
                        if (await CartController.instance
                            .hasBillDetailOfBill(idBill, food.id)) {
                          // exists billdetail
                          if (await CartController.instance.updateBillDetail(
                                  idBill, food.id, food.quantity) ==
                              false) {
                            _sendFailed(table.name);
                            return;
                          }
                        } else {
                          // not exists billdetail
                          if (await CartController.instance.insertBillDetail(
                                  idBill, food.id, food.quantity) ==
                              false) {
                            _sendFailed(table.name);
                            return;
                          }
                        }
                      }
                      CartController.instance.isSend = true;
                      _sendSuccess(table.name);
                    } else
                      _sendFailed(table.name);
                  } else {
                    // not exists bill
                    if (await CartController.instance.insertBill(
                        table.id,
                        table.dateCheckIn,
                        DateTime.parse(new DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
                            .format(DateTime.now())),
                        0,
                        table.getTotalPrice(),
                        0,
                        widget.account.username)) {
                      int idBill = await CartController.instance.getIdBillMax();

                      for (var food in table.foods) {
                        if (await CartController.instance.insertBillDetail(
                                idBill, food.id, food.quantity) ==
                            false) {
                          _sendFailed(table.name);
                          return;
                        }
                      }
                      CartController.instance.isSend = true;
                      _sendSuccess(table.name);
                    } else
                      _sendFailed(table.name);
                  }
                },
              ),
              new FlatButton(
                child: new Text('Hủy', style: cancelButtonStyle),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  
  _sendSuccess(String tablename) {
    String message = 'Gửi ' + tablename + ' tới pha chế thành công.';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Thông báo', style: titleStyle),
            content: new Text(message, style: contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok', style: okButtonStyle),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _sendFailed(String tableName) {
    String message = 'Gửi ' +
        tableName +
        ' tới pha chế không thành công.\nVui lòng thử lại!';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Lỗi', style: errorTitleStyle),
            content: new Text(message, style: contentStyle),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Ok', style: okButtonStyle),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _pushMenuScreen(AppTable table) {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) {
        return new Scaffold(
          floatingActionButton: new FloatingActionButton(
            onPressed: () {
              _sendBillToKitchen(table);
            },
            child: new Icon(Icons.save),
            tooltip: 'Add To Cart',
            backgroundColor: Colors.green,
          ),
          appBar: new AppBar(
            title: new Text(
              'Menu • ' + table.name,
              style:
                  new TextStyle(color: accentColor, fontFamily: 'Arial'),
              overflow: TextOverflow.ellipsis,
            ),
            iconTheme: new IconThemeData(color: accentColor),
            centerTitle: true,
          ),
          body: new MenuScreen(table: table),
        );
      }),
    ).then((value) {
      setState(() {
        if (widget.table.status == 1) {
          futureFoods = MenuController.instance
              .getListFoodByTable(widget.table);
        }
      });
    });
  }

  Widget _buildListFoods(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
          children: List<Widget>.generate(widget.table.foods.length, (index) {
        return _buildFood(context, widget.table.foods[index]);
      })),
    );
  }

  Widget _buildFood(BuildContext context, Food food) {
    return Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: Card(
          color: primaryColor,
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(8),
                child: Image.memory(
                  food.image,
                  width: 120.0,
                  height: 120.0,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      food.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: fontColor,
                          fontFamily: 'Arial',
                          fontSize: 20.0),
                    ),
                    Text(
                      NumberFormat("#,###").format(food.price) + ' vnđ',
                      style: const TextStyle(
                          color: fontColor,
                          fontFamily: 'Arial',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: 20.0,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.table.addFood(food);
                      });
                    },
                  ),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: food.quantity > 0 ? Colors.blue : Colors.grey),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 1.0, bottom: 1.0, left: 4.0, right: 4.0),
                        child: Text(food.quantity.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Arial',
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center),
                      )),
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      size: 20.0,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.table.subFood(food);
                      });
                    },
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 20.0,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    widget.table.deleteFood(food);
                  });
                },
              ),
            ],
          ),
        ));
  }

  Widget _buildControls(BuildContext context) {
    TextStyle _itemStyle = TextStyle(
        color: fontColor,
        fontFamily: 'Arial',
        fontSize: 16.0,
        fontWeight: FontWeight.w500);

    TextStyle _itemStyle2 = TextStyle(
        color: Colors.redAccent,
        fontFamily: 'Arial',
        fontSize: 16.0,
        fontWeight: FontWeight.w500);

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: fontColorLight.withOpacity(0.2)),
          color: primaryColor),
      margin: EdgeInsets.only(top: 2.0, bottom: 7.0, left: 7.0, right: 7.0),
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Tạm tính: ',
                style: _itemStyle,
              ),
              Expanded(child: Container()),
              Text(
                NumberFormat("#,###").format(widget.table.getTotalPrice()) +
                    ' vnđ',
                style: _itemStyle,
              )
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Text(
                'Giảm giá: ',
                style: _itemStyle,
              ),
              Expanded(child: Container()),
              Container(
                width: 35.0,
                alignment: Alignment(1.0, 0.0),
                child: TextField(
                    controller: _textController,
                    style: _itemStyle,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (double.parse(value) > 100 ||
                          double.parse(value) < 0) {
                        _textController.clear();
                        value = '0.0';
                      }

                      setState(() {
                        _discount = double.parse(value);
                      });
                    },
                    onSubmitted: null,
                    decoration: InputDecoration.collapsed(
                        hintText: '0%', hintStyle: _itemStyle)),
              ),
            ],
          ),
          Divider(),
          Row(
            children: <Widget>[
              Text(
                'Tổng tiền: ',
                style: _itemStyle,
              ),
              Expanded(child: Container()),
              Text(
                NumberFormat("#,###").format(widget.table.getTotalPrice() *
                        (100 - _discount) /
                        100) +
                    ' vnđ',
                style: _itemStyle2.merge(TextStyle(color: Colors.green)),
              )
            ],
          ),
          Divider(),
          Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: Colors.blueAccent,
                child: Text(
                  'Thanh toán',
                  style: _itemStyle.merge(TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                onPressed: () {
                  if (widget.table.foods.length > 0)
                    _checkOut(context);
                  else
                    _error(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _error(BuildContext cartContext) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi', style: errorTitleStyle),
            content: Text(
                'Không thể thanh toán bàn ' +
                    widget.table.name +
                    '!' +
                    '\nPhải chọn đồ uống mới được thanh toán.',
                style: contentStyle),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok', style: okButtonStyle),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _checkOut(BuildContext cartContext) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Xác nhận', style: titleStyle),
            content: Text(
                'Bạn có muốn thanh toán bàn ' + widget.table.name + '?',
                style: contentStyle),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok', style: okButtonStyle),
                onPressed: () async {
                  Navigator.of(context).pop();

                  AppTable table = AppTable(widget.table);

                  if (table.status == 1) {
                    // exists bill
                    Navigator.of(cartContext).pop();
                    int idBill =
                        await CartController.instance.getIdBillByTable(table.id);
                    if (await CartController.instance.updateBill(
                        idBill,
                        table.id,
                        table.dateCheckIn,
                        DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
                            .format(DateTime.now())),
                        _discount,
                        table.getTotalPrice(),
                        1,
                        widget.account.username)) {
                      HistoryController.instance.addBill(
                          idBill,
                          table,
                          DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
                              .format(DateTime.now())),
                          _discount,
                          table.getTotalPrice(),
                          widget.account);
                      CartController.instance
                          .findPrinterAndPrintTicket(widget.table);
                      // widget.table.status = -1;
                      // widget.table.foods.clear();
                      _showNotification();
                    } else
                      errorDialog(
                          this.context,
                          'Thanh toán thất bại bàn ' +
                              table.name +
                              '.\nVui lòng thử lại!');
                  } else
                    errorDialog(this.context,
                        'Phải gửi order tới pha chế trước khi thanh toán!');
                },
              ),
              FlatButton(
                child: Text('Hủy', style: cancelButtonStyle),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Thông báo',
        'Thanh toán thành công bàn ' + widget.table.name + '!!!',
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }
}
