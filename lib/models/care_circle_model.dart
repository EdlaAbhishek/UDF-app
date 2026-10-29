class CareCircleMemberModel {
  final String id;
  final String name;
  final String relationship;
  final String phone;
  final String email;
  final bool isEmergencyContact;
  final Map<String, bool> permissions;

  CareCircleMemberModel({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phone,
    required this.email,
    required this.isEmergencyContact,
    required this.permissions,
  });

  factory CareCircleMemberModel.fromJson(Map<String, dynamic> json) {
    return CareCircleMemberModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      relationship: json['relationship'] ?? 'Family',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      isEmergencyContact: json['isEmergencyContact'] == true,
      permissions: Map<String, bool>.from(json['permissions'] ?? {
        'appointments': true,
        'medications': true,
        'emergency': true,
        'labReports': false,
        'fullHistory': false,
      }),
    );
  }
}
