import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/dialog_utils.dart';
import '../../models/care_circle_model.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_app_bar.dart';

class CareCircleScreen extends StatefulWidget {
  const CareCircleScreen({super.key});

  @override
  State<CareCircleScreen> createState() => _CareCircleScreenState();
}

class _CareCircleScreenState extends State<CareCircleScreen> {
  final List<CareCircleMemberModel> _members = [
    CareCircleMemberModel(
      id: 'mem-1',
      name: 'Savitri Varma',
      relationship: 'Mother',
      phone: '+91 98480 33412',
      email: 'savitri.varma@example.com',
      isEmergencyContact: true,
      permissions: {
        'appointments': true,
        'medications': true,
        'emergency': true,
        'labReports': false,
        'fullHistory': false,
      },
    ),
    CareCircleMemberModel(
      id: 'mem-2',
      name: 'Sunita Varma',
      relationship: 'Spouse',
      phone: '+91 94401 55678',
      email: 'sunita.v@example.com',
      isEmergencyContact: true,
      permissions: {
        'appointments': true,
        'medications': true,
        'emergency': true,
        'labReports': true,
        'fullHistory': true,
      },
    ),
    CareCircleMemberModel(
      id: 'mem-3',
      name: 'Kavita Reddy',
      relationship: 'Caregiver / Nurse',
      phone: '+91 91234 88765',
      email: 'kavita.reddy@caregivers.in',
      isEmergencyContact: false,
      permissions: {
        'appointments': false,
        'medications': true,
        'emergency': false,
        'labReports': false,
        'fullHistory': false,
      },
    ),
  ];

  void _showAddMemberDialog() {
    final nameCtrl = TextEditingController();
    final relationCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    bool isEmergency = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Family / Caregiver',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: relationCtrl,
                decoration: const InputDecoration(
                    labelText: 'Relationship (e.g. Brother, Son, Nurse)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('Emergency Contact',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                value: isEmergency,
                onChanged: (v) => setDialogState(() => isEmergency = v),
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
                if (nameCtrl.text.trim().isEmpty) return;
                setState(() {
                  _members.add(
                    CareCircleMemberModel(
                      id: 'mem-${DateTime.now().millisecondsSinceEpoch}',
                      name: nameCtrl.text.trim(),
                      relationship: relationCtrl.text.trim().isNotEmpty
                          ? relationCtrl.text.trim()
                          : 'Family',
                      phone: phoneCtrl.text.trim(),
                      email: '',
                      isEmergencyContact: isEmergency,
                      permissions: {
                        'appointments': true,
                        'medications': true,
                        'emergency': isEmergency,
                        'labReports': false,
                        'fullHistory': false,
                      },
                    ),
                  );
                });
                Navigator.pop(ctx);
                DialogUtils.showSnackBar(
                    context, '${nameCtrl.text.trim()} added to Care Circle.');
              },
              child: const Text('Add Member'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Care Circle',
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_outlined,
                color: AppColors.primary),
            onPressed: _showAddMemberDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.family_restroom,
                      color: AppColors.primary, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Care Circle allows your trusted family members and caregivers to receive emergency SOS alerts and monitor your medications.',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryDark,
                          height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Connected Circle Members',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  '${_members.length} Members',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _members.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final mem = _members[i];
                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.surface,
                            child: Text(
                              mem.name.isNotEmpty ? mem.name[0] : 'M',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mem.name,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '${mem.relationship} • ${mem.phone}',
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                          if (mem.isEmergencyContact)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.emergencyLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                '🚨 SOS Contact',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.emergency,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text(
                        'Granted Permissions:',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: mem.permissions.entries.map((p) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: p.value
                                  ? AppColors.successLight
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${p.key}: ${p.value ? "Yes" : "No"}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: p.value
                                    ? AppColors.success
                                    : AppColors.textLight,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
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
