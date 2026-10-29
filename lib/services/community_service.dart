import '../models/blood_donor_model.dart';
import 'supabase_service.dart';

class CommunityService {
  static final List<BloodDonorModel> _demoDonors = [
    BloodDonorModel(
      id: 'donor-1',
      name: 'Rohan Varma',
      bloodGroup: 'O+',
      city: 'Hyderabad',
      phone: '+91 98480 11223',
      isAvailable: true,
    ),
    BloodDonorModel(
      id: 'donor-2',
      name: 'Sneha Reddy',
      bloodGroup: 'A+',
      city: 'Secunderabad',
      phone: '+91 94401 33445',
      isAvailable: true,
    ),
    BloodDonorModel(
      id: 'donor-3',
      name: 'Amitabh Joshi',
      bloodGroup: 'B+',
      city: 'Hyderabad',
      phone: '+91 98765 43210',
      isAvailable: true,
    ),
    BloodDonorModel(
      id: 'donor-4',
      name: 'Pooja Nair',
      bloodGroup: 'AB+',
      city: 'Hyderabad',
      phone: '+91 91234 56789',
      isAvailable: false,
    ),
    BloodDonorModel(
      id: 'donor-5',
      name: 'Vikram Singh',
      bloodGroup: 'O-',
      city: 'Secunderabad',
      phone: '+91 95500 88776',
      isAvailable: true,
    ),
  ];

  Future<List<BloodDonorModel>> getBloodDonors({String? bloodGroup, String? city}) async {
    try {
      var query = SupabaseService.client.from('blood_donors').select('*');
      if (bloodGroup != null && bloodGroup.isNotEmpty) {
        query = query.eq('blood_group', bloodGroup);
      }
      final res = await query.timeout(const Duration(seconds: 4));
      if (res.isNotEmpty) {
        return (res as List)
            .map((e) => BloodDonorModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}

    var results = _demoDonors;
    if (bloodGroup != null && bloodGroup.isNotEmpty) {
      results = results.where((d) => d.bloodGroup == bloodGroup).toList();
    }
    if (city != null && city.isNotEmpty) {
      results = results.where((d) => d.city.toLowerCase().contains(city.toLowerCase())).toList();
    }
    return results;
  }

  void registerDonor(BloodDonorModel donor) {
    _demoDonors.insert(0, donor);
  }
}
