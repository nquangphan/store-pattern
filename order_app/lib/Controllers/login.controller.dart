import 'package:dbcrypt/dbcrypt.dart';
import 'package:user_repository/user_repository.dart';

import './../Models/login.model.dart';

class LoginController {
  static LoginController _instance;

  Account account;

  static LoginController get instance {
    if (_instance == null) _instance = new LoginController();
    return _instance;
  }

  Future<bool> login(String username, String password) async {
    if (account == null || account.username != username) account = await LoginModel.instance.login(username);
    // return account != null ? DBCrypt().checkpw(password, account.password) : false;
    return true;
  }
}
