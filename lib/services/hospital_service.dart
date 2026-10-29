import '../models/hospital_model.dart';
import '../models/doctor_model.dart';
import 'supabase_service.dart';

class HospitalService {
  static final List<HospitalModel> _fallbackHospitals = [
    HospitalModel(
      id: 'hosp-1',
      name: 'Apollo Hospitals Jubilee Hills',
      city: 'Hyderabad',
      address: 'Road No 72, Opp Bharatiya Vidya Bhavan, Jubilee Hills, Hyderabad',
      beds: '500+',
      hasEmergency: true,
      hasTeleconsult: true,
      rating: 4.8,
      phone: '+91 40 2360 7777',
      email: 'jubileehills@apollohospitals.com',
    ),
    HospitalModel(
      id: 'hosp-2',
      name: 'KIMS Hospital Secunderabad',
      city: 'Secunderabad',
      address: '1-8-31/1, Minister Rd, Krishna Nagar Colony, Begumpet, Secunderabad',
      beds: '1000+',
      hasEmergency: true,
      hasTeleconsult: true,
      rating: 4.7,
      phone: '+91 40 4488 5000',
      email: 'info@kimshospitals.com',
    ),
    HospitalModel(
      id: 'hosp-3',
      name: 'Yashoda Hospitals Somajiguda',
      city: 'Hyderabad',
      address: 'Raj Bhavan Rd, Matha Nagar, Somajiguda, Hyderabad',
      beds: '400+',
      hasEmergency: true,
      hasTeleconsult: true,
      rating: 4.6,
      phone: '+91 40 4567 4567',
      email: 'contact@yashodahospitals.com',
    ),
    HospitalModel(
      id: 'hosp-4',
      name: 'Care Hospitals Banjara Hills',
      city: 'Hyderabad',
      address: 'Road No 1, Banjara Hills, Hyderabad',
      beds: '350+',
      hasEmergency: true,
      hasTeleconsult: false,
      rating: 4.5,
      phone: '+91 40 6165 6565',
      email: 'info@carehospitals.com',
    ),
    HospitalModel(
      id: 'hosp-5',
      name: 'NIMS (Nizam\'s Institute of Medical Sciences)',
      city: 'Hyderabad',
      address: 'Punjagutta, Hyderabad',
      beds: '1200+',
      hasEmergency: true,
      hasTeleconsult: true,
      rating: 4.4,
      phone: '+91 40 2348 9000',
    ),
  ];

  static final List<DoctorModel> _fallbackDoctors = [
    DoctorModel(
      id: 'doc-1',
      fullName: 'Dr. Priya Sharma',
      specialty: 'Pulmonology & Critical Care',
      hospitalName: 'Apollo Hospitals Jubilee Hills',
      availabilityStatus: 'available',
      experienceYears: 12,
      rating: 4.9,
      consultationFee: '₹800',
    ),
    DoctorModel(
      id: 'doc-2',
      fullName: 'Dr. Suresh Reddy',
      specialty: 'Cardiology',
      hospitalName: 'KIMS Hospital Secunderabad',
      availabilityStatus: 'available',
      experienceYears: 16,
      rating: 4.8,
      consultationFee: '₹1000',
    ),
    DoctorModel(
      id: 'doc-3',
      fullName: 'Dr. Rajesh Kumar',
      specialty: 'General Medicine & Diabetology',
      hospitalName: 'Yashoda Hospitals Somajiguda',
      availabilityStatus: 'available',
      experienceYears: 10,
      rating: 4.7,
      consultationFee: '₹600',
    ),
    DoctorModel(
      id: 'doc-4',
      fullName: 'Dr. Anil Kumar',
      specialty: 'Orthopedics',
      hospitalName: 'Care Hospitals Banjara Hills',
      availabilityStatus: 'busy',
      experienceYears: 14,
      rating: 4.6,
      consultationFee: '₹750',
    ),
    DoctorModel(
      id: 'doc-5',
      fullName: 'Dr. Kavitha Nair',
      specialty: 'Pediatrics',
      hospitalName: 'Apollo Hospitals Jubilee Hills',
      availabilityStatus: 'available',
      experienceYears: 9,
      rating: 4.9,
      consultationFee: '₹700',
    ),
  ];

  Future<List<HospitalModel>> getHospitals() async {
    try {
      final res = await SupabaseService.client
          .from('hospitals')
          .select('*')
          .timeout(const Duration(seconds: 5));
      if (res.isNotEmpty) {
        return (res as List)
            .map((e) => HospitalModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print('Hospital fetch fallback: $e');
    }
    return _fallbackHospitals;
  }

  Future<List<DoctorModel>> getDoctors({String? hospitalName}) async {
    try {
      var query = SupabaseService.client.from('doctors').select('*');
      if (hospitalName != null && hospitalName.isNotEmpty) {
        query = query.eq('hospital_name', hospitalName);
      }
      final res = await query.timeout(const Duration(seconds: 5));
      if (res.isNotEmpty) {
        return (res as List)
            .map((e) => DoctorModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print('Doctors fetch fallback: $e');
    }
    if (hospitalName != null) {
      return _fallbackDoctors
          .where((d) => d.hospitalName.toLowerCase().contains(hospitalName.toLowerCase()))
          .toList();
    }
    return _fallbackDoctors;
  }
}
