// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_card_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCardResponse _$CreateCardResponseFromJson(Map<String, dynamic> json) =>
    CreateCardResponse(
      json['code'] as int?,
      json['message'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => CardVO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreateCardResponseToJson(CreateCardResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
