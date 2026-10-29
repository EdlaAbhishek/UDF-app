import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/dialog_utils.dart';
import '../../models/appointment_model.dart';
import '../../navigation/route_names.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/status_badge.dart';

class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({super.key});

  @override
  State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        context.read<AppointmentProvider>().fetchAppointments(user.id);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final apptProv = context.watch<AppointmentProvider>();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Patient Dashboard',
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (auth.user != null) {
            await apptProv.fetchAppointments(auth.user!.id);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Health Score Overview Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 68,
                          height: 68,
                          child: CircularProgressIndicator(
                            value: 0.88,
                            strokeWidth: 6,
                            backgroundColor: AppColors.surface,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.success),
                          ),
                        ),
                        const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '88',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                              ),
                            ),
                            Text(
                              '/100',
                              style: TextStyle(
                                fontSize: 9,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Health Index',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.successLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Excellent',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Based on active prescriptions, vitals adherence, and triage history.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Quick Action Bar
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      title: 'Live Queue',
                      icon: Icons.confirmation_number_outlined,
                      color: const Color(0xFF8B5CF6),
                      onTap: () => Navigator.pushNamed(context, RouteNames.queue),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickActionCard(
                      title: 'Health Vault',
                      icon: Icons.folder_shared_outlined,
                      color: AppColors.primary,
                      onTap: () =>
                          Navigator.pushNamed(context, RouteNames.healthVault),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _QuickActionCard(
                      title: 'Medications',
                      icon: Icons.medication_outlined,
                      color: AppColors.success,
                      onTap: () =>
                          Navigator.pushNamed(context, RouteNames.medications),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Appointments Header & Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Appointments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Book New'),
                    onPressed: () =>
                        Navigator.pushNamed(context, RouteNames.hospitals),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textMuted,
                  labelStyle:
                      const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  tabs: const [
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Past Records'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (apptProv.isLoading)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: LoadingIndicator(message: 'Loading appointments...'),
                )
              else
                SizedBox(
                  height: 380,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAppointmentList(
                        apptProv.upcomingAppointments,
                        isUpcoming: true,
                        onCancel: (id) async {
                          final confirm = await DialogUtils.showConfirmDialog(
                            context,
                            title: 'Cancel Appointment',
                            content:
                                'Are you sure you want to cancel this consultation booking?',
                            isDestructive: true,
                            confirmText: 'Yes, Cancel',
                          );
                          if (confirm == true) {
                            await apptProv.cancelAppointment(id);
                            if (!context.mounted) return;
                            DialogUtils.showSnackBar(
                                context, 'Appointment cancelled');
                          }
                        },
                      ),
                      _buildAppointmentList(
                        apptProv.pastAppointments,
                        isUpcoming: false,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentList(
    List<AppointmentModel> items, {
    required bool isUpcoming,
    void Function(String id)? onCancel,
  }) {
    if (items.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.calendar_today_outlined,
        title: isUpcoming ? 'No Upcoming Consultations' : 'No Past Appointments',
        description: isUpcoming
            ? 'You do not have any active appointments scheduled. Book a visit or video call with top specialists.'
            : 'Your past consultation history and clinical summaries will appear here.',
        actionLabel: isUpcoming ? 'Find a Specialist' : null,
        onAction: isUpcoming
            ? () => Navigator.pushNamed(context, RouteNames.hospitals)
            : null,
      );
    }

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        final appt = items[i];
        return AppCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      appt.doctorName ?? 'Specialist Consultation',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  StatusBadge(status: appt.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${appt.specialty ?? 'General'} • ${appt.hospitalName ?? 'Hospital'}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      AppDateUtils.formatDate(appt.appointmentDate),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time_rounded,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      AppDateUtils.formatTime(appt.appointmentTime),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: appt.isTeleconsult
                            ? AppColors.infoLight
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        appt.isTeleconsult ? 'Video Call' : 'In-Person',
                        style: TextStyle(
                          color: appt.isTeleconsult
                              ? AppColors.info
                              : AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (appt.reason != null && appt.reason!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Reason: ${appt.reason!}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textMuted,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (appt.postCareNotes != null &&
                  appt.postCareNotes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Doctor Notes: ${appt.postCareNotes}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              if (isUpcoming && appt.status != 'cancelled') ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (appt.isTeleconsult)
                      TextButton.icon(
                        icon: const Icon(Icons.video_call_rounded,
                            size: 18, color: AppColors.primary),
                        label: const Text('Join Room',
                            style: TextStyle(color: AppColors.primary)),
                        onPressed: () => Navigator.pushNamed(
                            context, RouteNames.teleconsult),
                      ),
                    TextButton(
                      onPressed:
                          onCancel != null ? () => onCancel(appt.id) : null,
                      child: const Text('Cancel',
                          style: TextStyle(color: AppColors.emergency)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
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
