class ApdReturnModel {
  final String code;
  final String name;
  final String qty;
  final String remainingQty;
  String returnQty;
  ApdReturnModel({
    required this.code,
    required this.name,
    required this.qty,
    required this.remainingQty,
    required this.returnQty,
  });

  factory ApdReturnModel.fromJson(Map<String, dynamic> json) {
    return ApdReturnModel(
      code: json['code'],
      name: json['name'],
      qty: json['qty'],
      remainingQty: json['remaining_qty'],
      returnQty: json['received_qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'qty': qty,
      'remaining_qty': remainingQty,
      'received_qty': returnQty,
    };
  }
}
