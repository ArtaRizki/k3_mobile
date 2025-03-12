import 'package:k3_mobile/src/apd/apd_request/model/apd_request_model.dart';

class ApdRequestParam {
  final String id;
  final String unit;
  final String date;
  final String note;
  final String status;
  final List<ApdRequestModel> reqList;
  ApdRequestParam({
    required this.id,
    required this.unit,
    required this.date,
    required this.note,
    required this.status,
    required this.reqList,
  });

  factory ApdRequestParam.fromJson(Map<String, dynamic> json) {
    return ApdRequestParam(
      id: json['id'],
      unit: json['unit'],
      date: json['date'],
      note: json['note'],
      status: json['status'],
      reqList: json['req_list'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unit': unit,
      'date': date,
      'note': note,
      'status': status,
      'req_list': reqList,
    };
  }
}
