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