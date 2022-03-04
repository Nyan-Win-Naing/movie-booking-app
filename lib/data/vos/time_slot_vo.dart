import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

part 'time_slot_vo.g.dart';

@JsonSerializable()
@HiveType(typeId: HIVE_TYPE_ID_TIME_SLOT_VO, adapterName: "TimeSlotVOAdapter")
class TimeSlotVO {
  @JsonKey(name: "cinema_day_timeslot_id")
  @HiveField(0)
  int? timeslotId;

  @JsonKey(name: "start_time")
  @HiveField(1)
  String? startTime;

  @HiveField(2)
  bool? isSelected = false;

  TimeSlotVO(this.timeslotId, this.startTime);

  factory TimeSlotVO.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotVOFromJson(json);

  Map<String, dynamic> toJson() => _$TimeSlotVOToJson(this);
}