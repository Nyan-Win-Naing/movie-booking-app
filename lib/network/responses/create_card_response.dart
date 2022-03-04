import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/data/vos/card_vo.dart';

part 'create_card_response.g.dart';

@JsonSerializable()
class CreateCardResponse {
  @JsonKey(name: "code")
  int? code;

  @JsonKey(name: "message")
  String? message;

  @JsonKey(name: "data")
  List<CardVO>? data;

  CreateCardResponse(this.code, this.message, this.data);

  factory CreateCardResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateCardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCardResponseToJson(this);
}