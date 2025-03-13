class ApdReceptionModel {
  final String code;
  final String name;
  final String qty;
  final String remainingQty;
  String receivedQty;
  ApdReceptionModel({
    required this.code,
    required this.name,
    required this.qty,
    required this.remainingQty,
    required this.receivedQty,
  });

  factory ApdReceptionModel.fromJson(Map<String, dynamic> json) {
    return ApdReceptionModel(
      code: json['code'],
      name: json['name'],
      qty: json['qty'],
      remainingQty: json['remaining_qty'],
      receivedQty: json['received_qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'qty': qty,
      'remaining_qty': remainingQty,
      'received_qty': receivedQty,
    };
  }
}
