import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../widgets/glass_container.dart';
import '../widgets/premium_background.dart';

class OwnerAppointmentRequestsScreen extends ConsumerWidget {
  const OwnerAppointmentRequestsScreen({super.key});

  static final _sampleRequests = [
    {
      'customer': 'Ahmet Yılmaz',
      'date': '22.06.2026',
      'time': '14:30',
      'service': 'Saç Kesim',
      'staff': 'Ece Hanım',
      'status': 'Bekliyor',
    },
    {
      'customer': 'Elif Kaya',
      'date': '20.06.2026',
      'time': '12:00',
      'service': 'Balayaj',
      'staff': 'Mert Bey',
      'status': 'Onaylandı',
    },
    {
      'customer': 'Mehmet Demir',
      'date': '18.06.2026',
      'time': '16:00',
      'service': 'Cilt Bakımı',
      'staff': 'Selin Hanım',
      'status': 'Reddedildi',
    },
  ];

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
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: _sampleRequests.length,
                    itemBuilder: (context, index) {
                      final request = _sampleRequests[index];
                      return _buildRequestCard(
                        context,
                        customer: request['customer']!,
                        date: request['date']!,
                        time: request['time']!,
                        service: request['service']!,
                        staff: request['staff']!,
                        status: request['status']!,
                      );
                    },
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
        children: const [
          SizedBox(width: 6),
          Expanded(
            child: Text(
              'Randevu Talepleri',
              style: TextStyle(
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
    required String customer,
    required String date,
    required String time,
    required String service,
    required String staff,
    required String status,
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
                    'Müşteri: $customer',
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
            Text(
              'Tarih: $date\nSaat: $time\nHizmet: $service\nUzman: $staff',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13.5,
                height: 1.55,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isPending) ...[
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Randevu onaylandı.')),
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
                            const SnackBar(
                                content: Text('Randevu reddedildi.')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: Colors.redAccent.withValues(alpha: 0.6)),
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
    switch (status.toLowerCase()) {
      case 'onaylandı':
        return AppColors.open;
      case 'reddedildi':
        return Colors.redAccent;
      default:
        return AppColors.accentLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _chipColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.35)),
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
