class ApdRequestModel {
  final String code;
  final String name;
  final String qty;
  ApdRequestModel({
    required this.code,
    required this.name,
    required this.qty,
  });

  factory ApdRequestModel.fromJson(Map<String, dynamic> json) {
    return ApdRequestModel(
      code: json['code'],
      name: json['name'],
      qty: json['qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'qty': qty,
    };
  }
}
