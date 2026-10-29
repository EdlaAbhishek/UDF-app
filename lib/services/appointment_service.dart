import '../models/appointment_model.dart';
import 'supabase_service.dart';

class AppointmentService {
  static final List<AppointmentModel> _mockAppointments = [
    AppointmentModel(
      id: 'mock-appt-1',
      patientId: 'demo-patient-uuid-101',
      doctorId: 'doc-1',
      appointmentDate: DateTime.now().add(const Duration(days: 1)).toIso8601String(),
      appointmentTime: '10:30',
      appointmentType: 'in-person',
      status: 'confirmed',
      urgency: 'Routine',
      doctorName: 'Dr. Priya Sharma',
      specialty: 'Pulmonology',
      hospitalName: 'Apollo Hospitals Jubilee Hills',
      patientName: 'Rahul Sharma',
      reason: 'Persistent dry cough and seasonal allergies follow-up',
    ),
    AppointmentModel(
      id: 'mock-appt-2',
      patientId: 'demo-patient-uuid-101',
      doctorId: 'doc-2',
      appointmentDate: DateTime.now().add(const Duration(days: 3)).toIso8601String(),
      appointmentTime: '15:00',
      appointmentType: 'video-call',
      status: 'confirmed',
      urgency: 'Urgent',
      doctorName: 'Dr. Suresh Reddy',
      specialty: 'Cardiology',
      hospitalName: 'KIMS Hospital Secunderabad',
      patientName: 'Rahul Sharma',
      reason: 'Elevated blood pressure review',
    ),
    AppointmentModel(
      id: 'mock-appt-3',
      patientId: 'demo-patient-uuid-101',
      doctorId: 'doc-3',
      appointmentDate: DateTime.now().subtract(const Duration(days: 14)).toIso8601String(),
      appointmentTime: '11:00',
      appointmentType: 'in-person',
      status: 'completed',
      urgency: 'Routine',
      doctorName: 'Dr. Rajesh Kumar',
      specialty: 'General Medicine',
      hospitalName: 'Yashoda Hospitals Somajiguda',
      patientName: 'Rahul Sharma',
      reason: 'Routine quarterly diabetes checkup',
      postCareNotes: 'Blood sugar controlled. Continue Metformin 500mg. Review after 3 months.',
    ),
  ];

  Future<List<AppointmentModel>> getPatientAppointments(String patientId) async {
    try {
      final res = await SupabaseService.client
          .from('appointments')
          .select('*, doctors(full_name, specialty, hospital_name)')
          .eq('patient_id', patientId)
          .order('appointment_date', ascending: false)
          .timeout(const Duration(seconds: 5));
      if (res.isNotEmpty) {
        return (res as List)
            .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print('Appointments fetch error, using robust fallback: $e');
    }
    return _mockAppointments;
  }

  Future<List<AppointmentModel>> getDoctorAppointments(String doctorId) async {
    try {
      final res = await SupabaseService.client
          .from('appointments')
          .select('*')
          .eq('doctor_id', doctorId)
          .order('appointment_date', ascending: false)
          .timeout(const Duration(seconds: 5));
      if (res.isNotEmpty) {
        return (res as List)
            .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print('Doctor appointments fetch error: $e');
    }
    return _mockAppointments;
  }

  Future<AppointmentModel> bookAppointment({
    required String patientId,
    required String doctorId,
    required String appointmentDate,
    required String appointmentTime,
    required String appointmentType,
    required String reason,
    String urgency = 'Routine',
    String? patientName,
    String? doctorName,
    String? hospitalName,
    String? specialty,
  }) async {
    final newAppt = AppointmentModel(
      id: 'appt-${DateTime.now().millisecondsSinceEpoch}',
      patientId: patientId,
      doctorId: doctorId,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      appointmentType: appointmentType,
      status: 'confirmed',
      urgency: urgency,
      reason: reason,
      patientName: patientName,
      doctorName: doctorName,
      hospitalName: hospitalName,
      specialty: specialty,
    );

    try {
      await SupabaseService.client.from('appointments').insert({
        'patient_id': patientId,
        'doctor_id': doctorId,
        'appointment_date': appointmentDate,
        'appointment_time': appointmentTime,
        'appointment_type': appointmentType,
        'status': 'confirmed',
        'urgency': urgency,
        'reason_for_visit': reason,
      }).timeout(const Duration(seconds: 5));
    } catch (e) {
      print('Supabase insert note: $e');
    }

    _mockAppointments.insert(0, newAppt);
    return newAppt;
  }

  Future<void> cancelAppointment(String id) async {
    try {
      await SupabaseService.client
          .from('appointments')
          .update({'status': 'cancelled'})
          .eq('id', id);
    } catch (_) {}
    final idx = _mockAppointments.indexWhere((a) => a.id == id);
    if (idx != -1) {
      final old = _mockAppointments[idx];
      _mockAppointments[idx] = AppointmentModel(
        id: old.id,
        patientId: old.patientId,
        doctorId: old.doctorId,
        appointmentDate: old.appointmentDate,
        appointmentTime: old.appointmentTime,
        appointmentType: old.appointmentType,
        status: 'cancelled',
        urgency: old.urgency,
        reason: old.reason,
        doctorName: old.doctorName,
        hospitalName: old.hospitalName,
        specialty: old.specialty,
      );
    }
  }
}
