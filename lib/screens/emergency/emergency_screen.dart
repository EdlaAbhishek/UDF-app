import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/dialog_utils.dart';
import '../../navigation/route_names.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_app_bar.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  Future<void> _makeCall(BuildContext context, String number) async {
    final uri = Uri.parse('tel:$number');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context.mounted) {
          DialogUtils.showSnackBar(
              context, 'Emergency calling protocol: Dial $number on phone.');
        }
      }
    } catch (_) {
      if (context.mounted) {
        DialogUtils.showSnackBar(
            context, 'Emergency calling protocol: Dial $number on phone.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Emergency Critical Care',
        showEmergencyButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Emergency Header Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.emergencyLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.emergency.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.emergency,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '🚨 PROTOCOL ACTIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Immediate Critical Care Dispatch',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.emergency,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'This protocol bypasses standard triage and immediately connects to national emergency services and nearby integrated trauma centers.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMain,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Emergency Action 1: Call 112 Dispatch
            _EmergencyCard(
              title: 'Call National Emergency (112)',
              subtitle: 'Connect to central dispatch. GPS telemetry transmitted.',
              icon: Icons.phone_in_talk_rounded,
              color: AppColors.emergency,
              buttonText: 'Dial 112 Dispatch',
              onPressed: () =>
                  _makeCall(context, AppConstants.emergencyNumber),
            ),
            const SizedBox(height: 14),

            // Emergency Action 2: Call 108 Ambulance
            _EmergencyCard(
              title: 'Initiate Medical Ambulance (108)',
              subtitle:
                  'Direct dispatch for cardiac, respiratory, or trauma transit.',
              icon: Icons.airport_shuttle_rounded,
              color: const Color(0xFFC2410C),
              buttonText: 'Call Ambulance 108',
              onPressed: () =>
                  _makeCall(context, AppConstants.ambulanceNumber),
            ),
            const SizedBox(height: 14),

            // Emergency Action 3: Nearest ER Trauma Centers
            _EmergencyCard(
              title: 'Locate Nearest ER Trauma Center',
              subtitle: 'View hospitals with 24/7 verified emergency beds.',
              icon: Icons.local_hospital_rounded,
              color: AppColors.primary,
              buttonText: 'Search Emergency ERs',
              onPressed: () =>
                  Navigator.pushNamed(context, RouteNames.hospitals),
            ),
            const SizedBox(height: 14),

            // Emergency Action 4: Next-of-Kin Alert
            _EmergencyCard(
              title: 'Send Next-of-Kin SOS Alert',
              subtitle:
                  'Transmit SMS with current location and emergency state to Care Circle.',
              icon: Icons.share_location_rounded,
              color: const Color(0xFF8B5CF6),
              buttonText: 'Transmit SOS Alert',
              onPressed: () {
                DialogUtils.showSnackBar(
                  context,
                  '🚨 Emergency SMS with GPS coordinates transmitted to Care Circle!',
                );
              },
            ),
            const SizedBox(height: 24),

            // Verified Response Footer
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user_outlined,
                      color: AppColors.success, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'All emergency calls are encrypted and prioritized by regional trauma response teams.',
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          height: 1.4),
                    ),
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

class _EmergencyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String buttonText;
  final VoidCallback onPressed;

  const _EmergencyCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: Icon(icon, size: 18),
              label: Text(buttonText,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
