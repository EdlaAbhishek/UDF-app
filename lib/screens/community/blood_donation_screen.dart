import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/dialog_utils.dart';
import '../../models/blood_donor_model.dart';
import '../../services/community_service.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_app_bar.dart';

class BloodDonationScreen extends StatefulWidget {
  const BloodDonationScreen({super.key});

  @override
  State<BloodDonationScreen> createState() => _BloodDonationScreenState();
}

class _BloodDonationScreenState extends State<BloodDonationScreen> {
  final CommunityService _service = CommunityService();
  List<BloodDonorModel> _donors = [];
  bool _isLoading = true;
  String _selectedGroup = 'all';

  final List<String> _bloodGroups = [
    'all',
    'O+',
    'A+',
    'B+',
    'AB+',
    'O-',
    'A-',
    'B-',
    'AB-',
  ];

  @override
  void initState() {
    super.initState();
    _fetchDonors();
  }

  Future<void> _fetchDonors() async {
    setState(() => _isLoading = true);
    final group = _selectedGroup == 'all' ? null : _selectedGroup;
    final res = await _service.getBloodDonors(bloodGroup: group);
    if (mounted) {
      setState(() {
        _donors = res;
        _isLoading = false;
      });
    }
  }

  void _showRegisterDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final cityCtrl = TextEditingController(text: 'Hyderabad');
    String grp = 'O+';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Register as Blood Donor',
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
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: grp,
                items: ['O+', 'A+', 'B+', 'AB+', 'O-', 'A-', 'B-', 'AB-']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setDialogState(() => grp = v);
                },
                decoration: const InputDecoration(labelText: 'Blood Group'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cityCtrl,
                decoration: const InputDecoration(labelText: 'City / District'),
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
                final donor = BloodDonorModel(
                  id: 'd-${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text.trim(),
                  bloodGroup: grp,
                  city: cityCtrl.text.trim(),
                  phone: phoneCtrl.text.trim(),
                );
                _service.registerDonor(donor);
                Navigator.pop(ctx);
                _fetchDonors();
                DialogUtils.showSnackBar(
                    context, 'Thank you! You are registered as an active donor.');
              },
              child: const Text('Register Donor'),
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
        title: 'Blood Donor Network',
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Register'),
            onPressed: _showRegisterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Row
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _bloodGroups.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final grp = _bloodGroups[i];
                final selected = _selectedGroup == grp;
                return InkWell(
                  onTap: () {
                    setState(() => _selectedGroup = grp);
                    _fetchDonors();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.emergency : AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selected ? AppColors.emergency : AppColors.border,
                      ),
                    ),
                    child: Text(
                      grp == 'all' ? 'All Groups' : grp,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : AppColors.textMain,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Donor List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _donors.isEmpty
                    ? const Center(
                        child: Text(
                          'No available blood donors found for this group.',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        itemCount: _donors.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (ctx, i) {
                          final d = _donors[i];
                          return AppCard(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.emergencyLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      d.bloodGroup,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.emergency,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        d.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      Text(
                                        '${d.city} • ${d.phone}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.phone,
                                      color: AppColors.success),
                                  onPressed: () async {
                                    final uri = Uri.parse('tel:${d.phone}');
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri);
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
