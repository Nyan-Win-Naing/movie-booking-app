// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_snack_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSnackListResponse _$GetSnackListResponseFromJson(
        Map<String, dynamic> json) =>
    GetSnackListResponse(
      json['code'] as int?,
      json['message'] as String?,
      (json['data'] as List<dynamic>?)
          ?.map((e) => SnackVO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetSnackListResponseToJson(
        GetSnackListResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
