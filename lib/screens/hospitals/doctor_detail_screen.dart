import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/doctor_model.dart';
import '../../navigation/route_names.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/status_badge.dart';

class DoctorDetailScreen extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: doctor.fullName),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Doctor Profile Summary Card
            AppCard(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      doctor.fullName.isNotEmpty ? doctor.fullName[0] : 'D',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    doctor.fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialty,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    doctor.hospitalName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StatusBadge(status: doctor.availabilityStatus),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFF59E0B), size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${doctor.rating} Rating',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatColumn(
                        label: 'Experience',
                        value: '${doctor.experienceYears}+ Years',
                      ),
                      _StatColumn(
                        label: 'Consultation',
                        value: doctor.consultationFee ?? '₹600',
                      ),
                      const _StatColumn(
                        label: 'Mode',
                        value: 'In-Person & Video',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // About Clinical Practice
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Clinical Background & Expertise',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${doctor.fullName} is a distinguished specialist at ${doctor.hospitalName} with over ${doctor.experienceYears} years of medical experience providing diagnostic evaluation, emergency care, and long-term treatment planning.',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMain,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Verified Credentials',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      Icon(Icons.verified_outlined,
                          size: 16, color: AppColors.success),
                      SizedBox(width: 6),
                      Text('Medical Council of India Verified',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textMain)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.local_hospital_outlined,
                          size: 16, color: AppColors.primary),
                      SizedBox(width: 6),
                      Text('Department Senior Consultant',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textMain)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Book Consultation Button
            AppButton(
              label: 'Book Consultation with ${doctor.fullName}',
              icon: Icons.calendar_month_rounded,
              onPressed: () => Navigator.pushNamed(
                context,
                RouteNames.booking,
                arguments: doctor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
