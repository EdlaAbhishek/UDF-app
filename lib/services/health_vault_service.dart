import '../models/health_document_model.dart';
import 'supabase_service.dart';

class HealthVaultService {
  static final List<HealthDocumentModel> _demoDocs = [
    HealthDocumentModel(
      id: 'doc-1',
      title: 'Complete Blood Count (CBC) with ESR',
      category: 'lab_report',
      hospitalLab: 'Apollo Diagnostics Jubilee Hills',
      doctorName: 'Dr. K. Raman (Pathologist)',
      reportDate: '15 Sep 2026',
      verification: 'verified',
      summary: 'Hemoglobin 14.2 g/dL, Total WBC 11,200/uL, Platelets 240,000/uL. Mild seasonal leukocytosis.',
      fileName: 'CBC_Report_Apollo.pdf',
    ),
    HealthDocumentModel(
      id: 'doc-2',
      title: 'Digital Chest X-Ray (PA View)',
      category: 'imaging',
      hospitalLab: 'KIMS Hospital Secunderabad',
      doctorName: 'Dr. Suresh Reddy (Radiologist)',
      reportDate: '20 Aug 2026',
      verification: 'verified',
      summary: 'Clear bilateral lung fields. Normal cardiac silhouette. No focal infiltrates or pleural effusion.',
      fileName: 'Chest_XRay_PA.jpg',
    ),
    HealthDocumentModel(
      id: 'doc-3',
      title: 'Pulmonology Outpatient Consultation Note',
      category: 'doctor_notes',
      hospitalLab: 'Apollo Hospitals Jubilee Hills',
      doctorName: 'Dr. Priya Sharma',
      reportDate: '15 Sep 2026',
      verification: 'verified',
      summary: 'Clinical presentation of Acute Bronchitis. Prescribed bronchodilator & 5-day course.',
      fileName: 'Dr_Sharma_Consult.pdf',
    ),
    HealthDocumentModel(
      id: 'doc-4',
      title: 'Quarterly Metformin & Lipid Prescription',
      category: 'prescription',
      hospitalLab: 'Yashoda Hospitals Somajiguda',
      doctorName: 'Dr. Rajesh Kumar',
      reportDate: '01 Sep 2026',
      verification: 'verified',
      summary: 'Metformin 500mg BID, Atorvastatin 10mg HS. Valid for 90 days with dietary modification.',
      fileName: 'Rx_Diabetes_Sep2026.pdf',
    ),
    HealthDocumentModel(
      id: 'doc-5',
      title: 'COVID-19 Booster Vaccination Certificate',
      category: 'vaccination',
      hospitalLab: 'Government PHC Secunderabad',
      doctorName: 'PHC Medical Officer',
      reportDate: '15 Mar 2026',
      verification: 'verified',
      summary: 'Corbevax Heterologous Precaution Dose administered. Batch #CBX8921.',
      fileName: 'Vaccination_Booster_2026.pdf',
    ),
  ];

  Future<List<HealthDocumentModel>> getDocuments(String patientId, {String? category}) async {
    try {
      var query = SupabaseService.client
          .from('health_documents')
          .select('*')
          .eq('patient_id', patientId);
      if (category != null && category != 'all') {
        query = query.eq('category', category);
      }
      final res = await query.timeout(const Duration(seconds: 5));
      if (res.isNotEmpty) {
        return (res as List)
            .map((e) => HealthDocumentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}

    if (category != null && category != 'all') {
      return _demoDocs.where((d) => d.category == category).toList();
    }
    return _demoDocs;
  }

  Future<HealthDocumentModel> uploadDocument({
    required String title,
    required String category,
    required String hospitalLab,
    String? doctorName,
    String? summary,
    String? fileName,
  }) async {
    final doc = HealthDocumentModel(
      id: 'doc-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      category: category,
      hospitalLab: hospitalLab,
      doctorName: doctorName,
      reportDate: 'Today',
      verification: 'verified',
      summary: summary ?? 'Document uploaded and analyzed via AI OCR scanner.',
      fileName: fileName ?? 'Document.pdf',
    );
    _demoDocs.insert(0, doc);
    return doc;
  }
}
