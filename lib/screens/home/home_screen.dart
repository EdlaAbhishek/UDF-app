import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../navigation/route_names.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final userName = auth.user?.fullName.split(' ').first ?? 'Friend';

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Khushi Hygieia',
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Hero Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x331565C0),
                    blurRadius: 12,
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
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '✨ AI Healthcare Platform',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(Icons.shield_outlined,
                          color: Colors.white70, size: 20),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Namaste, $userName 👋',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Evaluate symptoms with AI, book verified specialists, and manage your family’s health records in one place.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.health_and_safety_outlined, size: 18),
                    label: const Text('Check Symptoms Now',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    onPressed: () =>
                        Navigator.pushNamed(context, RouteNames.symptomChecker),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Core AI Capabilities
            const Text(
              'Core AI Capabilities',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _AiFeatureCard(
                    title: 'Symptom Triage',
                    subtitle: 'Clinical AI evaluation',
                    icon: Icons.monitor_heart_outlined,
                    color: const Color(0xFFEF4444),
                    bgColor: const Color(0xFFFEF2F2),
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.symptomChecker),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AiFeatureCard(
                    title: 'Health Vault',
                    subtitle: 'Rx scanner & records',
                    icon: Icons.folder_shared_outlined,
                    color: AppColors.primary,
                    bgColor: AppColors.primaryLight,
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.healthVault),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _AiFeatureCard(
              title: 'Khushi Care AI Assistant',
              subtitle: 'Chat in English, Hindi & Telugu with voice support',
              icon: Icons.chat_bubble_outline_rounded,
              color: AppColors.accent,
              bgColor: AppColors.accentLight,
              isWide: true,
              onTap: () => Navigator.pushNamed(context, RouteNames.aiChat),
            ),
            const SizedBox(height: 24),

            // Quick Access Grid
            const Text(
              'Healthcare Services',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _ServiceTile(
                  icon: Icons.local_hospital_outlined,
                  label: 'Hospitals',
                  color: AppColors.primary,
                  onTap: () => Navigator.pushNamed(context, RouteNames.hospitals),
                ),
                _ServiceTile(
                  icon: Icons.confirmation_number_outlined,
                  label: 'OPD Queue',
                  color: const Color(0xFF8B5CF6),
                  onTap: () => Navigator.pushNamed(context, RouteNames.queue),
                ),
                _ServiceTile(
                  icon: Icons.medication_outlined,
                  label: 'Medications',
                  color: const Color(0xFF10B981),
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.medications),
                ),
                _ServiceTile(
                  icon: Icons.security_outlined,
                  label: 'Insurance',
                  color: const Color(0xFF0284C7),
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.insurance),
                ),
                _ServiceTile(
                  icon: Icons.people_outline,
                  label: 'Care Circle',
                  color: const Color(0xFFF59E0B),
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.careCircle),
                ),
                _ServiceTile(
                  icon: Icons.bloodtype_outlined,
                  label: 'Blood Donor',
                  color: const Color(0xFFDC2626),
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.bloodDonation),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Episodic Care Journey Banner
            AppCard(
              backgroundColor: const Color(0xFFF8FAFC),
              onTap: () =>
                  Navigator.pushNamed(context, RouteNames.healthJourney),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.timeline_rounded,
                        color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connected Health Journey',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Track active episodes from triage to recovery',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 14, color: AppColors.textMuted),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // How it works
            const Text(
              'How Khushi Hygieia Works',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            _TimelineStep(
              stepNumber: '1',
              title: 'Analyze Symptoms',
              description:
                  'Use our AI Symptom Checker for instantaneous triage classification and preliminary guidance.',
            ),
            _TimelineStep(
              stepNumber: '2',
              title: 'Book & Queue Seamlessly',
              description:
                  'Select verified specialists across top hospitals and monitor your OPD token live.',
            ),
            _TimelineStep(
              stepNumber: '3',
              title: 'Prescription & Records in Vault',
              description:
                  'Upload medical documents with automatic regional language translation and strict privacy.',
              isLast: true,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _AiFeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;
  final bool isWide;

  const _AiFeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
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
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String stepNumber;
  final String title;
  final String description;
  final bool isLast;

  const _TimelineStep({
    required this.stepNumber,
    required this.title,
    required this.description,
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
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  stepNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 48,
                color: AppColors.border,
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
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
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
