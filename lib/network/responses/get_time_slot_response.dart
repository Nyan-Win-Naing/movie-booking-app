import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';

part 'get_time_slot_response.g.dart';

@JsonSerializable()
class GetTimeSlotResponse {
  @JsonKey(name: "code")
  int? code;

  @JsonKey(name: "message")
  String? message;

  @JsonKey(name: "data")
  List<CinemaVO>? results;

  GetTimeSlotResponse(this.code, this.message, this.results);

  factory GetTimeSlotResponse.fromJson(Map<String, dynamic> json) =>
      _$GetTimeSlotResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetTimeSlotResponseToJson(this);

  @override
  String toString() {
    return 'GetTimeSlotResponse{code: $code, message: $message, results: $results}';
  }
}