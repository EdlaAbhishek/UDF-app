import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/dialog_utils.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/custom_app_bar.dart';

class HealthWorkerScreen extends StatefulWidget {
  const HealthWorkerScreen({super.key});

  @override
  State<HealthWorkerScreen> createState() => _HealthWorkerScreenState();
}

class _HealthWorkerScreenState extends State<HealthWorkerScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _villageController = TextEditingController(text: 'Medchal Village');
  final _bpController = TextEditingController();
  final _hrController = TextEditingController();
  final _spo2Controller = TextEditingController();
  final _tempController = TextEditingController();
  final _glucoseController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isOfflineMode = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _villageController.dispose();
    _bpController.dispose();
    _hrController.dispose();
    _spo2Controller.dispose();
    _tempController.dispose();
    _glucoseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleSaveVitals() {
    if (_nameController.text.trim().isEmpty) {
      DialogUtils.showSnackBar(context, 'Please enter patient name.',
          isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      DialogUtils.showSnackBar(
        context,
        _isOfflineMode
            ? 'Vitals saved to offline device queue. Will sync when network is restored.'
            : 'Vitals successfully synchronized to regional health database!',
      );
      _nameController.clear();
      _phoneController.clear();
      _bpController.clear();
      _hrController.clear();
      _spo2Controller.clear();
      _tempController.clear();
      _glucoseController.clear();
      _notesController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Field Worker Mode (ASHA)'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mode Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _isOfflineMode
                    ? const Color(0xFFFEF3C7)
                    : AppColors.successLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isOfflineMode
                      ? const Color(0xFFF59E0B)
                      : AppColors.success,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isOfflineMode ? Icons.wifi_off_rounded : Icons.wifi_rounded,
                    color: _isOfflineMode
                        ? const Color(0xFFB45309)
                        : AppColors.success,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isOfflineMode
                              ? 'Offline-First Camp Mode Active'
                              : 'Online Synchronized',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: _isOfflineMode
                                ? const Color(0xFFB45309)
                                : AppColors.success,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Record patient vital parameters in rural field camps with zero latency.',
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isOfflineMode,
                    activeColor: const Color(0xFFB45309),
                    onChanged: (v) => setState(() => _isOfflineMode = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Patient Info
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Patient Demographics',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Patient Full Name *',
                    hint: 'e.g. Ramesh Babu',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Phone Number',
                          hint: '+91 98480 00000',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppTextField(
                          label: 'Village / Mandalam',
                          hint: 'Medchal',
                          controller: _villageController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Clinical Vitals
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Clinical Vitals Capture',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Blood Pressure',
                          hint: '120/80',
                          controller: _bpController,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppTextField(
                          label: 'Pulse (bpm)',
                          hint: '74',
                          controller: _hrController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'SpO2 (%)',
                          hint: '98',
                          controller: _spo2Controller,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppTextField(
                          label: 'Temp (°F)',
                          hint: '98.4',
                          controller: _tempController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppTextField(
                          label: 'Glucose (mg/dL)',
                          hint: '110',
                          controller: _glucoseController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    label: 'Field Worker Notes',
                    hint: 'Clinical observations, immediate advice provided...',
                    controller: _notesController,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            AppButton(
              label: 'Save Patient Vitals Record',
              icon: Icons.save_rounded,
              isLoading: _isSubmitting,
              onPressed: _handleSaveVitals,
            ),
          ],
        ),
      ),
    );
  }
}
