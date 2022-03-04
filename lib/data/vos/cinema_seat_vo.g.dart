// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema_seat_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CinemaSeatVO _$CinemaSeatVOFromJson(Map<String, dynamic> json) => CinemaSeatVO(
      json['id'] as int?,
      json['type'] as String?,
      json['seat_name'] as String?,
      json['symbol'] as String?,
      json['price'] as int?,
    )..isSelected = json['isSelected'] as bool?;

Map<String, dynamic> _$CinemaSeatVOToJson(CinemaSeatVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'seat_name': instance.seatName,
      'symbol': instance.symbol,
      'price': instance.price,
      'isSelected': instance.isSelected,
    };
