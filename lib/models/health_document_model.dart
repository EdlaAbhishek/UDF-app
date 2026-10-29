class HealthDocumentModel {
  final String id;
  final String title;
  final String category; // 'lab_report', 'prescription', 'doctor_notes', 'imaging', 'vaccination'
  final String hospitalLab;
  final String? doctorName;
  final String reportDate;
  final String verification; // 'verified', 'unverified'
  final String? summary;
  final String? fileName;

  HealthDocumentModel({
    required this.id,
    required this.title,
    required this.category,
    required this.hospitalLab,
    this.doctorName,
    required this.reportDate,
    this.verification = 'verified',
    this.summary,
    this.fileName,
  });

  factory HealthDocumentModel.fromJson(Map<String, dynamic> json) {
    return HealthDocumentModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Medical Document',
      category: json['category'] ?? 'lab_report',
      hospitalLab: json['hospital_lab'] ?? 'Diagnostics',
      doctorName: json['doctor_name'],
      reportDate: json['report_date'] ?? '2026-09-01',
      verification: json['verification'] ?? 'verified',
      summary: json['summary'],
      fileName: json['file_name'],
    );
  }
}
