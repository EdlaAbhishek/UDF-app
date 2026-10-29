import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/dialog_utils.dart';
import '../../navigation/route_names.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'User Profile',
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            // Profile Card
            AppCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      user != null && user.fullName.isNotEmpty
                          ? user.fullName[0]
                          : 'U',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.fullName ?? 'User Profile',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user?.email ?? 'No email',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user?.role.toUpperCase() ?? 'PATIENT',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Settings & Quick Links
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  if (!auth.isDoctor && !auth.isAdmin)
                    _ProfileTile(
                      icon: Icons.medical_services_outlined,
                      title: 'Apply for Doctor Verification',
                      subtitle: 'Join as a verified clinical provider',
                      onTap: () =>
                          Navigator.pushNamed(context, RouteNames.applyDoctor),
                    ),
                  _ProfileTile(
                    icon: Icons.timeline_rounded,
                    title: 'Health Journey',
                    subtitle: 'View active episodic care journeys',
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.healthJourney),
                  ),
                  _ProfileTile(
                    icon: Icons.family_restroom_rounded,
                    title: 'Care Circle',
                    subtitle: 'Manage family permissions & emergency contacts',
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.careCircle),
                  ),
                  _ProfileTile(
                    icon: Icons.lock_outline_rounded,
                    title: 'Security & Consent Settings',
                    subtitle: 'DPDP compliance & patient data sovereignty',
                    onTap: () => DialogUtils.showSnackBar(
                      context,
                      'All health records are encrypted per Digital Personal Data Protection standards.',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sign out button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.emergency,
                  side: const BorderSide(color: AppColors.emergency),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text('Sign Out',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onPressed: () async {
                  final confirm = await DialogUtils.showConfirmDialog(
                    context,
                    title: 'Sign Out',
                    content: 'Are you sure you want to sign out?',
                    confirmText: 'Sign Out',
                  );
                  if (confirm == true) {
                    await auth.signOut();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteNames.login,
                        (route) => false,
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: onTap,
    );
  }
}
