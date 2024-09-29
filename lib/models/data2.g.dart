// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data2 _$Data2FromJson(Map<String, dynamic> json) => Data2(
      json['Mode'] as int,
      json['Notification'] as int,
      json['NotificationGroup'] as int,
      DataEtang.fromJson(json['Etang'] as Map<String, dynamic>),
      DataTurbine.fromJson(json['Turbine'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$Data2ToJson(Data2 instance) => <String, dynamic>{
      'Mode': instance.mode,
      'Notification': instance.notification,
      'NotificationGroup': instance.notificationGroup,
      'Etang': instance.dataEtang.toJson(),
      'Turbine': instance.dataTurbine.toJson(),
    };
