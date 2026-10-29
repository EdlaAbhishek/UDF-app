import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/dialog_utils.dart';
import '../../providers/auth_provider.dart';
import '../../providers/queue_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/status_badge.dart';

class PatientQueueScreen extends StatefulWidget {
  const PatientQueueScreen({super.key});

  @override
  State<PatientQueueScreen> createState() => _PatientQueueScreenState();
}

class _PatientQueueScreenState extends State<PatientQueueScreen> {
  String _selectedHospital = 'Apollo Hospitals Jubilee Hills';
  String _selectedDept = 'Pulmonology';
  String _selectedDoctor = 'Dr. Priya Sharma';

  final List<String> _hospitals = [
    'Apollo Hospitals Jubilee Hills',
    'KIMS Hospital Secunderabad',
    'Yashoda Hospitals Somajiguda',
    'Care Hospitals Banjara Hills',
  ];

  final List<String> _departments = [
    'Pulmonology',
    'Cardiology',
    'General Medicine',
    'Orthopedics',
    'Pediatrics',
  ];

  final List<String> _doctors = [
    'Dr. Priya Sharma',
    'Dr. Suresh Reddy',
    'Dr. Rajesh Kumar',
    'Dr. Anil Kumar',
    'Dr. Kavitha Nair',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        context.read<QueueProvider>().fetchActiveToken(user.id);
      }
    });
  }

  Future<void> _handleGenerateToken() async {
    final auth = context.read<AuthProvider>();
    if (auth.user == null) return;

    await context.read<QueueProvider>().generateToken(
          patientId: auth.user!.id,
          hospitalName: _selectedHospital,
          department: _selectedDept,
          doctorName: _selectedDoctor,
        );

    if (!mounted) return;
    DialogUtils.showSnackBar(context, 'New OPD Token Issued!');
  }

  @override
  Widget build(BuildContext context) {
    final queueProv = context.watch<QueueProvider>();
    final token = queueProv.activeToken;

    return Scaffold(
      appBar: CustomAppBar(title: 'Live OPD Queue'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Active Token Card
            if (token != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E3A8A), Color(0xFF1565C0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x331E3A8A),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'YOUR ACTIVE OPD TOKEN',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        StatusBadge(status: token.status),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      token.tokenNumber,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${token.department} • ${token.doctorName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      token.hospitalName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${token.peopleAhead}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Text(
                                'Ahead of you',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                          Container(width: 1, height: 28, color: Colors.white24),
                          Column(
                            children: [
                              Text(
                                '~${token.estimatedWaitMinutes} mins',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Text(
                                'Est. Wait Time',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Smart Cafeteria Suggestion
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Text('☕', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Smart Cafeteria Alert',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                            ),
                          ),
                          Text(
                            'Estimated wait is ${token.estimatedWaitMinutes} minutes. You have comfortable time to visit the 1st floor cafeteria.',
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textMain),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.emergency,
                  side: const BorderSide(color: AppColors.border),
                ),
                onPressed: () {
                  queueProv.cancelToken();
                  DialogUtils.showSnackBar(context, 'Token cancelled.');
                },
                child: const Text('Leave Queue / Cancel Token'),
              ),
              const SizedBox(height: 28),
            ],

            // Token Generator Section
            const Text(
              'Get a Digital OPD Token',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Avoid standing in hospital lobby lines. Issue a real-time OPD token before arriving.',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Hospital',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedHospital,
                    items: _hospitals
                        .map((h) => DropdownMenuItem(value: h, child: Text(h)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedHospital = val);
                    },
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text('Select Department',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedDept,
                    items: _departments
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedDept = val);
                    },
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text('Consulting Doctor',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedDoctor,
                    items: _doctors
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedDoctor = val);
                    },
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 20),

                  AppButton(
                    label: 'Generate OPD Token Now',
                    icon: Icons.confirmation_number_outlined,
                    onPressed: _handleGenerateToken,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
