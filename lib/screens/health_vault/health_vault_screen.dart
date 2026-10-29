import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/dialog_utils.dart';
import '../../models/health_document_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/health_vault_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/status_badge.dart';

class HealthVaultScreen extends StatefulWidget {
  const HealthVaultScreen({super.key});

  @override
  State<HealthVaultScreen> createState() => _HealthVaultScreenState();
}

class _HealthVaultScreenState extends State<HealthVaultScreen> {
  final List<Map<String, String>> _categories = [
    {'id': 'all', 'label': 'All Records', 'icon': '📂'},
    {'id': 'lab_report', 'label': 'Lab Reports', 'icon': '🧪'},
    {'id': 'prescription', 'label': 'Prescriptions', 'icon': '💊'},
    {'id': 'doctor_notes', 'label': 'Doctor Notes', 'icon': '📋'},
    {'id': 'imaging', 'label': 'Scans & X-Ray', 'icon': '🔬'},
    {'id': 'vaccination', 'label': 'Vaccines', 'icon': '💉'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        context.read<HealthVaultProvider>().fetchDocuments(user.id);
      }
    });
  }

  void _showUploadDialog() {
    final titleController = TextEditingController();
    final hospitalController = TextEditingController(text: 'Apollo Hospitals');
    String selectedCat = 'prescription';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Upload & Scan Document',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Upload prescription, lab report, or diagnostic scan for AI OCR extraction and regional translation.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Document Title',
                  hintText: 'e.g. CBC Blood Test or Metformin Rx',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: hospitalController,
                decoration: const InputDecoration(
                  labelText: 'Hospital or Diagnostic Lab',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCat,
                items: [
                  const DropdownMenuItem(value: 'prescription', child: Text('Prescription')),
                  const DropdownMenuItem(value: 'lab_report', child: Text('Lab Report')),
                  const DropdownMenuItem(value: 'doctor_notes', child: Text('Doctor Notes')),
                  const DropdownMenuItem(value: 'imaging', child: Text('Imaging / Scan')),
                  const DropdownMenuItem(value: 'vaccination', child: Text('Vaccination')),
                ],
                onChanged: (v) {
                  if (v != null) setDialogState(() => selectedCat = v);
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                await context.read<HealthVaultProvider>().uploadDocument(
                      title: titleController.text.trim(),
                      category: selectedCat,
                      hospitalLab: hospitalController.text.trim(),
                    );
                if (mounted) {
                  DialogUtils.showSnackBar(
                      context, 'Document uploaded & categorized successfully!');
                }
              },
              child: const Text('Upload Document'),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareCodeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.share_outlined, color: AppColors.primary, size: 22),
            SizedBox(width: 8),
            Text('Temporary Doctor Access',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share this secure one-time passcode with your consulting doctor to grant temporary 30-minute access to your health documents.',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: const Text(
                '7 4 9 - 2 0 1',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '⏱️ Expires in 30 minutes • Full audit logged',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vaultProv = context.watch<HealthVaultProvider>();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Health Vault',
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.primary),
            tooltip: 'Share Access',
            onPressed: _showShareCodeDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload Document', style: TextStyle(fontWeight: FontWeight.w600)),
        onPressed: _showUploadDialog,
      ),
      body: Column(
        children: [
          // Category Selector Pills
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final cat = _categories[i];
                final selected = vaultProv.selectedCategory == cat['id'];
                return InkWell(
                  onTap: () {
                    vaultProv.setCategory(cat['id']!);
                    final user = context.read<AuthProvider>().user;
                    if (user != null) vaultProv.fetchDocuments(user.id);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(cat['icon']!, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Text(
                          cat['label']!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : AppColors.textMain,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Document List
          Expanded(
            child: vaultProv.documents.isEmpty
                ? const EmptyStateWidget(
                    icon: Icons.folder_open_outlined,
                    title: 'No Documents in this Category',
                    description:
                        'Upload diagnostic reports, digital prescriptions, or hospital discharge summaries to view them securely anytime.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
                    itemCount: vaultProv.documents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final doc = vaultProv.documents[i];
                      return _DocumentCard(document: doc);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final HealthDocumentModel document;

  const _DocumentCard({required this.document});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.picture_as_pdf_outlined,
                    color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${document.hospitalLab} • ${document.reportDate}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: document.verification),
            ],
          ),
          if (document.summary != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'AI Summary: ${document.summary!}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMain,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
