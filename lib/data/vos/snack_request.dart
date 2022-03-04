import 'package:json_annotation/json_annotation.dart';

part 'snack_request.g.dart';

@JsonSerializable()
class SnackRequest {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "quantity")
  int quantity;

  SnackRequest(this.id, this.quantity);

  factory SnackRequest.fromJson(Map<String, dynamic> json) =>
      _$SnackRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SnackRequestToJson(this);

  @override
  String toString() {
    return 'SnackRequest{id: $id, quantity: $quantity}';
  }
}