import '../models/queue_token_model.dart';
import 'supabase_service.dart';

class QueueService {
  static QueueTokenModel? _activeToken = QueueTokenModel(
    id: 'token-1',
    tokenNumber: 'A-119',
    hospitalName: 'Apollo Hospitals Jubilee Hills',
    department: 'Pulmonology',
    doctorName: 'Dr. Priya Sharma',
    status: 'waiting',
    peopleAhead: 2,
    estimatedWaitMinutes: 18,
    createdAt: DateTime.now().toIso8601String(),
  );

  Future<QueueTokenModel?> getActiveToken(String patientId) async {
    try {
      final res = await SupabaseService.client
          .from('queue_tokens')
          .select('*')
          .eq('patient_id', patientId)
          .inFilter('status', ['waiting', 'checked_in'])
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle()
          .timeout(const Duration(seconds: 4));
      if (res != null) {
        return QueueTokenModel.fromJson(res);
      }
    } catch (_) {}
    return _activeToken;
  }

  Future<QueueTokenModel> generateToken({
    required String patientId,
    required String hospitalName,
    required String department,
    required String doctorName,
  }) async {
    final tokenNum = 'A-${(100 + DateTime.now().millisecond % 899)}';
    final newToken = QueueTokenModel(
      id: 'token-${DateTime.now().millisecondsSinceEpoch}',
      tokenNumber: tokenNum,
      hospitalName: hospitalName,
      department: department,
      doctorName: doctorName,
      status: 'waiting',
      peopleAhead: 3,
      estimatedWaitMinutes: 25,
      createdAt: DateTime.now().toIso8601String(),
    );

    try {
      await SupabaseService.client.from('queue_tokens').insert({
        'patient_id': patientId,
        'token_number': tokenNum,
        'hospital_name': hospitalName,
        'department': department,
        'doctor_name': doctorName,
        'status': 'waiting',
      }).timeout(const Duration(seconds: 4));
    } catch (_) {}

    _activeToken = newToken;
    return newToken;
  }

  void cancelActiveToken() {
    _activeToken = null;
  }
}
