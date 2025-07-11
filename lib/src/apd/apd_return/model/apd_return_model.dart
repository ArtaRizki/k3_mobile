///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class ApdReturnModelDataDetailPengembalian {
/*
{
  "id": "01jzqfs9a0aad4f22y1sfv6c3b",
  "apd_name": "Wearpack Proyek",
  "qty_available": 20
} 
*/

  String? id;
  String? apdName;
  int? qtyAvailable;

  ApdReturnModelDataDetailPengembalian({
    this.id,
    this.apdName,
    this.qtyAvailable,
  });
  ApdReturnModelDataDetailPengembalian.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    apdName = json['apd_name']?.toString();
    qtyAvailable = json['qty_available']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['apd_name'] = apdName;
    data['qty_available'] = qtyAvailable;
    return data;
  }
}

class ApdReturnModelData {
/*
{
  "id": "01jzqfs99wpycjz2d32q57g66d",
  "doc_date": "09/07/2025",
  "request_date": "09/07/2025",
  "code": "001/GR/K3L-MKP/VII/2025",
  "request_code": "005/REQ/K3L-MKP/VII/2025",
  "pengeluaran_code": "003/GI/K3L-MKP/VI/2025",
  "vendor_name": "PT Xeno Persada Teknologi",
  "deskripsi": "hhhh",
  "status": "Draft",
  "longitude": "",
  "latitude": "",
  "unit_name": "Surabaya",
  "detail_pengembalian": [
    {
      "id": "01jzqfs9a0aad4f22y1sfv6c3b",
      "apd_name": "Wearpack Proyek",
      "qty_available": 20
    }
  ]
} 
*/

  String? id;
  String? docDate;
  String? requestDate;
  String? code;
  String? requestCode;
  String? pengeluaranCode;
  String? vendorName;
  String? deskripsi;
  String? status;
  String? longitude;
  String? latitude;
  String? unitName;
  List<ApdReturnModelDataDetailPengembalian?>? detailPengembalian;

  ApdReturnModelData({
    this.id,
    this.docDate,
    this.requestDate,
    this.code,
    this.requestCode,
    this.pengeluaranCode,
    this.vendorName,
    this.deskripsi,
    this.status,
    this.longitude,
    this.latitude,
    this.unitName,
    this.detailPengembalian,
  });
  ApdReturnModelData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    docDate = json['doc_date']?.toString();
    requestDate = json['request_date']?.toString();
    code = json['code']?.toString();
    requestCode = json['request_code']?.toString();
    pengeluaranCode = json['pengeluaran_code']?.toString();
    vendorName = json['vendor_name']?.toString();
    deskripsi = json['deskripsi']?.toString();
    status = json['status']?.toString();
    longitude = json['longitude']?.toString();
    latitude = json['latitude']?.toString();
    unitName = json['unit_name']?.toString();
  if (json['detail_pengembalian'] != null) {
  final v = json['detail_pengembalian'];
  final arr0 = <ApdReturnModelDataDetailPengembalian>[];
  v.forEach((v) {
  arr0.add(ApdReturnModelDataDetailPengembalian.fromJson(v));
  });
    detailPengembalian = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['doc_date'] = docDate;
    data['request_date'] = requestDate;
    data['code'] = code;
    data['request_code'] = requestCode;
    data['pengeluaran_code'] = pengeluaranCode;
    data['vendor_name'] = vendorName;
    data['deskripsi'] = deskripsi;
    data['status'] = status;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['unit_name'] = unitName;
    if (detailPengembalian != null) {
      final v = detailPengembalian;
      final arr0 = [];
  v!.forEach((v) {
  arr0.add(v!.toJson());
  });
      data['detail_pengembalian'] = arr0;
    }
    return data;
  }
}

class ApdReturnModel {
/*
{
  "data": [
    {
      "id": "01jzqfs99wpycjz2d32q57g66d",
      "doc_date": "09/07/2025",
      "request_date": "09/07/2025",
      "code": "001/GR/K3L-MKP/VII/2025",
      "request_code": "005/REQ/K3L-MKP/VII/2025",
      "pengeluaran_code": "003/GI/K3L-MKP/VI/2025",
      "vendor_name": "PT Xeno Persada Teknologi",
      "deskripsi": "hhhh",
      "status": "Draft",
      "longitude": "",
      "latitude": "",
      "unit_name": "Surabaya",
      "detail_pengembalian": [
        {
          "id": "01jzqfs9a0aad4f22y1sfv6c3b",
          "apd_name": "Wearpack Proyek",
          "qty_available": 20
        }
      ]
    }
  ],
  "message": "Data berhasil diambil",
  "status": true
} 
*/

  List<ApdReturnModelData?>? data;
  String? message;
  bool? status;

  ApdReturnModel({
    this.data,
    this.message,
    this.status,
  });
  ApdReturnModel.fromJson(Map<String, dynamic> json) {
  if (json['data'] != null) {
  final v = json['data'];
  final arr0 = <ApdReturnModelData>[];
  v.forEach((v) {
  arr0.add(ApdReturnModelData.fromJson(v));
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
