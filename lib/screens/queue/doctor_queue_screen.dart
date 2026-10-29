import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/dialog_utils.dart';
import '../../models/queue_token_model.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/status_badge.dart';

class DoctorQueueScreen extends StatefulWidget {
  const DoctorQueueScreen({super.key});

  @override
  State<DoctorQueueScreen> createState() => _DoctorQueueScreenState();
}

class _DoctorQueueScreenState extends State<DoctorQueueScreen> {
  final List<QueueTokenModel> _queueList = [
    QueueTokenModel(
      id: 'tok-1',
      tokenNumber: 'A-118',
      hospitalName: 'Apollo Hospitals Jubilee Hills',
      department: 'Pulmonology',
      doctorName: 'Dr. Priya Sharma',
      status: 'in_consultation',
      peopleAhead: 0,
      estimatedWaitMinutes: 0,
      createdAt: '10:00 AM',
    ),
    QueueTokenModel(
      id: 'tok-2',
      tokenNumber: 'A-119',
      hospitalName: 'Apollo Hospitals Jubilee Hills',
      department: 'Pulmonology',
      doctorName: 'Dr. Priya Sharma',
      status: 'waiting',
      peopleAhead: 1,
      estimatedWaitMinutes: 10,
      createdAt: '10:15 AM',
    ),
    QueueTokenModel(
      id: 'tok-3',
      tokenNumber: 'A-120',
      hospitalName: 'Apollo Hospitals Jubilee Hills',
      department: 'Pulmonology',
      doctorName: 'Dr. Priya Sharma',
      status: 'waiting',
      peopleAhead: 2,
      estimatedWaitMinutes: 20,
      createdAt: '10:30 AM',
    ),
  ];

  void _callNext() {
    setState(() {
      if (_queueList.isNotEmpty) {
        _queueList.removeAt(0);
      }
    });
    DialogUtils.showSnackBar(
      context,
      _queueList.isNotEmpty
          ? 'Calling Token ${_queueList.first.tokenNumber} to Consultation Room 4'
          : 'All patients in queue have been consulted!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Doctor OPD Queue Management'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current in consultation card
            if (_queueList.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.success.withOpacity(0.4)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'CURRENTLY IN CONSULTATION',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _queueList.first.tokenNumber,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Consultation Room 4 • Department of Pulmonology',
                      style: TextStyle(fontSize: 12, color: AppColors.textMain),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.record_voice_over_rounded, size: 18),
                label: const Text('Complete & Call Next Patient',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                onPressed: _callNext,
              ),
              const SizedBox(height: 24),
            ],

            // Upcoming Queue
            Text(
              'Waiting Queue (${_queueList.length} Patients)',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),

            if (_queueList.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No patients waiting in queue.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _queueList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (ctx, i) {
                  final t = _queueList[i];
                  return AppCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                t.tokenNumber,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Issued at ${t.createdAt}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                Text(
                                  'Est. wait ~${t.estimatedWaitMinutes} mins',
                                  style: const TextStyle(
                                      fontSize: 11, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                        StatusBadge(status: t.status),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
