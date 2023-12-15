import 'package:json_annotation/json_annotation.dart';

part 'data_etang.g.dart';

@JsonSerializable()
class DataEtang {
  
  final double niveauEtang;
  final double niveauEtangP;


  const DataEtang({
    required this.niveauEtang,
    required this.niveauEtangP,
  });

  factory DataEtang.fromJson(Map<String,dynamic> json) => _$DataEtangFromJson(json);

  Map<String, dynamic> toJson() => _$DataEtangToJson(this) ;
}