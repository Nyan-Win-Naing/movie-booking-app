// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_time_slot_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTimeSlotResponse _$GetTimeSlotResponseFromJson(Map<String, dynamic> json) =>
    GetTimeSlotResponse(
      json['code'] as int?,
      json['message'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => CinemaVO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetTimeSlotResponseToJson(
        GetTimeSlotResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.results,
    };
