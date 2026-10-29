class AppointmentModel {
  final String id;
  final String patientId;
  final String doctorId;
  final String appointmentDate;
  final String appointmentTime;
  final String appointmentType; // 'in-person' | 'video-call' | 'teleconsultation'
  final String status; // 'confirmed', 'pending', 'cancelled', 'completed'
  final String urgency; // 'Routine', 'Urgent', 'Emergency'
  final String? reason;
  final String? patientName;
  final String? doctorName;
  final String? specialty;
  final String? hospitalName;
  final String? postCareNotes;

  AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentType,
    this.status = 'confirmed',
    this.urgency = 'Routine',
    this.reason,
    this.patientName,
    this.doctorName,
    this.specialty,
    this.hospitalName,
    this.postCareNotes,
  });

  bool get isTeleconsult =>
      appointmentType == 'video-call' || appointmentType == 'teleconsultation';

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id']?.toString() ?? '',
      patientId: json['patient_id']?.toString() ?? '',
      doctorId: json['doctor_id']?.toString() ?? '',
      appointmentDate: json['appointment_date'] ?? json['date'] ?? '',
      appointmentTime: json['appointment_time'] ?? json['time'] ?? '10:00',
      appointmentType: json['appointment_type'] ?? 'in-person',
      status: json['status'] ?? 'confirmed',
      urgency: json['urgency'] ?? 'Routine',
      reason: json['reason_for_visit'] ?? json['reason'],
      patientName: json['patient_display_name'] ?? json['patient_name'],
      doctorName: json['doctor_name'] ?? json['doctors']?['full_name'],
      specialty: json['specialty'] ?? json['doctors']?['specialty'],
      hospitalName: json['hospital_name'] ?? json['doctors']?['hospital_name'],
      postCareNotes: json['post_care_notes'] ?? json['notes'],
    );
  }
}
