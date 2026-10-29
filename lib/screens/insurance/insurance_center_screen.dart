import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/insurance_model.dart';
import '../../services/insurance_service.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/status_badge.dart';

class InsuranceCenterScreen extends StatefulWidget {
  const InsuranceCenterScreen({super.key});

  @override
  State<InsuranceCenterScreen> createState() => _InsuranceCenterScreenState();
}

class _InsuranceCenterScreenState extends State<InsuranceCenterScreen> {
  final InsuranceService _service = InsuranceService();
  List<InsurancePolicyModel> _policies = [];
  List<InsuranceClaimModel> _claims = [];
  bool _isLoading = true;

  final Map<String, bool> _preAuthChecklist = {
    'Doctor Prescription': true,
    'Diagnostic Test Reports': true,
    'Physical / Digital Insurance Card': true,
    'Government ID Proof (Aadhaar / Voter)': true,
    'Hospital Admission Cost Estimate': false,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final policies = await _service.getPolicies('patient-1');
    final claims = await _service.getClaims('patient-1');
    if (mounted) {
      setState(() {
        _policies = policies;
        _claims = claims;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Health Insurance'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Active Policy Card
                  if (_policies.isNotEmpty) ...[
                    _PolicyCard(policy: _policies.first),
                    const SizedBox(height: 24),
                  ],

                  // Pre-Authorization Checklist
                  const Text(
                    'Cashless Pre-Authorization Checklist',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Ensure these documents are ready before planned hospital admission.',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 12),

                  AppCard(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: _preAuthChecklist.entries.map((entry) {
                        return CheckboxListTile(
                          dense: true,
                          title: Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark,
                            ),
                          ),
                          value: entry.value,
                          activeColor: AppColors.primary,
                          onChanged: (val) {
                            setState(() {
                              _preAuthChecklist[entry.key] = val ?? false;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Claims Tracker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Claims & Reimbursements',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        '${_claims.length} Records',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _claims.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final claim = _claims[i];
                      return _ClaimCard(claim: claim);
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  final InsurancePolicyModel policy;

  const _PolicyCard({required this.policy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330F172A),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                policy.provider,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              StatusBadge(status: policy.status),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            policy.policyType,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 18),
          const Text(
            'TOTAL SUM INSURED',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            '₹${(policy.sumInsured / 100000).toStringAsFixed(1)} Lakhs',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Policy: ${policy.policyNumber}',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
              Text(
                'Valid until ${policy.validUntil}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClaimCard extends StatelessWidget {
  final InsuranceClaimModel claim;

  const _ClaimCard({required this.claim});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                claim.claimNumber,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              StatusBadge(status: claim.status),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${claim.treatment} • ${claim.hospitalName}',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Claimed Amount',
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  Text(
                    '₹${claim.claimAmount}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Approved Amount',
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  Text(
                    '₹${claim.approvedAmount}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
