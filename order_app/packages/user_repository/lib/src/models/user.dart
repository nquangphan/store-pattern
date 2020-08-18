import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}



class Account {
  String username;
  String displayName;
  String password;
  int sex;
  String idCard;
  String address;
  String phone;
  DateTime birthday;
  String accountType;
  Uint8List image;

  Account.fromJson(Map<String, dynamic> json) {
    username = json['Username'];
    displayName = json['DisplayName'] != null ? json['DisplayName'] : '';
    password = json['Password'];
    sex = json['Sex'] != null ? int.parse(json['Sex']) : -1;
    idCard = json['IDCard'] != null ? json['IDCard'] : '';
    address = json['Address'] != null ? json['Address'] : '';
    phone = json['PhoneNumber'] != null ? json['PhoneNumber'] : '';
    birthday = json['BirthDay'] != null
        ? DateTime.parse(json['BirthDay'])
        : DateTime.now().subtract(new Duration(days: 365 * 18));
    accountType = json['Name'] != null ? json['Name'] : '';
    image = json['Data'] != null ? base64.decode(json['Data']) : null;
  }
}
