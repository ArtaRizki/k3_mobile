class ApdReceptionSelect {
  final String date;
  final String reqNumber;
  final String note;
  ApdReceptionSelect({
    required this.date,
    required this.reqNumber,
    required this.note,
  });

  factory ApdReceptionSelect.fromJson(Map<String, dynamic> json) {
    return ApdReceptionSelect(
      date: json['date'],
      reqNumber: json['reqNumber'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'reqNumber': reqNumber,
      'note': note,
    };
  }
}
