
import 'package:json_annotation/json_annotation.dart';

import 'data2.dart';

part 'ws_data.g.dart';

@JsonSerializable(explicitToJson: true)
class WsData {
  WsData(  this.data2) ;

  // @JsonKey(required: true,name: "data")
  // Map<String,dynamic> data;

  @JsonKey(name: "data")
  Data2  data2;


  factory WsData.fromJson(Map<String,dynamic> json) => _$WsDataFromJson(json);

  Map<String, dynamic> toJson() => _$WsDataToJson(this);
}

