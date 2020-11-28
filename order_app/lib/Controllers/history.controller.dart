import 'package:user_repository/user_repository.dart';

import './../Models/history.model.dart' as history;
import './../Models/home.model.dart' as home;
import './../Models/login.model.dart' as login;

class HistoryController {
  static HistoryController _instance;

  static HistoryController get instance {
    if (_instance == null) _instance = new HistoryController();
    return _instance;
  }

  Future<List<history.BillPlus>> _bills;

  Future<List<history.BillPlus>> get bills {
    if (_bills == null) _bills = history.HistoryModel.instance.getListBill();
    return _bills;
  }

  void removeBill(int id) async {
    int index = findIndex(await bills, id);
    (await bills).removeAt(index);
  }

  int findIndex(List<history.BillPlus> bills, int id) {
    int i = 0;
    for (var item in bills) {
      if (item.id == id) return i;
      i++;
    }
    return -1;
  }

  void addBill(int id, home.AppTable table, DateTime dateCheckout, double discount, double totalPrice,
      Account account) async {
    history.BillPlus bill = new history.BillPlus(
        id: id,
        table: table,
        dateCheckOut: dateCheckout,
        discount: discount,
        totalPrice: totalPrice,
        account: account);

    await this.bills.then((values) {
      if (findIndex(values, bill.id) == -1) values.insert(0, bill);
    });
  }

  Future<bool> deleteBill(int id) {
    return history.HistoryModel.instance.deleteBill(id);
  }
}
