import 'package:flutter/material.dart';
import '../models/health_document_model.dart';
import '../services/health_vault_service.dart';

class HealthVaultProvider extends ChangeNotifier {
  final HealthVaultService _service = HealthVaultService();

  List<HealthDocumentModel> _documents = [];
  bool _isLoading = false;
  String _selectedCategory = 'all';

  List<HealthDocumentModel> get documents => _documents;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> fetchDocuments(String patientId) async {
    _isLoading = true;
    notifyListeners();
    _documents = await _service.getDocuments(patientId, category: _selectedCategory);
    _isLoading = false;
    notifyListeners();
  }

  Future<HealthDocumentModel> uploadDocument({
    required String title,
    required String category,
    required String hospitalLab,
    String? doctorName,
    String? summary,
    String? fileName,
  }) async {
    final doc = await _service.uploadDocument(
      title: title,
      category: category,
      hospitalLab: hospitalLab,
      doctorName: doctorName,
      summary: summary,
      fileName: fileName,
    );
    _documents.insert(0, doc);
    notifyListeners();
    return doc;
  }
}
