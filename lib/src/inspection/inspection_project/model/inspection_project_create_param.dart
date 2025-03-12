class InspectionProjectCreateParam {
  final String projectName;
  final String date; // Format: dd-mm-yyyy
  final String time; // Format: hh:mm
  final String category;
  final String risk;
  final String location; // Lokasi kejadian
  final String eventDescription; // Deskripsi kejadian
  final bool actionTaken; // Dilakukan tindakan? (Ya/Tidak)
  final String reason; // Alasan
  final String actionDetails; // Rincian tindakan
  final List<String> image; // Placeholder for image data (can be a file path or URL)

  InspectionProjectCreateParam({
    required this.projectName,
    required this.date,
    required this.time,
    required this.category,
    required this.risk,
    required this.location,
    required this.eventDescription,
    required this.actionTaken,
    required this.reason,
    required this.actionDetails,
    required this.image,
  });

  // Factory method to create an InspectionProjectCreateParam from a JSON map
  factory InspectionProjectCreateParam.fromJson(Map<String, dynamic> json) {
    return InspectionProjectCreateParam(
      projectName: json['projectName'],
      date: json['date'],
      time: json['time'],
      category: json['category'],
      risk: json['risk'],
      location: json['location'],
      eventDescription: json['eventDescription'],
      actionTaken: json['actionTaken'],
      reason: json['reason'],
      actionDetails: json['actionDetails'],
      image: json['image'] ?? [], // Optional field
    );
  }

  // Convert InspectionProjectCreateParam to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'projectName': projectName,
      'date': date,
      'time': time,
      'category': category,
      'risk': risk,
      'location': location,
      'eventDescription': eventDescription,
      'actionTaken': actionTaken,
      'reason': reason,
      'actionDetails': actionDetails,
      'image': image,
    };
  }
}