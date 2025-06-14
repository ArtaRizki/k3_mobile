///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class InspectionViewModelData {
  /*
{
  "id": "01jxd85kpxh49h4pywx3mcte40",
  "created_at": "10/06/2025",
  "code": "000/F.INS-UA/K3L-MKP/X/2025",
  "type": "0",
  "kategori_name": "null",
  "kategori_id": "01jx5m22bpq176mbhn07g79eal",
  "doc_status": "0",
  "lokasi": "lokasi1",
  "petugas": "Admin K3",
  "petugas_id": "01jx5m236advexa306q0cyhqee",
  "proyek": "null",
  "proyek_id": "null",
  "unit": "Kantor Pusat",
  "unit_id": "01jx5m230nsp9r160yb6n59g46",
  "doc_date": "06/10/2025 00:00",
  "resiko": "resiko1",
  "kronologi": "kronologi1",
  "dilakukan_tindakan": 1,
  "alasan": "alasan1",
  "rincian_tindakan": "rincian1",
  "saran": "saran1"
} 
*/

  String? id;
  String? createdAt;
  String? code;
  String? type;
  String? kategoriName;
  String? kategoriId;
  String? docStatus;
  String? lokasi;
  String? petugas;
  String? petugasId;
  String? proyek;
  String? proyekId;
  String? unit;
  String? unitId;
  String? docDate;
  String? resiko;
  String? kronologi;
  int? dilakukanTindakan;
  String? alasan;
  String? rincianTindakan;
  String? saran;

  InspectionViewModelData({
    this.id,
    this.createdAt,
    this.code,
    this.type,
    this.kategoriName,
    this.kategoriId,
    this.docStatus,
    this.lokasi,
    this.petugas,
    this.petugasId,
    this.proyek,
    this.proyekId,
    this.unit,
    this.unitId,
    this.docDate,
    this.resiko,
    this.kronologi,
    this.dilakukanTindakan,
    this.alasan,
    this.rincianTindakan,
    this.saran,
  });
  InspectionViewModelData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    createdAt = json['created_at']?.toString();
    code = json['code']?.toString();
    type = json['type']?.toString();
    kategoriName = json['kategori_name']?.toString();
    kategoriId = json['kategori_id']?.toString();
    docStatus = json['doc_status']?.toString();
    lokasi = json['lokasi']?.toString();
    petugas = json['petugas']?.toString();
    petugasId = json['petugas_id']?.toString();
    proyek = json['proyek']?.toString();
    proyekId = json['proyek_id']?.toString();
    unit = json['unit']?.toString();
    unitId = json['unit_id']?.toString();
    docDate = json['doc_date']?.toString();
    resiko = json['resiko']?.toString();
    kronologi = json['kronologi']?.toString();
    dilakukanTindakan = json['dilakukan_tindakan']?.toInt();
    alasan = json['alasan']?.toString();
    rincianTindakan = json['rincian_tindakan']?.toString();
    saran = json['saran']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['code'] = code;
    data['type'] = type;
    data['kategori_name'] = kategoriName;
    data['kategori_id'] = kategoriId;
    data['doc_status'] = docStatus;
    data['lokasi'] = lokasi;
    data['petugas'] = petugas;
    data['petugas_id'] = petugasId;
    data['proyek'] = proyek;
    data['proyek_id'] = proyekId;
    data['unit'] = unit;
    data['unit_id'] = unitId;
    data['doc_date'] = docDate;
    data['resiko'] = resiko;
    data['kronologi'] = kronologi;
    data['dilakukan_tindakan'] = dilakukanTindakan;
    data['alasan'] = alasan;
    data['rincian_tindakan'] = rincianTindakan;
    data['saran'] = saran;
    return data;
  }
}

class InspectionViewModel {
  /*
{
  "data": {
    "id": "01jxd85kpxh49h4pywx3mcte40",
    "created_at": "10/06/2025",
    "code": "000/F.INS-UA/K3L-MKP/X/2025",
    "type": "0",
    "kategori_name": "null",
    "kategori_id": "01jx5m22bpq176mbhn07g79eal",
    "doc_status": "0",
    "lokasi": "lokasi1",
    "petugas": "Admin K3",
    "petugas_id": "01jx5m236advexa306q0cyhqee",
    "proyek": "null",
    "proyek_id": "null",
    "unit": "Kantor Pusat",
    "unit_id": "01jx5m230nsp9r160yb6n59g46",
    "doc_date": "06/10/2025 00:00",
    "resiko": "resiko1",
    "kronologi": "kronologi1",
    "dilakukan_tindakan": 1,
    "alasan": "alasan1",
    "rincian_tindakan": "rincian1",
    "saran": "saran1"
  },
  "message": "Data berhasil diambil",
  "status": true
} 
*/

  InspectionViewModelData? data;
  String? message;
  bool? status;

  InspectionViewModel({this.data, this.message, this.status});
  InspectionViewModel.fromJson(Map<String, dynamic> json) {
    data =
        (json['data'] != null)
            ? InspectionViewModelData.fromJson(json['data'])
            : null;
    message = json['message']?.toString();
    status = json['status'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
