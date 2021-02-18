import './../Models/history.model.dart' as history;
import './../Models/home.model.dart' as home;
import './../Models/login.model.dart' as login;

class Controller {
  static Controller _instance;

  static Controller get instance {
    if (_instance == null) _instance = new Controller();
    return _instance;
  }

  Future<List<history.BillPlus>> _bills;

  Future<List<history.BillPlus>> get bills {
    _bills = history.Model.instance.getListBill();
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

  void addBill(int id, home.Table table, DateTime dateCheckout, double discount,
      double totalPrice, login.Account account) async {
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
    return history.Model.instance.deleteBill(id);
  }
}
