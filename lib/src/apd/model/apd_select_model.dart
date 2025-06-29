///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class ApdSelectModelData {
/*
{
  "id": "01jx6tpxkwghf6gp62sq27ng64",
  "code": "APD-000/WOM",
  "name": "SEPATU APD",
  "warna": "Merah",
  "ukuran_baju": "S",
  "ukuran_celana": "27",
  "ukuran_sepatu": "37",
  "jenis_sepatu": "Short",
  "kategori_name": "WEARPACK O&M"
} 
*/

  String? id;
  String? code;
  String? name;
  String? warna;
  String? ukuranBaju;
  String? ukuranCelana;
  String? ukuranSepatu;
  String? jenisSepatu;
  String? kategoriName;

  ApdSelectModelData({
    this.id,
    this.code,
    this.name,
    this.warna,
    this.ukuranBaju,
    this.ukuranCelana,
    this.ukuranSepatu,
    this.jenisSepatu,
    this.kategoriName,
  });
  ApdSelectModelData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    code = json['code']?.toString();
    name = json['name']?.toString();
    warna = json['warna']?.toString();
    ukuranBaju = json['ukuran_baju']?.toString();
    ukuranCelana = json['ukuran_celana']?.toString();
    ukuranSepatu = json['ukuran_sepatu']?.toString();
    jenisSepatu = json['jenis_sepatu']?.toString();
    kategoriName = json['kategori_name']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['warna'] = warna;
    data['ukuran_baju'] = ukuranBaju;
    data['ukuran_celana'] = ukuranCelana;
    data['ukuran_sepatu'] = ukuranSepatu;
    data['jenis_sepatu'] = jenisSepatu;
    data['kategori_name'] = kategoriName;
    return data;
  }
}

class ApdSelectModel {
/*
{
  "data": [
    {
      "id": "01jx6tpxkwghf6gp62sq27ng64",
      "code": "APD-000/WOM",
      "name": "SEPATU APD",
      "warna": "Merah",
      "ukuran_baju": "S",
      "ukuran_celana": "27",
      "ukuran_sepatu": "37",
      "jenis_sepatu": "Short",
      "kategori_name": "WEARPACK O&M"
    }
  ],
  "message": "Data berhasil diambil",
  "status": true
} 
*/

  List<ApdSelectModelData?>? data;
  String? message;
  bool? status;

  ApdSelectModel({
    this.data,
    this.message,
    this.status,
  });
  ApdSelectModel.fromJson(Map<String, dynamic> json) {
  if (json['data'] != null) {
  final v = json['data'];
  final arr0 = <ApdSelectModelData>[];
  v.forEach((v) {
  arr0.add(ApdSelectModelData.fromJson(v));
  });
    this.data = arr0;
    }
    message = json['message']?.toString();
    status = json['status'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
  v!.forEach((v) {
  arr0.add(v!.toJson());
  });
      data['data'] = arr0;
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
