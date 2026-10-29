class DoctorModel {
  final String id;
  final String fullName;
  final String specialty;
  final String hospitalName;
  final String? profilePhoto;
  final String availabilityStatus; // 'available', 'busy', 'offline'
  final int experienceYears;
  final double rating;
  final String? consultationFee;

  DoctorModel({
    required this.id,
    required this.fullName,
    required this.specialty,
    required this.hospitalName,
    this.profilePhoto,
    this.availabilityStatus = 'available',
    this.experienceYears = 8,
    this.rating = 4.8,
    this.consultationFee = '₹500',
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name'] ?? json['name'] ?? 'Doctor',
      specialty: json['specialty'] ?? 'General Medicine',
      hospitalName: json['hospital_name'] ?? 'Hospital Partner',
      profilePhoto: json['profile_photo'],
      availabilityStatus: json['availability_status'] ?? 'available',
      experienceYears: json['experience_years'] ?? 8,
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 4.8,
      consultationFee: json['consultation_fee'] != null ? '₹${json['consultation_fee']}' : '₹500',
    );
  }
}
