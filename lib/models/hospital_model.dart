class HospitalModel {
  final String id;
  final String name;
  final String city;
  final String address;
  final String beds;
  final bool hasEmergency;
  final bool hasTeleconsult;
  final double rating;
  final String? phone;
  final String? email;

  HospitalModel({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.beds,
    required this.hasEmergency,
    required this.hasTeleconsult,
    this.rating = 4.5,
    this.phone,
    this.email,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Hospital',
      city: json['city'] ?? json['address'] ?? 'India',
      address: json['address'] ?? json['city'] ?? 'India',
      beds: json['beds'] != null ? '${json['beds']}+' : '200+',
      hasEmergency: json['emergency'] != false,
      hasTeleconsult: json['teleconsult'] == true,
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 4.5,
      phone: json['phone'],
      email: json['email'],
    );
  }
}
