// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return OrderItem(
    drink: json['drink'] == null
        ? null
        : DrinkModel.fromJson(json['drink'] as Map<String, dynamic>),
    quantity: json['quantity'] as int,
    status: json['status'] as int,
    drinkID: json['drinkID'] as String,
    tableID: json['tableID'] as String,
    additional: json['additional'] as int,
    note: json['note'] as String,
    isSync: json['isSync'] as int,
    id: json['id'] as String,
  )..localId = json['localId'] as int;
}

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('localId', instance.localId);
  writeNotNull('drink', instance.drink);
  writeNotNull('quantity', instance.quantity);
  writeNotNull('additional', instance.additional);
  writeNotNull('status', instance.status);
  writeNotNull('tableID', instance.tableID);
  writeNotNull('id', instance.id);
  writeNotNull('drinkID', instance.drinkID);
  writeNotNull('note', instance.note);
  writeNotNull('isSync', instance.isSync);
  return val;
}
