// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WsData _$WsDataFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['data'],
  );
  return WsData(
    json['data'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$WsDataToJson(WsData instance) => <String, dynamic>{
      'data': instance.data,
    };
