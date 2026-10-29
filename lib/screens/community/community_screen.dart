import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/dialog_utils.dart';
import '../../navigation/route_names.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_app_bar.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Kushi Community'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero
            AppCard(
              padding: const EdgeInsets.all(16),
              backgroundColor: AppColors.primaryLight,
              child: Row(
                children: [
                  const Text('🤝', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Community Care Network',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Volunteer for patient navigation, hospital wheelchair support, and community blood drives.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Blood Hub quick link
            AppCard(
              onTap: () =>
                  Navigator.pushNamed(context, RouteNames.bloodDonation),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.emergencyLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.bloodtype_outlined,
                        color: AppColors.emergency, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Blood Donation Network',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Find live donors, register as donor, view hospital stock',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: AppColors.textMuted),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Volunteer drives
            const Text(
              'Active Volunteer Tasks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),

            _VolunteerCard(
              title: 'Wheelchair assistance for senior citizen',
              hospital: 'Apollo Hospitals Jubilee Hills',
              time: 'Today, 10:30 AM',
              type: 'Wheelchair Support',
              onJoin: () => DialogUtils.showSnackBar(
                  context, 'Enrolled as volunteer for this task!'),
            ),
            const SizedBox(height: 10),
            _VolunteerCard(
              title: 'Medicine pickup & delivery for post-op elder',
              hospital: 'KIMS Hospital Secunderabad',
              time: 'Tomorrow, 02:00 PM',
              type: 'Medicine Transit',
              onJoin: () => DialogUtils.showSnackBar(
                  context, 'Enrolled as volunteer for this task!'),
            ),
            const SizedBox(height: 10),
            _VolunteerCard(
              title: 'Community Health Awareness Drive (Diabetes)',
              hospital: 'Medchal PHC Center',
              time: 'Sunday, 09:00 AM',
              type: 'Rural Outreach',
              onJoin: () => DialogUtils.showSnackBar(
                  context, 'Enrolled as volunteer for this task!'),
            ),
          ],
        ),
      ),
    );
  }
}

class _VolunteerCard extends StatelessWidget {
  final String title;
  final String hospital;
  final String time;
  final String type;
  final VoidCallback onJoin;

  const _VolunteerCard({
    required this.title,
    required this.hospital,
    required this.time,
    required this.type,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  type,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                ),
              ),
              Text(
                time,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            hospital,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              onPressed: onJoin,
              child: const Text('Volunteer to Help',
                  style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
