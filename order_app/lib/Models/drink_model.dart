import 'package:json_annotation/json_annotation.dart';

part 'drink_model.g.dart';

@JsonSerializable()
class DrinkModel {
  @JsonKey(name: 'localId', includeIfNull: false)
  int localId;
  @JsonKey(name: 'id', includeIfNull: false)
  String id;
  @JsonKey(name: 'image', includeIfNull: false)
  String image;
  @JsonKey(name: 'price', includeIfNull: false)
  double price;
  @JsonKey(name: 'name', includeIfNull: false)
  String name;
  @JsonKey(name: 'isSync', includeIfNull: false)
  int isSync;

  DrinkModel({
    this.price,
    this.id,
    this.name,
    this.localId,
    this.isSync = 0,
    this.image,
  });

  factory DrinkModel.fromJson(Map<String, dynamic> json) =>
      _$DrinkModelFromJson(json);
  Map<String, dynamic> toJson() => _$DrinkModelToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

  DrinkModel getModelToUpdateDatabase() {
    return new DrinkModel(
        id: id, image: image, isSync: isSync, name: name, price: price);
  }
}
