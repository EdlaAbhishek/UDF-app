import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_app_bar.dart';

class HealthJourneyScreen extends StatelessWidget {
  const HealthJourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Connected Health Journey'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Active Episode Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x331565C0),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ACTIVE EPISODE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Text(
                        '85% Complete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Acute Bronchitis & Respiratory Infection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Dr. Priya Sharma • Apollo Hospitals Jubilee Hills',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: const LinearProgressIndicator(
                      value: 0.85,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Journey Milestones',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 14),

            _JourneyStep(
              stepNumber: '1',
              title: 'AI Symptom Triage Logged',
              date: '15 Sep 2026, 09:30 AM',
              summary:
                  'Persistent dry cough and fever logged via AI Symptom Checker. Categorized as Moderate / Urgent.',
              isCompleted: true,
            ),
            _JourneyStep(
              stepNumber: '2',
              title: 'OPD Digital Token Generated',
              date: '15 Sep 2026, 10:15 AM',
              summary:
                  'Token A-119 issued for Department of Pulmonology. Real-time wait tracked in hospital cafeteria.',
              isCompleted: true,
            ),
            _JourneyStep(
              stepNumber: '3',
              title: 'Specialist Consultation',
              date: '15 Sep 2026, 10:45 AM',
              summary:
                  'Consulted Dr. Priya Sharma. Clinical assessment confirmed acute bronchitis. Digital Rx issued.',
              isCompleted: true,
            ),
            _JourneyStep(
              stepNumber: '4',
              title: 'Diagnostic Lab Work',
              date: '16 Sep 2026, 08:30 AM',
              summary:
                  'CBC with ESR completed at Apollo Diagnostics. Verified report saved in Health Vault.',
              isCompleted: true,
            ),
            _JourneyStep(
              stepNumber: '5',
              title: 'Medication Adherence',
              date: '16 Sep - 21 Sep 2026',
              summary:
                  '5-day antibiotic and bronchodilator schedule tracked with 90% adherence rate.',
              isCompleted: true,
            ),
            _JourneyStep(
              stepNumber: '6',
              title: 'Insurance Claim & Follow-up',
              date: 'Expected 25 Sep 2026',
              summary:
                  'Direct cashless reimbursement submission under review with Star Health.',
              isCompleted: false,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _JourneyStep extends StatelessWidget {
  final String stepNumber;
  final String title;
  final String date;
  final String summary;
  final bool isCompleted;
  final bool isLast;

  const _JourneyStep({
    required this.stepNumber,
    required this.title,
    required this.date,
    required this.summary,
    required this.isCompleted,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.success : AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? AppColors.success : AppColors.border,
                ),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : Text(
                        stepNumber,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                        ),
                      ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: isCompleted ? AppColors.successLight : AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              const SizedBox(height: 4),
              Text(
                summary,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMain,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
