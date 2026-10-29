import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../services/appointment_service.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentService _service = AppointmentService();

  List<AppointmentModel> _appointments = [];
  bool _isLoading = false;

  List<AppointmentModel> get appointments => _appointments;
  bool get isLoading => _isLoading;

  List<AppointmentModel> get upcomingAppointments =>
      _appointments.where((a) => a.status == 'confirmed' || a.status == 'pending').toList();

  List<AppointmentModel> get pastAppointments =>
      _appointments.where((a) => a.status == 'completed' || a.status == 'cancelled').toList();

  Future<void> fetchAppointments(String userId, {bool isDoctor = false}) async {
    _isLoading = true;
    notifyListeners();
    if (isDoctor) {
      _appointments = await _service.getDoctorAppointments(userId);
    } else {
      _appointments = await _service.getPatientAppointments(userId);
    }
    _isLoading = false;
    notifyListeners();
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
    final appt = await _service.bookAppointment(
      patientId: patientId,
      doctorId: doctorId,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      appointmentType: appointmentType,
      reason: reason,
      urgency: urgency,
      patientName: patientName,
      doctorName: doctorName,
      hospitalName: hospitalName,
      specialty: specialty,
    );
    _appointments.insert(0, appt);
    notifyListeners();
    return appt;
  }

  Future<void> cancelAppointment(String id) async {
    await _service.cancelAppointment(id);
    final idx = _appointments.indexWhere((a) => a.id == id);
    if (idx != -1) {
      final old = _appointments[idx];
      _appointments[idx] = AppointmentModel(
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
      notifyListeners();
    }
  }
}
