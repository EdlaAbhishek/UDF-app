import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../core/constants/app_constants.dart';
import 'supabase_service.dart';

class AuthService {
  SupabaseClient get _client => SupabaseService.client;

  User? get currentSessionUser => _client.auth.currentUser;

  Future<UserModel> login(String email, String password) async {
    // Quick Demo Account interceptor for offline / instantaneous testing
    if (email == AppConstants.demoPatientEmail && password == AppConstants.demoPassword) {
      return UserModel(
        id: 'demo-patient-uuid-101',
        email: AppConstants.demoPatientEmail,
        fullName: 'Rahul Sharma (Patient Demo)',
        role: 'patient',
        phone: '+91 98480 22334',
      );
    }
    if (email == AppConstants.demoDoctorEmail && password == AppConstants.demoPassword) {
      return UserModel(
        id: 'demo-doctor-uuid-202',
        email: AppConstants.demoDoctorEmail,
        fullName: 'Dr. Priya Sharma (Doctor Demo)',
        role: 'doctor',
        phone: '+91 94401 55667',
      );
    }
    if (email == AppConstants.demoAdminEmail && password == AppConstants.demoPassword) {
      return UserModel(
        id: 'demo-admin-uuid-303',
        email: AppConstants.demoAdminEmail,
        fullName: 'Dr. K. Srinivas (Admin Demo)',
        role: 'admin',
        phone: '+91 91234 56789',
      );
    }

    try {
      final res = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = res.user;
      if (user == null) throw Exception('Login failed: user not returned');

      final role = await _resolveRole(user.id, user.userMetadata?['role']);
      final fullName = user.userMetadata?['full_name'] ??
          user.userMetadata?['name'] ??
          user.email ??
          'User';

      return UserModel(
        id: user.id,
        email: user.email ?? email,
        fullName: fullName,
        role: role,
        phone: user.userMetadata?['phone'],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> signup({
    required String email,
    required String password,
    required String fullName,
    String role = 'patient',
  }) async {
    try {
      final res = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'role': role},
      );

      final user = res.user;
      if (user == null) throw Exception('Signup failed');

      return UserModel(
        id: user.id,
        email: user.email ?? email,
        fullName: fullName,
        role: role,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (_) {}
  }

  Future<String> _resolveRole(String userId, dynamic metaRole) async {
    if (metaRole != null && metaRole.toString().isNotEmpty) {
      return metaRole.toString();
    }
    try {
      final adminCheck = await _client
          .from('admins')
          .select('role')
          .eq('id', userId)
          .maybeSingle();
      if (adminCheck != null && adminCheck['role'] != null) {
        return adminCheck['role'].toString();
      }

      final docCheck = await _client
          .from('doctors')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();
      if (docCheck != null) return 'doctor';

      final patCheck = await _client
          .from('patients')
          .select('role')
          .eq('id', userId)
          .maybeSingle();
      if (patCheck != null && patCheck['role'] != null) {
        return patCheck['role'].toString();
      }
    } catch (_) {}
    return 'patient';
  }
}
