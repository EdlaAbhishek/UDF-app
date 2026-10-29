import 'package:flutter/material.dart';
import '../models/doctor_model.dart';
import '../models/hospital_model.dart';
import 'route_names.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/main_shell_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/dashboard/patient_dashboard_screen.dart';
import '../screens/dashboard/doctor_dashboard_screen.dart';
import '../screens/dashboard/admin_dashboard_screen.dart';
import '../screens/ai/ai_chat_screen.dart';
import '../screens/ai/symptom_checker_screen.dart';
import '../screens/hospitals/hospitals_screen.dart';
import '../screens/hospitals/hospital_detail_screen.dart';
import '../screens/hospitals/doctor_detail_screen.dart';
import '../screens/hospitals/booking_screen.dart';
import '../screens/queue/patient_queue_screen.dart';
import '../screens/queue/doctor_queue_screen.dart';
import '../screens/health_vault/health_vault_screen.dart';
import '../screens/medications/medication_center_screen.dart';
import '../screens/insurance/insurance_center_screen.dart';
import '../screens/emergency/emergency_screen.dart';
import '../screens/care_circle/care_circle_screen.dart';
import '../screens/health_journey/health_journey_screen.dart';
import '../screens/community/community_screen.dart';
import '../screens/community/blood_donation_screen.dart';
import '../screens/teleconsult/video_call_screen.dart';
import '../screens/health_worker/health_worker_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/apply_doctor_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.initial:
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RouteNames.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case RouteNames.mainShell:
        final initialIndex = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
            builder: (_) => MainShellScreen(initialIndex: initialIndex));

      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case RouteNames.dashboard:
        return MaterialPageRoute(
            builder: (_) => const PatientDashboardScreen());

      case RouteNames.doctorDashboard:
        return MaterialPageRoute(
            builder: (_) => const DoctorDashboardScreen());

      case RouteNames.adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());

      case RouteNames.aiChat:
        return MaterialPageRoute(builder: (_) => const AiChatScreen());

      case RouteNames.symptomChecker:
        return MaterialPageRoute(builder: (_) => const SymptomCheckerScreen());

      case RouteNames.hospitals:
        return MaterialPageRoute(builder: (_) => const HospitalsScreen());

      case RouteNames.hospitalDetail:
        final hospital = settings.arguments as HospitalModel;
        return MaterialPageRoute(
            builder: (_) => HospitalDetailScreen(hospital: hospital));

      case RouteNames.doctorDetail:
        final doctor = settings.arguments as DoctorModel;
        return MaterialPageRoute(
            builder: (_) => DoctorDetailScreen(doctor: doctor));

      case RouteNames.booking:
        final doctor = settings.arguments as DoctorModel;
        return MaterialPageRoute(
            builder: (_) => BookingScreen(doctor: doctor));

      case RouteNames.queue:
        return MaterialPageRoute(builder: (_) => const PatientQueueScreen());

      case RouteNames.doctorQueue:
        return MaterialPageRoute(builder: (_) => const DoctorQueueScreen());

      case RouteNames.healthVault:
        return MaterialPageRoute(builder: (_) => const HealthVaultScreen());

      case RouteNames.medications:
        return MaterialPageRoute(
            builder: (_) => const MedicationCenterScreen());

      case RouteNames.insurance:
        return MaterialPageRoute(
            builder: (_) => const InsuranceCenterScreen());

      case RouteNames.emergency:
        return MaterialPageRoute(builder: (_) => const EmergencyScreen());

      case RouteNames.careCircle:
        return MaterialPageRoute(builder: (_) => const CareCircleScreen());

      case RouteNames.healthJourney:
        return MaterialPageRoute(builder: (_) => const HealthJourneyScreen());

      case RouteNames.community:
        return MaterialPageRoute(builder: (_) => const CommunityScreen());

      case RouteNames.bloodDonation:
        return MaterialPageRoute(builder: (_) => const BloodDonationScreen());

      case RouteNames.teleconsult:
        return MaterialPageRoute(builder: (_) => const VideoCallScreen());

      case RouteNames.healthWorker:
        return MaterialPageRoute(builder: (_) => const HealthWorkerScreen());

      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case RouteNames.applyDoctor:
        return MaterialPageRoute(builder: (_) => const ApplyDoctorScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Not Found')),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
