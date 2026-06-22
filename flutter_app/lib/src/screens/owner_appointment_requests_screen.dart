import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../widgets/glass_container.dart';
import '../widgets/premium_background.dart';

// Bu ekran için backend/endpoint bulunmadığı için şu an demo UI iskeleti.
class OwnerAppointmentRequestsScreen extends ConsumerWidget {
  const OwnerAppointmentRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const PremiumBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      _buildRequestCard(
                        context,
                        status: 'Bekliyor',
                        title: 'Müşteri: Ahmet Yılmaz',
                      ),
                      _buildRequestCard(
                        context,
                        status: 'Onaylandı',
                        title: 'Müşteri: Elif Kaya',
                      ),
                      _buildRequestCard(
                        context,
                        status: 'Reddedildi',
                        title: 'Müşteri: Mehmet Demir',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 20, 10),
      child: Row(
        children: [
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Randevu Talepleri',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(
    BuildContext context, {
    required String status,
    required String title,
  }) {
    final isPending = status == 'Bekliyor';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassContainer(
        padding: const EdgeInsets.all(18),
        borderRadius: 24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _StatusChip(status: status),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'Tarih: 20.06.2026\nSaat: 14:30\nHizmet: Saç Kesim\nUzman: Ece Hanım',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13.5,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isPending) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Onaylandı (demo).')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.open,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Onayla'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reddedildi (demo).')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.redAccent.withOpacity(0.6)),
                          foregroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Reddet'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  Color _chipColor() {
    switch (status.toUpperCase()) {
      case 'ONAYLANDI':
        return AppColors.open;
      case 'REDDedILDI':
      case 'REDDİLDİ':
        return Colors.redAccent;
      default:
        return AppColors.accentLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _chipColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

