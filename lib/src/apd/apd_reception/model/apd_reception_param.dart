
import 'package:k3_mobile/src/apd/apd_reception/model/apd_reception_model.dart';

class ApdReceptionParam {
  final String id;
  final String unit;
  final String date;
  final String reqNumber;
  final String expNumber;
  final String vendor;
  final String note;
  final String status;
  final List<String> images;
  final String signature;
  final List<ApdReceptionModel> recList;
  ApdReceptionParam({
    required this.id,
    required this.unit,
    required this.date,
    required this.reqNumber,
    required this.expNumber,
    required this.vendor,
    required this.note,
    required this.status,
    required this.images,
    required this.signature,
    required this.recList,
  });

  factory ApdReceptionParam.fromJson(Map<String, dynamic> json) {
    return ApdReceptionParam(
      id: json['id'],
      unit: json['unit'],
      date: json['date'],
      reqNumber: json['req_number'],
      expNumber: json['exp_number'],
      vendor: json['vendor'],
      note: json['note'],
      status: json['status'],
      images: json['images'],
      signature: json['signature'],
      recList: json['req_list'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unit': unit,
      'date': date,
      'req_number': reqNumber,
      'exp_number': expNumber,
      'vendor': vendor,
      'note': note,
      'status': status,
      'images': images,
      'signature': signature,
      'req_list': recList,
    };
  }
}
