import 'package:flutter/material.dart';
import '../../core/utils/dialog_utils.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/custom_app_bar.dart';

class ApplyDoctorScreen extends StatefulWidget {
  const ApplyDoctorScreen({super.key});

  @override
  State<ApplyDoctorScreen> createState() => _ApplyDoctorScreenState();
}

class _ApplyDoctorScreenState extends State<ApplyDoctorScreen> {
  final _regNumberCtrl = TextEditingController();
  final _specialtyCtrl = TextEditingController();
  final _degreeCtrl = TextEditingController();
  final _hospitalCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _regNumberCtrl.dispose();
    _specialtyCtrl.dispose();
    _degreeCtrl.dispose();
    _hospitalCtrl.dispose();
    _expCtrl.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_regNumberCtrl.text.trim().isEmpty || _specialtyCtrl.text.trim().isEmpty) {
      DialogUtils.showSnackBar(
          context, 'Please fill in registration number and specialty.',
          isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      DialogUtils.showSnackBar(
        context,
        'Doctor verification application submitted! Platform admins will review your credentials within 24 hours.',
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Doctor Network Application'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Clinical Provider Credentials',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Join India’s trusted integrated hospital and telemedicine network.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'State Medical Council / MCI Registration Number *',
                    hint: 'e.g. TSMC-2019-94812',
                    controller: _regNumberCtrl,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Primary Specialty *',
                    hint: 'e.g. Pulmonology / Cardiology / General Medicine',
                    controller: _specialtyCtrl,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Highest Medical Degree',
                    hint: 'e.g. MBBS, MD, DM, DNB',
                    controller: _degreeCtrl,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Primary Hospital Affiliation',
                    hint: 'e.g. Apollo Hospitals Jubilee Hills',
                    controller: _hospitalCtrl,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Years of Clinical Experience',
                    hint: 'e.g. 10',
                    controller: _expCtrl,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Submit Verification Application',
              icon: Icons.assignment_turned_in_outlined,
              isLoading: _isSubmitting,
              onPressed: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
