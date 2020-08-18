
import 'package:user_repository/user_repository.dart';

import './../Constants/queries.dart' as queries;
import './connectServer.dart';

class LoginModel {
  static LoginModel _instance;

  static LoginModel get instance {
    if (_instance == null) {
      _instance = new LoginModel();
    }
    return _instance;
  }

  Future<Account> login(String username) async {
    Future<List> futureAccount = MySqlConnection.instance.executeQuery(queries.LOGIN, parameter: [username]);
    return parseAccount(futureAccount);
  }

  Future<Account> parseAccount(Future<List> accounts) async {
    Account account;
    await accounts.then((values) {
      if (values.length > 0) account = Account.fromJson(values[0]);
    });
    return account;
  }
}