import 'package:flutter_application_3/models/data_etang.dart';
import 'package:json_annotation/json_annotation.dart';

import 'data_turbine.dart';

part 'data2.g.dart';
@JsonSerializable(explicitToJson: true)
class Data2 {
  Data2(this.mode,this.notification,this.notificationGroup,this.dataEtang,this.dataTurbine);

  @JsonKey(name: "Mode")
  int mode;

 @JsonKey(name: "Notification")
  int notification;
 @JsonKey(name: "NotificationGroup")
  int notificationGroup;

@JsonKey(name: "Etang")
  DataEtang dataEtang;
@JsonKey(name: "Turbine")
  DataTurbine dataTurbine;


  factory Data2.fromJson(Map<String,dynamic> json) => _$Data2FromJson(json);

  Map<String, dynamic> toJson() => _$Data2ToJson(this);
}