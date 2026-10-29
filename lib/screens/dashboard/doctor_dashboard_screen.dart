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
import '../../widgets/status_badge.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  String _doctorAvailability = 'available';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        context
            .read<AppointmentProvider>()
            .fetchAppointments(user.id, isDoctor: true);
      }
    });
  }

  void _showAddNotesDialog(AppointmentModel appt) {
    final controller = TextEditingController(text: appt.postCareNotes ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Post-Care Notes: ${appt.patientName ?? "Patient"}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Record diagnosis, medication instructions, and clinical advice.',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Enter clinical notes, dosage instructions...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              DialogUtils.showSnackBar(context, 'Clinical notes saved.');
            },
            child: const Text('Save Notes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final apptProv = context.watch<AppointmentProvider>();

    // Sort by urgency: Emergency (3), Urgent (2), Routine (1)
    final sortedAppointments = List<AppointmentModel>.from(apptProv.appointments)
      ..sort((a, b) {
        int weight(String u) => u == 'Emergency' ? 3 : u == 'Urgent' ? 2 : 1;
        return weight(b.urgency).compareTo(weight(a.urgency));
      });

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Doctor Practice Hub',
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (auth.user != null) {
            await apptProv.fetchAppointments(auth.user!.id, isDoctor: true);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Availability & Profile Card
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.primaryLight,
                          child: const Text('🩺', style: TextStyle(fontSize: 24)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                auth.user?.fullName ?? 'Dr. Specialist',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Apollo Hospitals Jubilee Hills',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        StatusBadge(status: _doctorAvailability),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Practice Availability:',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark),
                        ),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                                value: 'available',
                                label: Text('Active', style: TextStyle(fontSize: 11))),
                            ButtonSegment(
                                value: 'busy',
                                label: Text('In OPD', style: TextStyle(fontSize: 11))),
                            ButtonSegment(
                                value: 'offline',
                                label: Text('Off', style: TextStyle(fontSize: 11))),
                          ],
                          selected: {_doctorAvailability},
                          onSelectionChanged: (set) {
                            setState(() => _doctorAvailability = set.first);
                            DialogUtils.showSnackBar(
                              context,
                              'Availability updated to ${set.first}',
                            );
                          },
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Practice Quick Nav
              Row(
                children: [
                  Expanded(
                    child: _DoctorToolCard(
                      title: 'OPD Queue',
                      subtitle: 'Active tokens',
                      icon: Icons.confirmation_number_outlined,
                      color: const Color(0xFF8B5CF6),
                      onTap: () => Navigator.pushNamed(context, RouteNames.queue),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DoctorToolCard(
                      title: 'Field Worker',
                      subtitle: 'Rural diagnostics',
                      icon: Icons.biotech_outlined,
                      color: AppColors.accent,
                      onTap: () =>
                          Navigator.pushNamed(context, RouteNames.healthWorker),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Patient Consultation Queue Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Consultation Queue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${sortedAppointments.length} Bookings',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (sortedAppointments.isEmpty)
                const EmptyStateWidget(
                  icon: Icons.people_outline,
                  title: 'No Patient Consultations',
                  description:
                      'All appointments for today have been completed or there are no pending bookings.',
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sortedAppointments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) {
                    final appt = sortedAppointments[i];
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
                                  appt.patientName ?? 'Patient Consultation',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                              StatusBadge(status: appt.urgency),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Time: ${AppDateUtils.formatDate(appt.appointmentDate)} at ${AppDateUtils.formatTime(appt.appointmentTime)} • ${appt.appointmentType.toUpperCase()}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                          if (appt.reason != null && appt.reason!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Chief Complaint: ${appt.reason!}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (appt.isTeleconsult)
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.video_call_rounded,
                                      size: 16),
                                  label: const Text('Start Video Call',
                                      style: TextStyle(fontSize: 12)),
                                  onPressed: () => Navigator.pushNamed(
                                      context, RouteNames.teleconsult),
                                ),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                icon: const Icon(Icons.edit_note_rounded,
                                    size: 16),
                                label: const Text('Add Notes',
                                    style: TextStyle(fontSize: 12)),
                                onPressed: () => _showAddNotesDialog(appt),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoctorToolCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DoctorToolCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
