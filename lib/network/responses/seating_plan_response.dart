import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/data/vos/cinema_seat_vo.dart';

part 'seating_plan_response.g.dart';

@JsonSerializable()
class SeatingPlanResponse {
  @JsonKey(name: "code")
  int? responseCode;

  @JsonKey(name: "message")
  String? responseMessage;

  @JsonKey(name: "data")
  List<List<CinemaSeatVO>>? seatData;

  SeatingPlanResponse(
    this.responseCode,
    this.responseMessage,
    this.seatData,
  );

  factory SeatingPlanResponse.fromJson(Map<String, dynamic> json) =>
      _$SeatingPlanResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SeatingPlanResponseToJson(this);
}
