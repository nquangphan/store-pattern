// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrinkModel _$DrinkModelFromJson(Map<String, dynamic> json) {
  return DrinkModel(
    price: (json['price'] as num)?.toDouble(),
    id: json['id'] as String,
    name: json['name'] as String,
    localId: json['localId'] as int,
    isSync: json['isSync'] as int,
    image: json['image'] as String,
  );
}

Map<String, dynamic> _$DrinkModelToJson(DrinkModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('localId', instance.localId);
  writeNotNull('id', instance.id);
  writeNotNull('image', instance.image);
  writeNotNull('price', instance.price);
  writeNotNull('name', instance.name);
  writeNotNull('isSync', instance.isSync);
  return val;
}
