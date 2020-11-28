import 'dart:io';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:image_picker/image_picker.dart';

import './../Models/profile.model.dart';

class ProfileController {
  static ProfileController _instance;

  static ProfileController get instance {
    if (_instance == null) _instance = new ProfileController();
    return _instance;
  }

  Future<bool> updateAvatar(String username, String image) {
    return ProfileModel.instance.updateAvatar(username, image);
  }

  Future<bool> updateInfo(String username, String displayName, int sex, DateTime birthday, String idCard,
      String address, String phone) {
    return ProfileModel.instance.updateInfo(username, displayName, sex, birthday, idCard, address, phone);
  }

  Future<bool> updatePassword(String username, String newPass) {
    return ProfileModel.instance.updatePassword(username, new DBCrypt().hashpw(newPass, new DBCrypt().gensalt()));
  }

  bool equalPass(String hashPass, String passCheck) => DBCrypt().checkpw(passCheck, hashPass);

  String toHashPass(String pass) => new DBCrypt().hashpw(pass, new DBCrypt().gensalt());

  Future<File> getImage() async {
    return await ImagePicker.pickImage(source: ImageSource.gallery);
  }
}
