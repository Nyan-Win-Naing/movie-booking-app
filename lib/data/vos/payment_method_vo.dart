import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

part 'payment_method_vo.g.dart';

@JsonSerializable()
@HiveType(typeId: HIVE_TYPE_ID_PAYMENT_METHOD_FOR_HIVE, adapterName: "PaymentMethodVOAdapter")
class PaymentMethodVO {
  @JsonKey(name: "id")
  @HiveField(0)
  int? id;

  @JsonKey(name: "name")
  @HiveField(1)
  String? name;

  @JsonKey(name: "description")
  @HiveField(2)
  String? description;

  @HiveField(3)
  bool? isSelected = false;

  PaymentMethodVO(this.id, this.name, this.description);

  factory PaymentMethodVO.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodVOFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodVOToJson(this);
}