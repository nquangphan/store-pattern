import './../Constants/queries.dart' as queries;
import './connectServer.dart';

class ProfileModel {
  static ProfileModel _instance;

  static ProfileModel get instance {
    if (_instance == null) {
      _instance = new ProfileModel();
    }
    return _instance;
  }

  Future<bool> updateAvatar(String username, String image) {
    return MySqlConnection.instance.executeNoneQuery(queries.UPDATE_ACC_AVATAR, parameter: [username, image]);
  }

  Future<bool> updateInfo(String username, String displayName, int sex, DateTime birthday, String idCard,
      String address, String phone) {
    return MySqlConnection.instance.executeNoneQuery(queries.UPDATE_ACC_INFO,
        parameter: [username, displayName, sex, birthday, idCard, address, phone]);
  }

  Future<bool> updatePassword(String username, String newPass) {
    return MySqlConnection.instance.executeNoneQuery(queries.UPDATE_ACC_PASS, parameter: [username, newPass]);
  }
}
