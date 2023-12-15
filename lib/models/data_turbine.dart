import 'package:json_annotation/json_annotation.dart';

//part 'data_turbine.g.dart';
@JsonSerializable()
class DataTurbine {
  final double positionVanne;
   double positionVanneTarget;


   DataTurbine({
    required this.positionVanne,
    required this.positionVanneTarget,

  });

  setPos(double pos){
    positionVanneTarget = pos;
  }

  factory DataTurbine.fromJson(Map<String,dynamic>json ){
    return DataTurbine(
      positionVanne: json['Turbine']['positionVanne'], 
      positionVanneTarget: json['Turbine']['PositionVanneTarget']
      );
  }


}