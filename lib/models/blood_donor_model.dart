class BloodDonorModel {
  final String id;
  final String name;
  final String bloodGroup;
  final String city;
  final String phone;
  final bool isAvailable;

  BloodDonorModel({
    required this.id,
    required this.name,
    required this.bloodGroup,
    required this.city,
    required this.phone,
    this.isAvailable = true,
  });

  factory BloodDonorModel.fromJson(Map<String, dynamic> json) {
    return BloodDonorModel(
      id: json['id']?.toString() ?? '',
      name: json['full_name'] ?? json['name'] ?? 'Donor',
      bloodGroup: json['blood_group'] ?? 'O+',
      city: json['city'] ?? json['location'] ?? 'Hyderabad',
      phone: json['phone'] ?? '+91 98480 12345',
      isAvailable: json['is_available'] != false,
    );
  }
}
