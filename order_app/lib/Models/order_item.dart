import 'package:json_annotation/json_annotation.dart';

import 'drink_model.dart';

part 'order_item.g.dart';

@JsonSerializable()
class OrderItem {
  @JsonKey(name: 'localId', includeIfNull: false)
  int localId;
  @JsonKey(name: 'drink', includeIfNull: false)
  DrinkModel drink;
  @JsonKey(name: 'quantity', includeIfNull: false)
  int quantity;
  @JsonKey(name: 'additional', includeIfNull: false)
  int additional;
  @JsonKey(name: 'status', includeIfNull: false)
  int status;
  @JsonKey(name: 'tableID', includeIfNull: false)
  String tableID;
  @JsonKey(name: 'id', includeIfNull: false)
  String id;
  @JsonKey(name: 'drinkID', includeIfNull: false)
  String drinkID;
  @JsonKey(name: 'note', includeIfNull: false)
  String note;
  @JsonKey(name: 'isSync', includeIfNull: false)
  int isSync;
  OrderItem(
      {this.drink,
      this.quantity,
      this.status = 0,
      this.drinkID,
      this.tableID,
      this.additional = 0,
      this.note = '113',
      this.isSync = 0,
      this.id});

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

  OrderItem getOrderItemToUpdateDatabase() {
    return new OrderItem(
        drinkID: drinkID,
        id: id,
        quantity: quantity,
        additional: additional,
        note: note,
        status: status,
        tableID: tableID);
  }

  static OrderItem clone(OrderItem orderItem) {
    return new OrderItem(
        drinkID: orderItem.drinkID,
        drink: orderItem.drink,
        isSync: orderItem.isSync,
        id: orderItem.id,
        quantity: orderItem.quantity,
        additional: orderItem.additional,
        status: orderItem.status,
        tableID: orderItem.tableID);
  }
}
