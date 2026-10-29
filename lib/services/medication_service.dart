import '../models/medication_model.dart';
import 'supabase_service.dart';

class MedicationService {
  static final List<MedicationModel> _demoMedications = [
    MedicationModel(
      id: 'med-1',
      name: 'Metformin 500mg',
      dosage: '500mg',
      frequency: 'Twice daily',
      timing: 'After meals (Morning & Night)',
      instructions: 'Take 1 tablet with water immediately after breakfast and dinner',
      durationDays: 90,
      startDate: '2026-09-01',
      isTaken: true,
    ),
    MedicationModel(
      id: 'med-2',
      name: 'Glimepiride 1mg',
      dosage: '1mg',
      frequency: 'Once daily',
      timing: 'Before breakfast',
      instructions: 'Take 30 minutes before morning breakfast',
      durationDays: 90,
      startDate: '2026-09-01',
      isTaken: true,
    ),
    MedicationModel(
      id: 'med-3',
      name: 'Atorvastatin 10mg',
      dosage: '10mg',
      frequency: 'Once daily',
      timing: 'Bedtime (Night)',
      instructions: 'Take at night before sleep for cholesterol regulation',
      durationDays: 90,
      startDate: '2026-09-01',
      isTaken: false,
    ),
    MedicationModel(
      id: 'med-4',
      name: 'Levocetirizine 5mg',
      dosage: '5mg',
      frequency: 'Once daily (SOS / As needed)',
      timing: 'Night',
      instructions: 'For seasonal allergic cough & nasal congestion',
      durationDays: 5,
      startDate: '2026-09-15',
      isTaken: false,
    ),
  ];

  Future<List<MedicationModel>> getMedications(String patientId) async {
    try {
      final res = await SupabaseService.client
          .from('medications')
          .select('*')
          .eq('patient_id', patientId)
          .timeout(const Duration(seconds: 4));
      if (res.isNotEmpty) {
        return (res as List)
            .map((e) => MedicationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return _demoMedications;
  }

  void toggleDose(String id) {
    final idx = _demoMedications.indexWhere((m) => m.id == id);
    if (idx != -1) {
      _demoMedications[idx].isTaken = !_demoMedications[idx].isTaken;
    }
  }
}
