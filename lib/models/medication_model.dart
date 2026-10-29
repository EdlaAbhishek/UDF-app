class MedicationModel {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final String timing;
  final String instructions;
  final int durationDays;
  final String startDate;
  bool isTaken;

  MedicationModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.timing,
    required this.instructions,
    required this.durationDays,
    required this.startDate,
    this.isTaken = false,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Medicine',
      dosage: json['dosage'] ?? '500mg',
      frequency: json['frequency'] ?? 'Daily',
      timing: json['timing'] ?? 'After meals',
      instructions: json['instructions'] ?? 'Take with water',
      durationDays: json['duration_days'] ?? 30,
      startDate: json['start_date'] ?? '2026-09-01',
      isTaken: json['is_taken'] == true,
    );
  }
}
