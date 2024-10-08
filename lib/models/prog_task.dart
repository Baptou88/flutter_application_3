import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prog_task.g.dart';

class MyJsonConverter extends JsonConverter<TimeOfDay, String> {
  const MyJsonConverter();
  @override
  TimeOfDay fromJson(String json) {
    final List part = json.split(":");
    return TimeOfDay(
      hour: int.tryParse(part.first ?? '')??-1, 
      minute: int.tryParse(part.last ?? '')??-1
      );
  }

  @override
  String toJson(TimeOfDay object) {
    
    return "${object.hour}:${object.minute}";
  }

}

@JsonSerializable()
class ProgTask {
  ProgTask(
      {required this.active,
      required this.time,
      
      required this.name,
      required this.targetVanne});

  String name;
  bool active;
  int targetVanne;
  @MyJsonConverter()
  TimeOfDay time;

@JsonKey(includeFromJson: false, includeToJson: true)
  int id = 0 ;

  // factory ProgTask.fromJson(Map<String, dynamic> json) {
    
  //   return ProgTask(
  //       active: json['active'],
  //       time: TimeOfDay(hour: json['h'], minute: json['m']),
  //       name: json['name'],
  //       targetVanne: json['targetVanne']);
  // }

  factory ProgTask.fromJson(Map<String,dynamic> json ) => _$ProgTaskFromJson(json);

  Map<String, dynamic> toJson() => _$ProgTaskToJson(this) ;
}