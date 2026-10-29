import 'package:flutter/material.dart';
import '../models/hospital_model.dart';
import '../models/doctor_model.dart';
import '../services/hospital_service.dart';

class HospitalProvider extends ChangeNotifier {
  final HospitalService _service = HospitalService();

  List<HospitalModel> _hospitals = [];
  List<DoctorModel> _doctors = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _typeFilter = 'all'; // 'all', 'teleconsult', 'emergency'

  List<HospitalModel> get hospitals {
    return _hospitals.filter((h) {
      final matchesSearch = h.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          h.city.toLowerCase().contains(_searchQuery.toLowerCase());
      if (!matchesSearch) return false;
      if (_typeFilter == 'teleconsult') return h.hasTeleconsult;
      if (_typeFilter == 'emergency') return h.hasEmergency;
      return true;
    }).toList();
  }

  List<DoctorModel> get doctors => _doctors;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get typeFilter => _typeFilter;

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void setTypeFilter(String filter) {
    _typeFilter = filter;
    notifyListeners();
  }

  Future<void> fetchHospitals() async {
    _isLoading = true;
    notifyListeners();
    _hospitals = await _service.getHospitals();
    _doctors = await _service.getDoctors();
    _isLoading = false;
    notifyListeners();
  }

  Future<List<DoctorModel>> getDoctorsForHospital(String hospitalName) async {
    return _service.getDoctors(hospitalName: hospitalName);
  }
}

extension ListFilterExtension<T> on List<T> {
  Iterable<T> filter(bool Function(T element) test) {
    return where(test);
  }
}
