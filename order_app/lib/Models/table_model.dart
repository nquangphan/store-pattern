

import 'package:json_annotation/json_annotation.dart';
import 'package:order_app/Constants/colors.dart';
import 'package:order_app/Models/order_item.dart';

part 'table_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TableModel {
  @JsonKey(name: 'localId', includeIfNull: false)
  int localId;
  @JsonKey(name: 'id', includeIfNull: false)
  String id;
  @JsonKey(name: 'table_number', includeIfNull: false)
  String tableNumber;
  @JsonKey(name: 'order_items', includeIfNull: false)
  List<OrderItem> orderItems;
  @JsonKey(name: 'start_date', includeIfNull: false)
  String startDate;
  @JsonKey(name: 'end_date', includeIfNull: false)
  String endDate;
  @JsonKey(name: 'status', includeIfNull: false)
  int status;
  @JsonKey(name: 'isDeliveried', includeIfNull: false)
  int isDeliveried;
  @JsonKey(name: 'isSync', includeIfNull: false)
  int isSync;
  @JsonKey(name: 'date', includeIfNull: false)
  String date;

  int tableColor;

  int getNumOfDrink() {
    if (this?.orderItems == null) {
      return 0;
    }
    int drinkCount = 0;
    orderItems.forEach((item) {
      drinkCount += item.quantity;
    });
    return drinkCount;
  }

  void setOrderItemQuantity(int orderItemIndex, int quantity) {
    this.orderItems[orderItemIndex].quantity = quantity;
  }

  double getGrandTotal() {
    if (this?.orderItems == null) {
      return 0;
    }
    double grandTotal = 0;
    orderItems.forEach((item) {
      if (item.drink != null && item.drink.price != null) {
        grandTotal += item.quantity * item.drink.price;
      }
    });
    return grandTotal;
  }

  TableModel(
      {this.tableNumber,
      this.id,
      this.orderItems,
      this.endDate,
      this.localId,
      this.startDate,
      this.status,
      this.date,
      this.isDeliveried = 0,
      this.isSync = 0,
      this.tableColor}) {
    if (this.tableColor == null) {
      if (this?.orderItems == null) {
        this.orderItems = new List<OrderItem>();
      }
      tableColor = MyColors.randomColor().value;
    }
  }

  factory TableModel.fromJson(Map<String, dynamic> json) =>
      _$TableModelFromJson(json);
  Map<String, dynamic> toJson() => _$TableModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

  TableModel getModelToUpdateDatabase() {
    return new TableModel(
        startDate: startDate,
        status: status,
        tableColor: tableColor,
        endDate: endDate,
        date: date,
        isSync: isSync,
        tableNumber: tableNumber,
        isDeliveried: isDeliveried,
        id: id);
  }
}
