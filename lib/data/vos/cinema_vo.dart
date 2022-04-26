import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_booking_app/data/vos/time_slot_vo.dart';
import 'package:movie_booking_app/persistence/hive_constants.dart';

part 'cinema_vo.g.dart';

@JsonSerializable()
@HiveType(typeId: HIVE_TYPE_ID_CINEMA_VO, adapterName: "CinemaVOAdapter")
class CinemaVO {
  @JsonKey(name: "cinema_id")
  @HiveField(0)
  int? cinemaId;

  @JsonKey(name: "cinema")
  @HiveField(1)
  String? cinema;

  @JsonKey(name: "timeslots")
  @HiveField(2)
  List<TimeSlotVO>? timeSlots;

  CinemaVO(this.cinemaId, this.cinema, this.timeSlots);

  factory CinemaVO.fromJson(Map<String, dynamic> json) =>
      _$CinemaVOFromJson(json);

  Map<String, dynamic> toJson() => _$CinemaVOToJson(this);

  @override
  String toString() {
    return 'CinemaVO{cinemaId: $cinemaId, cinema: $cinema, timeSlots: $timeSlots}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CinemaVO &&
          runtimeType == other.runtimeType &&
          cinemaId == other.cinemaId &&
          cinema == other.cinema &&
          timeSlots == other.timeSlots;

  @override
  int get hashCode => cinemaId.hashCode ^ cinema.hashCode ^ timeSlots.hashCode;
}