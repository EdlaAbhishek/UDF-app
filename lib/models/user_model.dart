class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String role; // 'patient', 'doctor', 'admin'
  final String? phone;
  final String? profilePhoto;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.phone,
    this.profilePhoto,
  });

  bool get isDoctor => role == 'doctor';
  bool get isAdmin => role == 'admin';
  bool get isPatient => role == 'patient';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? json['name'] ?? json['email'] ?? 'User',
      role: json['role'] ?? 'patient',
      phone: json['phone'],
      profilePhoto: json['profile_photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role,
      'phone': phone,
      'profile_photo': profilePhoto,
    };
  }
}
