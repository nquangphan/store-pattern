import 'package:user_repository/user_repository.dart';

import './../Constants/queries.dart' as queries;
import './connectServer.dart';
import './home.model.dart' ;
import './login.model.dart' ;
import './menu.model.dart' ;

class HistoryModel {
  static HistoryModel _instance;

  static HistoryModel get instance {
    if (_instance == null) _instance = new HistoryModel();
    return _instance;
  }

  Future<List<BillPlus>> getListBill() async {
    Future<List> futureBills =
        MySqlConnection.instance.executeQuery(queries.GET_BILLS, parameter: [DateTime.now()]);
    return parseBillPlus(futureBills);
  }

  Future<bool> deleteBill(int id) {
    return MySqlConnection.instance.executeNoneQuery(queries.DELETE_BILL, parameter: [id]);
  }

  Future<List<Food>> getBillDetailByBill(int idBill) async {
    Future<List> futureFoods =
        MySqlConnection.instance.executeQuery(queries.GET_BILLDETAIL_BY_BILL, parameter: [idBill]);
    return parseFood(futureFoods);
  }

  Future<List<BillPlus>> parseBillPlus(Future<List> bills) async {
    List<BillPlus> futureBills = [];
    await bills.then((values) {
      values.forEach((value) {
        futureBills.add(new BillPlus.fromJson(value));
      });
    });
    return futureBills;
  }

  Future<List<Food>> parseFood(Future<List> foods) async {
    List<Food> futureFoods = [];
    await foods.then((values) {
      values.forEach((value) {
        futureFoods.add(new Food.fromJson(value));
      });
    });
    return futureFoods;
  }
}

class BillPlus {
  int id;
  AppTable table;
  DateTime dateCheckOut;
  double discount;
  double totalPrice;
  Account account;

  BillPlus({this.id, this.table, this.dateCheckOut, this.discount, this.totalPrice, this.account});

  BillPlus.fromJson(Map<String, dynamic> json) {
    this.id = int.parse(json['ID']);
    this.dateCheckOut = DateTime.parse(json['DateCheckOut']);
    this.discount = double.parse(json['Discount']);
    this.totalPrice = double.parse(json['TotalPrice']);

    this.table = new AppTable.noneParametter();
    this.table.id = int.parse(json['IDTable']);
    this.table.name = json['Name'];
    this.table.addFoods(HistoryModel.instance.getBillDetailByBill(this.id));

    this.account = new Account.fromJson(json);
  }
}
