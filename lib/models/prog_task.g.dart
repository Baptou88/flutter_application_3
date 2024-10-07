// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prog_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgTask _$ProgTaskFromJson(Map<String, dynamic> json) => ProgTask(
      active: json['active'] as bool,
      time: const MyJsonConverter().fromJson(json['time'] as String),
      name: json['name'] as String,
      targetVanne: json['targetVanne'] as int,
    );

Map<String, dynamic> _$ProgTaskToJson(ProgTask instance) => <String, dynamic>{
      'name': instance.name,
      'active': instance.active,
      'targetVanne': instance.targetVanne,
      'time': const MyJsonConverter().toJson(instance.time),
    };
