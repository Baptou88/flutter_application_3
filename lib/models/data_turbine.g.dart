// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_turbine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataTurbine _$DataTurbineFromJson(Map<String, dynamic> json) => DataTurbine(
      positionVanne: (json['positionVanne'] as num).toDouble(),
      positionVanneTarget: (json['PositionVanneTarget'] as num).toDouble(),
    );

Map<String, dynamic> _$DataTurbineToJson(DataTurbine instance) =>
    <String, dynamic>{
      'positionVanne': instance.positionVanne,
      'PositionVanneTarget': instance.positionVanneTarget,
    };
