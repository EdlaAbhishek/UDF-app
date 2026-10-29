class QueueTokenModel {
  final String id;
  final String tokenNumber;
  final String hospitalName;
  final String department;
  final String doctorName;
  final String status; // 'waiting', 'checked_in', 'in_consultation', 'completed'
  final int peopleAhead;
  final int estimatedWaitMinutes;
  final String createdAt;

  QueueTokenModel({
    required this.id,
    required this.tokenNumber,
    required this.hospitalName,
    required this.department,
    required this.doctorName,
    required this.status,
    required this.peopleAhead,
    required this.estimatedWaitMinutes,
    required this.createdAt,
  });

  factory QueueTokenModel.fromJson(Map<String, dynamic> json) {
    return QueueTokenModel(
      id: json['id']?.toString() ?? '',
      tokenNumber: json['token_number']?.toString() ?? json['token']?.toString() ?? 'A-101',
      hospitalName: json['hospital_name'] ?? 'Apollo Hospitals',
      department: json['department'] ?? 'General Medicine',
      doctorName: json['doctor_name'] ?? 'Dr. Priya Sharma',
      status: json['status'] ?? 'waiting',
      peopleAhead: json['people_ahead'] ?? 3,
      estimatedWaitMinutes: json['estimated_wait_minutes'] ?? 25,
      createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
    );
  }
}
