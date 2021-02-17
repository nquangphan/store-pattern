import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_app/Controllers/cart.controller.dart';
import 'package:order_app/Views/home.view.dart';

import './../Constants/theme.dart' as theme;
import './../Models/history.model.dart' as history;
import './../Models/menu.model.dart' as menu;
import './../Models/home.model.dart' as home;

class InvoiceScreen extends StatefulWidget {
  InvoiceScreen({key, this.bill}) : super(key: key);

  final history.BillPlus bill;

  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(
        children: <Widget>[
          _buildHeader(),
          _buildBody(),
          _buildFooter(),
          _buildPrintBuildButton,
          _buildReOrderButton
        ],
      ),
    );
  }

  Future<void> _printBill(BuildContext context) async {
    Controller.instance.findPrinterAndPrintTicket(widget.bill.table);
    // widget.table.status = -1;
    // widget.table.foods.clear();
  }

  TextStyle _itemStyle = TextStyle(
      color: theme.fontColor,
      fontFamily: 'Arial',
      fontSize: 16.0,
      fontWeight: FontWeight.w500);
  Widget get _buildPrintBuildButton {
    return Container(
      margin: const EdgeInsets.only(right: 8, left: 8),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          color: Colors.blueAccent,
          child: Text(
            'In hóa đơn',
            style: _itemStyle.merge(
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          onPressed: () {
            if (widget.bill.table.foods.length > 0) _printBill(context);
          },
        ),
      ),
    );
  }

  Widget get _buildReOrderButton {
    return Container(
      margin: const EdgeInsets.only(right: 8, left: 8),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          color: Colors.blueAccent,
          child: Text(
            'Order lại',
            style: _itemStyle.merge(
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          onPressed: () {
            home.Table _currentTable;
            home.Model.instance.tables.then((value) {
              _currentTable = value.firstWhere(
                (element) => element.id == widget.bill.table.id,
                orElse: () => null,
              );

              if (_currentTable != null && _currentTable.status != 1) {
                if (widget.bill.table.dateCheckIn == null) {
                  widget.bill.table.dateCheckIn = DateTime.now();
                }
                Controller.sendBillToKitchen(widget.bill.table, context)
                    .then((value) => Navigator.of(context).pop());
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: new Text('Lỗi', style: theme.errorTitleStyle),
                        content: new Text('Số bàn này đã tồn tại.',
                            style: theme.contentStyle),
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
            });
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return new Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: new Row(
        children: <Widget>[
          Expanded(
            child: Container(),
          ),
          new Card(
              color: Colors.lightBlueAccent,
              child: new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Text(
                  widget.bill.table.name,
                  style: new TextStyle(
                    color: theme.fontColor,
                    fontFamily: 'Arial',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )),
          Expanded(
            child: Container(),
          ),
          new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text(
                    'ID# ' + widget.bill.id.toString() + '       ',
                    style: new TextStyle(
                        color: theme.fontColor,
                        fontFamily: 'Arial',
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500),
                  ),
                  new Text(
                    widget.bill.account.displayName,
                    style: new TextStyle(
                        color: theme.accentColor,
                        fontFamily: 'Arial',
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              new Text(
                new DateFormat('yyyy-MM-dd HH:mm:ss')
                    .format(widget.bill.dateCheckOut),
                style: new TextStyle(
                    color: theme.fontColor,
                    fontFamily: 'Arial',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: new ListView.builder(
            itemExtent: 60.0,
            itemCount: widget.bill.table.foods.length,
            itemBuilder: (_, index) =>
                _buildFood(widget.bill.table.foods[index])),
      ),
    );
  }

  Widget _buildFood(menu.Food food) {
    return new Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: new Card(
          color: theme.primaryColor,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(child: new Container()),
              new Text(
                food.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: theme.accentColor,
                    fontFamily: 'Arial',
                    fontSize: 18.0),
              ),
              new Expanded(child: new Container()),
              new Text(
                '\$' + food.price.toString(),
                style: const TextStyle(
                    color: theme.fontColorLight,
                    fontFamily: 'Arial',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600),
              ),
              new Expanded(child: new Container()),
              new Text(
                food.quantity.toString(),
                style: const TextStyle(
                    color: theme.fontColorLight,
                    fontFamily: 'Arial',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500),
              ),
              new Expanded(child: new Container()),
              new Text(
                '\$' + (food.quantity * food.price).toString(),
                style: const TextStyle(
                    color: Colors.redAccent,
                    fontFamily: 'Arial',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500),
              ),
              new Expanded(child: new Container()),
            ],
          ),
        ));
  }

  Widget _buildFooter() {
    TextStyle _itemStyle = new TextStyle(
        color: theme.fontColor,
        fontFamily: 'Arial',
        fontSize: 16.0,
        fontWeight: FontWeight.w500);

    TextStyle _itemStyle2 = new TextStyle(
        color: Colors.redAccent,
        fontFamily: 'Arial',
        fontSize: 16.0,
        fontWeight: FontWeight.w500);

    return new Container(
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: theme.fontColorLight.withOpacity(0.2)),
          color: theme.primaryColor),
      margin: EdgeInsets.only(top: 2.0, bottom: 7.0, left: 7.0, right: 7.0),
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0, bottom: 8),
      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Text(
                'Số ly: ',
                style: _itemStyle,
              ),
              new Expanded(child: Container()),
              new Text(
                widget.bill.table.getNumOfDrink().toString(),
                style: _itemStyle.merge(TextStyle(color: Colors.blue)),
              )
            ],
          ),
          new Divider(),
          // new Row(
          //   children: <Widget>[
          //     new Text(
          //       'Giảm giá: ',
          //       style: _itemStyle,
          //     ),
          //     new Expanded(child: Container()),
          //     new Text(
          //       widget.bill.discount.toString() + '%',
          //       style: _itemStyle,
          //     )
          //   ],
          // ),
          new Divider(),
          new Row(
            children: <Widget>[
              new Text(
                'Tổng tiền: ',
                style: _itemStyle,
              ),
              new Expanded(child: Container()),
              new Text(
                NumberFormat("#,###")
                        .format(widget.bill.table.getTotalPrice()) +
                    ' vnđ',
                style: _itemStyle2,
              )
            ],
          ),
        ],
      ),
    );
  }
}
