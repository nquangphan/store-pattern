import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import './../Constants/dialog.dart';
import './../Constants/theme.dart' as theme;
import './../Controllers/cart.controller.dart';
import './../Controllers/history.controller.dart' as historyController;
import './../Models/home.model.dart' as home;
import './../Models/login.model.dart';
import './../Models/menu.model.dart' as menu;

class CartScreen extends StatefulWidget {
  CartScreen({key, this.table, this.menuContext, this.account})
      : super(key: key);

  final Account account;
  final home.Table table;
  final BuildContext menuContext;

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  double _discount;
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _discount = 0.0;

    super.initState();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('app_icon');
    var ios = IOSInitializationSettings();
    var initSetting = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initSetting);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(child: _buildListFoods(context)),
          _buildControls(context),
        ],
      ),
    );
  }

  Widget _buildListFoods(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
          children: List<Widget>.generate(widget.table.foods.length, (index) {
        return _buildFood(context, widget.table.foods[index]);
      })),
    );
  }

  Widget _buildFood(BuildContext context, menu.Food food) {
    return Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: Card(
          color: theme.primaryColor,
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
                          color: theme.fontColor,
                          fontFamily: 'Dosis',
                          fontSize: 20.0),
                    ),
                    Text(
                      NumberFormat("#,###").format(food.price) + ' vnđ',
                      style: const TextStyle(
                          color: theme.fontColor,
                          fontFamily: 'Dosis',
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
                          color: food.quantity > 0 ?Colors.blue : Colors.grey),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 1.0, bottom: 1.0, left: 4.0, right: 4.0),
                        child: Text(food.quantity.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Dosis',
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
        color: theme.fontColor,
        fontFamily: 'Dosis',
        fontSize: 16.0,
        fontWeight: FontWeight.w500);

    TextStyle _itemStyle2 = TextStyle(
        color: Colors.redAccent,
        fontFamily: 'Dosis',
        fontSize: 16.0,
        fontWeight: FontWeight.w500);

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: theme.fontColorLight.withOpacity(0.2)),
          color: theme.primaryColor),
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
            title: Text('Error', style: theme.errorTitleStyle),
            content: Text(
                'Can\'t be checkout for ' +
                    widget.table.name +
                    '!' +
                    '\nPlease select foods!',
                style: theme.contentStyle),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok', style: theme.okButtonStyle),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(cartContext).pop();
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
            title: Text('Confirm', style: theme.titleStyle),
            content: Text(
                'Do you want to be checkout for ' + widget.table.name + '?',
                style: theme.contentStyle),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok', style: theme.okButtonStyle),
                onPressed: () async {
                  Navigator.of(context).pop();

                  home.Table table = home.Table(widget.table);

                  if (table.status == 1) {
                    // exists bill
                    Navigator.of(cartContext).pop();
                    Navigator.of(widget.menuContext).pop();
                    int idBill =
                        await Controller.instance.getIdBillByTable(table.id);
                    if (await Controller.instance.updateBill(
                        idBill,
                        table.id,
                        table.dateCheckIn,
                        DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
                            .format(DateTime.now())),
                        _discount,
                        table.getTotalPrice(),
                        1,
                        widget.account.username)) {
                      historyController.Controller.instance.addBill(
                          idBill,
                          table,
                          DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
                              .format(DateTime.now())),
                          _discount,
                          table.getTotalPrice(),
                          widget.account);
                      widget.table.status = -1;
                      widget.table.foods.clear();
                      _showNotification();
                    } else
                      errorDialog(
                          this.context,
                          'Checkout failed at ' +
                              table.name +
                              '.\nPlease try again!');
                  } else
                    errorDialog(this.context,
                        'Please send the bill to the kitchen before making payment!');
                },
              ),
              FlatButton(
                child: Text('Cancel', style: theme.cancelButtonStyle),
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
        'Notification',
        'Successful checkout at ' + widget.table.name + '!!!',
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
