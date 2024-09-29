import 'package:json_annotation/json_annotation.dart';

part 'data_turbine.g.dart';

@JsonSerializable()
class DataTurbine {
  final double positionVanne;
  
  @JsonKey(name: "PositionVanneTarget")
  double positionVanneTarget;


   DataTurbine({
    required this.positionVanne,
    required this.positionVanneTarget,

  });

  setPos(double pos){
    positionVanneTarget = pos;
  }

  factory DataTurbine.fromJson(Map<String,dynamic>json )=> _$DataTurbineFromJson(json);

  Map<String,dynamic> toJson()=> _$DataTurbineToJson(this);


}