// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableModel _$TableModelFromJson(Map<String, dynamic> json) {
  return TableModel(
    tableNumber: json['table_number'] as String,
    id: json['id'] as String,
    orderItems: (json['order_items'] as List)
        ?.map((e) =>
            e == null ? null : OrderItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    endDate: json['end_date'] as String,
    localId: json['localId'] as int,
    startDate: json['start_date'] as String,
    status: json['status'] as int,
    date: json['date'] as String,
    isDeliveried: json['isDeliveried'] as int,
    isSync: json['isSync'] as int,
    tableColor: json['tableColor'] as int,
  );
}

Map<String, dynamic> _$TableModelToJson(TableModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('localId', instance.localId);
  writeNotNull('id', instance.id);
  writeNotNull('table_number', instance.tableNumber);
  writeNotNull(
      'order_items', instance.orderItems?.map((e) => e?.toJson())?.toList());
  writeNotNull('start_date', instance.startDate);
  writeNotNull('end_date', instance.endDate);
  writeNotNull('status', instance.status);
  writeNotNull('isDeliveried', instance.isDeliveried);
  writeNotNull('isSync', instance.isSync);
  writeNotNull('date', instance.date);
  val['tableColor'] = instance.tableColor;
  return val;
}
