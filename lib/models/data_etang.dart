class DataEtang {
  final double niveauEtang;
  final double niveauEtangP;


  const DataEtang({
    required this.niveauEtang,
    required this.niveauEtangP,
  });

  factory DataEtang.fromJson(Map<String, dynamic> json) {
    return DataEtang(
      niveauEtang: json['niveauEtang'] , 
      niveauEtangP: json['niveauEtangP']);
  }

}