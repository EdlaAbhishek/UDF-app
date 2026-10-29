import '../models/insurance_model.dart';
import 'supabase_service.dart';

class InsuranceService {
  static final List<InsurancePolicyModel> _demoPolicies = [
    InsurancePolicyModel(
      id: 'pol-1',
      provider: 'Star Health & Allied Insurance',
      policyNumber: 'P/2026/SH/0042891',
      policyType: 'Comprehensive Family Floater',
      sumInsured: 1000000,
      premium: 14500,
      validUntil: '31 Dec 2026',
      status: 'active',
    ),
  ];

  static final List<InsuranceClaimModel> _demoClaims = [
    InsuranceClaimModel(
      id: 'claim-1',
      claimNumber: 'CLM-2026-09-00127',
      hospitalName: 'KIMS Hospital Secunderabad',
      treatment: 'Emergency Appendectomy & Post-Op Care',
      claimAmount: 85000,
      approvedAmount: 78000,
      status: 'settled',
      submittedDate: '20 Jun 2026',
    ),
    InsuranceClaimModel(
      id: 'claim-2',
      claimNumber: 'CLM-2026-09-00441',
      hospitalName: 'Apollo Hospitals Jubilee Hills',
      treatment: 'Respiratory Care & Diagnostic Workup',
      claimAmount: 18500,
      approvedAmount: 16200,
      status: 'under_review',
      submittedDate: '18 Sep 2026',
    ),
  ];

  Future<List<InsurancePolicyModel>> getPolicies(String patientId) async {
    try {
      final res = await SupabaseService.client
          .from('insurance_policies')
          .select('*')
          .eq('patient_id', patientId)
          .timeout(const Duration(seconds: 4));
      if (res.isNotEmpty) {
        return (res as List)
            .map((e) => InsurancePolicyModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return _demoPolicies;
  }

  Future<List<InsuranceClaimModel>> getClaims(String patientId) async {
    try {
      final res = await SupabaseService.client
          .from('insurance_claims')
          .select('*')
          .eq('patient_id', patientId)
          .timeout(const Duration(seconds: 4));
      if (res.isNotEmpty) {
        return (res as List)
            .map((e) => InsuranceClaimModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return _demoClaims;
  }
}
