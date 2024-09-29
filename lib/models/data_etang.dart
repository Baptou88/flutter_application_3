
import 'package:json_annotation/json_annotation.dart';

part 'data_etang.g.dart';
class MyJsonConverter extends JsonConverter<double, String> {
  const MyJsonConverter();
  @override
  double fromJson(String json) {
    return json as double;
  }

  @override
  String toJson(double object) {
    
    throw UnimplementedError();
  }

}
@JsonSerializable()
class DataEtang {
  
  final double niveauEtang;
  //@JsonKey(name: "ratioNiveauEtang")
  final double niveauEtangP;


  const DataEtang({
    required this.niveauEtang,
    required this.niveauEtangP,
  });

  factory DataEtang.fromJson(Map<String,dynamic> json) => _$DataEtangFromJson(json);

  Map<String, dynamic> toJson() => _$DataEtangToJson(this) ;
}