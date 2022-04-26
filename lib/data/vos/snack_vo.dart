import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

part 'snack_vo.g.dart';

@JsonSerializable()
@HiveType(typeId: HIVE_TYPE_ID_SNACK_VO, adapterName: "SnackVOAdapter")
class SnackVO {
  @JsonKey(name: "id")
  @HiveField(0)
  int? id;

  @JsonKey(name: "name")
  @HiveField(1)
  String? name;

  @JsonKey(name: "description")
  @HiveField(2)
  String? description;

  @JsonKey(name: "price")
  @HiveField(3)
  int? price;

  @JsonKey(name: "image")
  @HiveField(4)
  String? image;

  @JsonKey(name: "unit_price")
  @HiveField(5)
  int? unitPrice;

  @JsonKey(name: "quantity")
  @HiveField(6)
  int? quantity;

  @JsonKey(name: "total_price")
  @HiveField(7)
  int? totalPrice;

  SnackVO(
    this.id,
    this.name,
    this.description,
    this.price,
    this.image,
    this.unitPrice,
    this.quantity,
    this.totalPrice,
  );

  factory SnackVO.fromJson(Map<String, dynamic> json) =>
      _$SnackVOFromJson(json);

  Map<String, dynamic> toJson() => _$SnackVOToJson(this);

  @override
  String toString() {
    return 'SnackVO{id: $id, name: $name, description: $description, price: $price, image: $image, quantity: $quantity}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SnackVO &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          price == other.price &&
          image == other.image &&
          unitPrice == other.unitPrice &&
          quantity == other.quantity &&
          totalPrice == other.totalPrice;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      price.hashCode ^
      image.hashCode ^
      unitPrice.hashCode ^
      quantity.hashCode ^
      totalPrice.hashCode;
}
