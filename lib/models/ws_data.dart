import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';

part 'ws_data.g.dart';

@JsonSerializable(explicitToJson: true)
class WsData {
  WsData( this.data) {
    log("par là $data");
  }

  @JsonKey(required: true,name: "data")
  Map<String,dynamic> data;

  factory WsData.fromJson(Map<String,dynamic> json) => _$WsDataFromJson(json);

  Map<String, dynamic> toJson() => _$WsDataToJson(this);
}