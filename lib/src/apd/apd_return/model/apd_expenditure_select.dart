class ApdExpenditureSelect {
  final String date;
  final String expNumber;
  final String vendor;
  ApdExpenditureSelect({
    required this.date,
    required this.expNumber,
    required this.vendor,
  });

  factory ApdExpenditureSelect.fromJson(Map<String, dynamic> json) {
    return ApdExpenditureSelect(
      date: json['date'],
      expNumber: json['expNumber'],
      vendor: json['vendor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'expNumber': expNumber,
      'vendor': vendor,
    };
  }
}
