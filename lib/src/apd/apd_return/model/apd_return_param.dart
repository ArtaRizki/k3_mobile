
import 'package:k3_mobile/src/apd/apd_return/model/apd_return_model.dart';

class ApdReturnParam {
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
  final List<ApdReturnModel> recList;
  ApdReturnParam({
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

  factory ApdReturnParam.fromJson(Map<String, dynamic> json) {
    return ApdReturnParam(
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
