import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'navigation/app_router.dart';
import 'navigation/route_names.dart';
import 'providers/appointment_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/health_vault_provider.dart';
import 'providers/hospital_provider.dart';
import 'providers/medication_provider.dart';
import 'providers/queue_provider.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase backend services
  await SupabaseService.initialize();

  runApp(const KhushiHygieiaApp());
}

class KhushiHygieiaApp extends StatelessWidget {
  const KhushiHygieiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HospitalProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => QueueProvider()),
        ChangeNotifierProvider(create: (_) => HealthVaultProvider()),
        ChangeNotifierProvider(create: (_) => MedicationProvider()),
      ],
      child: MaterialApp(
        title: 'Khushi Hygieia',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: RouteNames.login,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
