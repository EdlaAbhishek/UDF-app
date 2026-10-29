import 'package:flutter/material.dart';
import '../models/medication_model.dart';
import '../services/medication_service.dart';

class MedicationProvider extends ChangeNotifier {
  final MedicationService _service = MedicationService();

  List<MedicationModel> _medications = [];
  bool _isLoading = false;

  List<MedicationModel> get medications => _medications;
  bool get isLoading => _isLoading;

  int get takenCount => _medications.where((m) => m.isTaken).length;
  int get totalCount => _medications.length;
  double get adherenceRate => totalCount == 0 ? 0 : takenCount / totalCount;

  Future<void> fetchMedications(String patientId) async {
    _isLoading = true;
    notifyListeners();
    _medications = await _service.getMedications(patientId);
    _isLoading = false;
    notifyListeners();
  }

  void toggleDose(String id) {
    _service.toggleDose(id);
    final idx = _medications.indexWhere((m) => m.id == id);
    if (idx != -1) {
      _medications[idx].isTaken = !_medications[idx].isTaken;
      notifyListeners();
    }
  }
}
