class InsurancePolicyModel {
  final String id;
  final String provider;
  final String policyNumber;
  final String policyType;
  final int sumInsured;
  final int premium;
  final String validUntil;
  final String status;

  InsurancePolicyModel({
    required this.id,
    required this.provider,
    required this.policyNumber,
    required this.policyType,
    required this.sumInsured,
    required this.premium,
    required this.validUntil,
    this.status = 'active',
  });

  factory InsurancePolicyModel.fromJson(Map<String, dynamic> json) {
    return InsurancePolicyModel(
      id: json['id']?.toString() ?? '',
      provider: json['provider'] ?? 'Star Health',
      policyNumber: json['policy_number'] ?? 'POL-000000',
      policyType: json['policy_type'] ?? 'Comprehensive',
      sumInsured: json['sum_insured'] ?? 500000,
      premium: json['premium'] ?? 12500,
      validUntil: json['valid_until'] ?? '2026-12-31',
      status: json['status'] ?? 'active',
    );
  }
}

class InsuranceClaimModel {
  final String id;
  final String claimNumber;
  final String hospitalName;
  final String treatment;
  final int claimAmount;
  final int approvedAmount;
  final String status; // 'draft', 'submitted', 'under_review', 'approved', 'settled'
  final String submittedDate;

  InsuranceClaimModel({
    required this.id,
    required this.claimNumber,
    required this.hospitalName,
    required this.treatment,
    required this.claimAmount,
    required this.approvedAmount,
    required this.status,
    required this.submittedDate,
  });

  factory InsuranceClaimModel.fromJson(Map<String, dynamic> json) {
    return InsuranceClaimModel(
      id: json['id']?.toString() ?? '',
      claimNumber: json['claim_number'] ?? 'CLM-0000',
      hospitalName: json['hospital_name'] ?? 'Hospital',
      treatment: json['treatment'] ?? 'Medical Consultation',
      claimAmount: json['claim_amount'] ?? 50000,
      approvedAmount: json['approved_amount'] ?? 45000,
      status: json['status'] ?? 'under_review',
      submittedDate: json['submitted_date'] ?? '2026-09-01',
    );
  }
}
