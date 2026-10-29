import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/dialog_utils.dart';
import '../../models/doctor_model.dart';
import '../../navigation/route_names.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/custom_app_bar.dart';

class BookingScreen extends StatefulWidget {
  final DoctorModel doctor;

  const BookingScreen({super.key, required this.doctor});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _reasonController = TextEditingController();
  String _appointmentType = 'in-person';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedSlot = '10:00';
  bool _isLoading = false;

  final List<String> _timeSlots = [
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirmBooking() async {
    final auth = context.read<AuthProvider>();
    if (auth.user == null) {
      DialogUtils.showSnackBar(context, 'Please log in to book appointments.',
          isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await context.read<AppointmentProvider>().bookAppointment(
            patientId: auth.user!.id,
            doctorId: widget.doctor.id,
            appointmentDate: _selectedDate.toIso8601String(),
            appointmentTime: _selectedSlot,
            appointmentType: _appointmentType,
            reason: _reasonController.text.trim().isNotEmpty
                ? _reasonController.text.trim()
                : 'General consultation',
            doctorName: widget.doctor.fullName,
            hospitalName: widget.doctor.hospitalName,
            specialty: widget.doctor.specialty,
            patientName: auth.user!.fullName,
          );

      if (!mounted) return;

      DialogUtils.showSnackBar(
        context,
        'Appointment confirmed with ${widget.doctor.fullName}!',
      );

      // Return to main dashboard
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.mainShell,
        (route) => false,
      );
    } catch (e) {
      DialogUtils.showSnackBar(context, 'Booking failed: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Book Appointment'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Doctor banner
            AppCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      widget.doctor.fullName.isNotEmpty
                          ? widget.doctor.fullName[0]
                          : 'D',
                      style: const TextStyle(
                          color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctor.fullName,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${widget.doctor.specialty} • ${widget.doctor.hospitalName}',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Consultation Mode
            const Text(
              'Consultation Type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _ModeOptionCard(
                    title: 'In-Person Visit',
                    subtitle: 'Clinic or Hospital OPD',
                    icon: Icons.apartment_rounded,
                    isSelected: _appointmentType == 'in-person',
                    onTap: () =>
                        setState(() => _appointmentType = 'in-person'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ModeOptionCard(
                    title: 'Video Consult',
                    subtitle: 'Secure Teleconsultation',
                    icon: Icons.video_call_rounded,
                    isSelected: _appointmentType == 'video-call',
                    onTap: () =>
                        setState(() => _appointmentType = 'video-call'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Date Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Date',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  child: Text(
                    AppDateUtils.formatDate(_selectedDate),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Time Slots
            const Text(
              'Available Time Slots',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timeSlots.map((slot) {
                final selected = _selectedSlot == slot;
                return InkWell(
                  onTap: () => setState(() => _selectedSlot = slot),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: Text(
                      AppDateUtils.formatTime(slot),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : AppColors.textMain,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Reason for Visit
            AppTextField(
              label: 'Reason for Visit / Symptoms',
              hint: 'Describe your symptoms or reason for consulting the doctor',
              controller: _reasonController,
              maxLines: 3,
            ),
            const SizedBox(height: 28),

            // Confirm Button
            AppButton(
              label: 'Confirm Consultation Booking',
              icon: Icons.check_circle_outline,
              isLoading: _isLoading,
              onPressed: _handleConfirmBooking,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                size: 22),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primary : AppColors.textDark,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
