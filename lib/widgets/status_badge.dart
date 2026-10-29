import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final String? customLabel;

  const StatusBadge({
    super.key,
    required this.status,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    final normalized = status.toLowerCase().replaceAll(' ', '_');

    switch (normalized) {
      case 'confirmed':
      case 'active':
      case 'verified':
      case 'completed':
      case 'settled':
      case 'approved':
      case 'available':
        bg = AppColors.successLight;
        fg = AppColors.success;
        break;
      case 'pending':
      case 'waiting':
      case 'under_review':
      case 'in_progress':
      case 'busy':
        bg = AppColors.warningLight;
        fg = const Color(0xFFB45309);
        break;
      case 'emergency':
      case 'cancelled':
      case 'rejected':
      case 'offline':
        bg = AppColors.emergencyLight;
        fg = AppColors.emergency;
        break;
      case 'urgent':
        bg = const Color(0xFFFFEDD5);
        fg = const Color(0xFFC2410C);
        break;
      case 'routine':
      default:
        bg = AppColors.infoLight;
        fg = AppColors.info;
        break;
    }

    final label = customLabel ?? (status.isEmpty ? 'Unknown' : status[0].toUpperCase() + status.substring(1));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
