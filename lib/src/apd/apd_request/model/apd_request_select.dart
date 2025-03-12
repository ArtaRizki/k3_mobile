import 'package:k3_mobile/src/apd/apd_request/model/apd_request_model.dart';

class ApdRequestSelect {
  final String code;
  final String category;
  final String name;
  ApdRequestSelect({
    required this.code,
    required this.category,
    required this.name,
  });

  factory ApdRequestSelect.fromJson(Map<String, dynamic> json) {
    return ApdRequestSelect(
      code: json['code'],
      category: json['category'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'category': category,
      'name': name,
    };
  }
}
