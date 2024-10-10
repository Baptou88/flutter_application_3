import 'package:json_annotation/json_annotation.dart';

part 'data_turbine.g.dart';

@JsonSerializable()
class DataTurbine {
  final double positionVanne;
  
  @JsonKey(name: "PositionVanneTarget")
  double positionVanneTarget;

  double tacky;

  double tension;

  double intensite;

   DataTurbine({
    required this.positionVanne,
    required this.positionVanneTarget,
    required this.intensite,
    required this.tension,
    required this.tacky
  });

  setPos(double pos){
    positionVanneTarget = pos;
  }

  factory DataTurbine.fromJson(Map<String,dynamic>json )=> _$DataTurbineFromJson(json);

  Map<String,dynamic> toJson()=> _$DataTurbineToJson(this);


}