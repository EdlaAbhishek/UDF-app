import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/dialog_utils.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/status_badge.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Platform Administration',
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // KPI Stat Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.45,
              children: const [
                _AdminKpiCard(
                  label: 'Registered Patients',
                  value: '14,820',
                  icon: Icons.people_outline,
                  color: AppColors.primary,
                ),
                _AdminKpiCard(
                  label: 'Verified Doctors',
                  value: '428',
                  icon: Icons.medical_services_outlined,
                  color: AppColors.success,
                ),
                _AdminKpiCard(
                  label: 'Hospital Partners',
                  value: '64',
                  icon: Icons.apartment_outlined,
                  color: Color(0xFF8B5CF6),
                ),
                _AdminKpiCard(
                  label: "Today's Consultations",
                  value: '182',
                  icon: Icons.calendar_today_outlined,
                  color: Color(0xFFF59E0B),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Pending Doctor Verification Requests
            const Text(
              'Doctor Credential Applications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            _DoctorApplicationCard(
              name: 'Dr. Meena Rao, MD',
              specialty: 'Obstetrics & Gynecology',
              registrationNumber: 'MCI-2018-88912',
              hospital: 'Rainbow Children Hospital',
            ),
            const SizedBox(height: 10),
            _DoctorApplicationCard(
              name: 'Dr. Vikram Singh, MS',
              specialty: 'General & Laparoscopic Surgery',
              registrationNumber: 'TSMC-2016-44019',
              hospital: 'Care Hospitals Banjara Hills',
            ),
            const SizedBox(height: 24),

            // Network Health & Audit status
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.security_outlined,
                          size: 20, color: AppColors.success),
                      SizedBox(width: 8),
                      Text(
                        'System Security & Health',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _SystemCheckRow(
                    label: 'Database RLS & Audit Policies',
                    status: 'Active',
                    isOk: true,
                  ),
                  const _SystemCheckRow(
                    label: 'Emergency 112/108 Dispatch API',
                    status: 'Operational',
                    isOk: true,
                  ),
                  const _SystemCheckRow(
                    label: 'AI Triage & OpenRouter Endpoint',
                    status: 'Connected',
                    isOk: true,
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

class _AdminKpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _AdminKpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorApplicationCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String registrationNumber;
  final String hospital;

  const _DoctorApplicationCard({
    required this.name,
    required this.specialty,
    required this.registrationNumber,
    required this.hospital,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const StatusBadge(status: 'pending'),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$specialty • $hospital',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          Text(
            'Medical Reg: $registrationNumber',
            style: const TextStyle(fontSize: 11, color: AppColors.textLight),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: AppColors.emergency,
                  side: const BorderSide(color: AppColors.emergency),
                ),
                onPressed: () =>
                    DialogUtils.showSnackBar(context, 'Application rejected.'),
                child: const Text('Reject', style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: AppColors.success,
                ),
                onPressed: () => DialogUtils.showSnackBar(
                    context, '$name verified & added to practice network!'),
                child: const Text('Approve', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SystemCheckRow extends StatelessWidget {
  final String label;
  final String status;
  final bool isOk;

  const _SystemCheckRow({
    required this.label,
    required this.status,
    required this.isOk,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMain)),
          Row(
            children: [
              Icon(
                isOk ? Icons.check_circle_rounded : Icons.error_outline,
                size: 14,
                color: isOk ? AppColors.success : AppColors.emergency,
              ),
              const SizedBox(width: 4),
              Text(
                status,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isOk ? AppColors.success : AppColors.emergency,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
