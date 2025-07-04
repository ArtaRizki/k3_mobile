///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class InspectionCreateResponseData {
/*
{
  "code": "000/F.INS-NM/K3L-MKP/X/2025",
  "name": "hicun3 proyek",
  "md_karyawan_id": "01jrsza631k8d1e2fn09y71g73",
  "md_proyek_id": "01jrsza5x8924n7p7qmnh00c03",
  "type": "1",
  "doc_date": "2025-10-04 21:00:00",
  "md_kategori_inspeksi_id": "01jwnx7qy24xv459axx727rjj6",
  "resiko": "resikooo boss",
  "lokasi": "serlokk",
  "kronologi": "jadigini",
  "is_action": "1",
  "alasan": "apa yaaaa",
  "saran": "nggak tauu",
  "rincian_tindakan": "awoooo",
  "apv_level": 0,
  "doc_status": 0,
  "tindak_lanjut": 0,
  "tindakan_tindak_lanjut": "",
  "id": "01jwp01zn0pd20zrck7zv6wdng",
  "updated_at": "2025-06-01T14:59:12.000000Z",
  "created_at": "2025-06-01T14:59:12.000000Z"
} 
*/

  String? code;
  String? name;
  String? mdKaryawanId;
  String? mdProyekId;
  String? type;
  String? docDate;
  String? mdKategoriInspeksiId;
  String? resiko;
  String? lokasi;
  String? kronologi;
  String? isAction;
  String? alasan;
  String? saran;
  String? rincianTindakan;
  int? apvLevel;
  int? docStatus;
  int? tindakLanjut;
  String? tindakanTindakLanjut;
  String? id;
  String? updatedAt;
  String? createdAt;

  InspectionCreateResponseData({
    this.code,
    this.name,
    this.mdKaryawanId,
    this.mdProyekId,
    this.type,
    this.docDate,
    this.mdKategoriInspeksiId,
    this.resiko,
    this.lokasi,
    this.kronologi,
    this.isAction,
    this.alasan,
    this.saran,
    this.rincianTindakan,
    this.apvLevel,
    this.docStatus,
    this.tindakLanjut,
    this.tindakanTindakLanjut,
    this.id,
    this.updatedAt,
    this.createdAt,
  });
  InspectionCreateResponseData.fromJson(Map<String, dynamic> json) {
    code = json['code']?.toString();
    name = json['name']?.toString();
    mdKaryawanId = json['md_karyawan_id']?.toString();
    mdProyekId = json['md_proyek_id']?.toString();
    type = json['type']?.toString();
    docDate = json['doc_date']?.toString();
    mdKategoriInspeksiId = json['md_kategori_inspeksi_id']?.toString();
    resiko = json['resiko']?.toString();
    lokasi = json['lokasi']?.toString();
    kronologi = json['kronologi']?.toString();
    isAction = json['is_action']?.toString();
    alasan = json['alasan']?.toString();
    saran = json['saran']?.toString();
    rincianTindakan = json['rincian_tindakan']?.toString();
    apvLevel = json['apv_level']?.toInt();
    docStatus = json['doc_status']?.toInt();
    tindakLanjut = json['tindak_lanjut']?.toInt();
    tindakanTindakLanjut = json['tindakan_tindak_lanjut']?.toString();
    id = json['id']?.toString();
    updatedAt = json['updated_at']?.toString();
    createdAt = json['created_at']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['md_karyawan_id'] = mdKaryawanId;
    data['md_proyek_id'] = mdProyekId;
    data['type'] = type;
    data['doc_date'] = docDate;
    data['md_kategori_inspeksi_id'] = mdKategoriInspeksiId;
    data['resiko'] = resiko;
    data['lokasi'] = lokasi;
    data['kronologi'] = kronologi;
    data['is_action'] = isAction;
    data['alasan'] = alasan;
    data['saran'] = saran;
    data['rincian_tindakan'] = rincianTindakan;
    data['apv_level'] = apvLevel;
    data['doc_status'] = docStatus;
    data['tindak_lanjut'] = tindakLanjut;
    data['tindakan_tindak_lanjut'] = tindakanTindakLanjut;
    data['id'] = id;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}

class InspectionCreateResponse {
/*
{
  "data": {
    "code": "000/F.INS-NM/K3L-MKP/X/2025",
    "name": "hicun3 proyek",
    "md_karyawan_id": "01jrsza631k8d1e2fn09y71g73",
    "md_proyek_id": "01jrsza5x8924n7p7qmnh00c03",
    "type": "1",
    "doc_date": "2025-10-04 21:00:00",
    "md_kategori_inspeksi_id": "01jwnx7qy24xv459axx727rjj6",
    "resiko": "resikooo boss",
    "lokasi": "serlokk",
    "kronologi": "jadigini",
    "is_action": "1",
    "alasan": "apa yaaaa",
    "saran": "nggak tauu",
    "rincian_tindakan": "awoooo",
    "apv_level": 0,
    "doc_status": 0,
    "tindak_lanjut": 0,
    "tindakan_tindak_lanjut": "",
    "id": "01jwp01zn0pd20zrck7zv6wdng",
    "updated_at": "2025-06-01T14:59:12.000000Z",
    "created_at": "2025-06-01T14:59:12.000000Z"
  },
  "message": "Data berhasil disimpan",
  "status": true
} 
*/

  InspectionCreateResponseData? data;
  String? message;
  bool? status;

  InspectionCreateResponse({
    this.data,
    this.message,
    this.status,
  });
  InspectionCreateResponse.fromJson(Map<String, dynamic> json) {
    data = (json['data'] != null) ? InspectionCreateResponseData.fromJson(json['data']) : null;
    message = json['message']?.toString();
    status = json['status'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['data'] = this.data!.toJson();
      data['message'] = message;
    data['status'] = status;
    return data;
  }
}
