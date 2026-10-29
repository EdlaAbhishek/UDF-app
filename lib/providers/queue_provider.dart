import 'package:flutter/material.dart';
import '../models/queue_token_model.dart';
import '../services/queue_service.dart';

class QueueProvider extends ChangeNotifier {
  final QueueService _service = QueueService();

  QueueTokenModel? _activeToken;
  bool _isLoading = false;

  QueueTokenModel? get activeToken => _activeToken;
  bool get hasActiveToken => _activeToken != null;
  bool get isLoading => _isLoading;

  Future<void> fetchActiveToken(String patientId) async {
    _isLoading = true;
    notifyListeners();
    _activeToken = await _service.getActiveToken(patientId);
    _isLoading = false;
    notifyListeners();
  }

  Future<QueueTokenModel> generateToken({
    required String patientId,
    required String hospitalName,
    required String department,
    required String doctorName,
  }) async {
    _isLoading = true;
    notifyListeners();
    final token = await _service.generateToken(
      patientId: patientId,
      hospitalName: hospitalName,
      department: department,
      doctorName: doctorName,
    );
    _activeToken = token;
    _isLoading = false;
    notifyListeners();
    return token;
  }

  void cancelToken() {
    _service.cancelActiveToken();
    _activeToken = null;
    notifyListeners();
  }
}
