import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/dialog_utils.dart';
import '../../navigation/route_names.dart';
import '../../services/ai_service.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/custom_app_bar.dart';

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final _symptomsController = TextEditingController();
  final _ageController = TextEditingController(text: '34');
  final _genderController = TextEditingController(text: 'Male');
  final _tempController = TextEditingController();
  final _bpSysController = TextEditingController();
  final _bpDiaController = TextEditingController();
  final _hrController = TextEditingController();
  final _spo2Controller = TextEditingController();

  bool _isLoading = false;
  Map<String, dynamic>? _triageResult;

  @override
  void dispose() {
    _symptomsController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _tempController.dispose();
    _bpSysController.dispose();
    _bpDiaController.dispose();
    _hrController.dispose();
    _spo2Controller.dispose();
    super.dispose();
  }

  Future<void> _handleAnalyze() async {
    final symptoms = _symptomsController.text.trim();
    if (symptoms.isEmpty) {
      DialogUtils.showSnackBar(context, 'Please describe your symptoms first.',
          isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
      _triageResult = null;
    });

    final res = await AiService.analyzeSymptoms(
      symptoms: symptoms,
      age: _ageController.text.trim(),
      gender: _genderController.text.trim(),
      bpSys: _bpSysController.text.trim(),
      bpDia: _bpDiaController.text.trim(),
      heartRate: _hrController.text.trim(),
      spo2: _spo2Controller.text.trim(),
      temp: _tempController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _triageResult = res;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'AI Symptom Checker'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Disclaimer Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 20, color: AppColors.primary),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'AI Triage provides preliminary classification. For severe emergency signs (severe chest pain, stroke, breathlessness), call 108 immediately.',
                      style: TextStyle(fontSize: 12, color: AppColors.textMain),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Demographics Row
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Age',
                    hint: '34',
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    label: 'Gender',
                    hint: 'Male / Female',
                    controller: _genderController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Symptoms Description
            AppTextField(
              label: 'Describe your symptoms *',
              hint:
                  'e.g. Dry cough for 3 days, low grade evening fever, chest tightness, sore throat...',
              controller: _symptomsController,
              maxLines: 4,
            ),
            const SizedBox(height: 14),

            // Optional Vitals Accordion / Expansion
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text(
                'Clinical Vitals (Optional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              subtitle: const Text(
                'Add blood pressure, pulse, SpO2 for higher triage accuracy',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Temp (°F)',
                              hint: '98.6',
                              controller: _tempController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AppTextField(
                              label: 'Heart Rate (bpm)',
                              hint: '78',
                              controller: _hrController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AppTextField(
                              label: 'SpO2 (%)',
                              hint: '98',
                              controller: _spo2Controller,
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
                              label: 'BP Systolic (mmHg)',
                              hint: '120',
                              controller: _bpSysController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              label: 'BP Diastolic (mmHg)',
                              hint: '80',
                              controller: _bpDiaController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Analyze Button
            AppButton(
              label: 'Evaluate Symptoms with AI',
              icon: Icons.health_and_safety_outlined,
              isLoading: _isLoading,
              onPressed: _handleAnalyze,
            ),
            const SizedBox(height: 24),

            // Triage Result Section
            if (_triageResult != null) ...[
              _buildTriageCard(_triageResult!),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTriageCard(Map<String, dynamic> result) {
    final triage = result['triage'] ?? 'Routine';
    final score = result['confidenceScore'] ?? 80;
    final explanation = result['medicalExplanation'] ?? '';
    final conditions = (result['possibleConditions'] as List?) ?? [];
    final factors = (result['explainability'] as List?) ?? [];
    final carePlan = (result['preliminaryCarePlan'] as List?) ?? [];

    Color triageColor;
    Color triageBg;
    if (triage == 'Emergency') {
      triageColor = AppColors.emergency;
      triageBg = AppColors.emergencyLight;
    } else if (triage == 'Urgent') {
      triageColor = const Color(0xFFC2410C);
      triageBg = const Color(0xFFFFEDD5);
    } else {
      triageColor = AppColors.success;
      triageBg = AppColors.successLight;
    }

    return AppCard(
      padding: const EdgeInsets.all(18),
      border: Border.all(color: triageColor.withOpacity(0.5), width: 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: triageBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.shield_rounded, color: triageColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Triage Category: $triage',
                      style: TextStyle(
                        color: triageColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$score% Confidence',
                  style: TextStyle(
                    color: triageColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Clinical Reasoning
          const Text(
            'Clinical Assessment',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            explanation,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMain,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),

          // Possible conditions
          if (conditions.isNotEmpty) ...[
            const Text(
              'Possible Conditions Evaluated',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            ...conditions.map((c) {
              final name = c['condition'] ?? '';
              final prob = c['probability'] ?? 'Medium';
              final desc = c['explanation'] ?? '';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.textDark),
                          children: [
                            TextSpan(
                                text: '$name ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                            TextSpan(
                              text: '($prob Probability) - $desc',
                              style: const TextStyle(
                                  color: AppColors.textMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 14),
          ],

          // Key Risk & Clinical Factors
          if (factors.isNotEmpty) ...[
            const Text(
              'Key Risk & Clinical Factors',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: factors
                  .map((f) => Chip(
                        label: Text(f.toString(),
                            style: const TextStyle(fontSize: 11)),
                        backgroundColor: AppColors.surface,
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 14),
          ],

          // Care Plan Steps
          if (carePlan.isNotEmpty) ...[
            const Text(
              'Preliminary Care Recommendations',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            ...carePlan.map(
              (step) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline,
                        size: 16, color: AppColors.success),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        step.toString(),
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textMain),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],

          // Direct Booking Call to Action
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calendar_month_rounded, size: 18),
              label: Text(
                triage == 'Emergency'
                    ? 'Find Emergency Trauma Center'
                    : 'Book Specialist Consultation',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    triage == 'Emergency' ? AppColors.emergency : AppColors.primary,
              ),
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.hospitals);
              },
            ),
          ),
        ],
      ),
    );
  }
}
