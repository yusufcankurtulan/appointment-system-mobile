import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/api_exception.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../models/appointment.dart';
import '../models/chair.dart';
import '../models/shop.dart';
import '../providers/appointments_provider.dart';
import '../providers/shops_provider.dart';
import '../utils/booking_utils.dart';
import '../widgets/glass_container.dart';
import '../widgets/premium_background.dart';
import '../widgets/shop/bottom_booking_bar.dart';
import '../widgets/shop/date_selector.dart';
import '../widgets/shop/expert_selector.dart';
import '../widgets/shop/quick_info_chips.dart';
import '../widgets/shop/shop_hero_gallery.dart';
import '../widgets/shop/time_slot_selector.dart';

class ShopDetailScreen extends ConsumerStatefulWidget {
  final ShopModel shop;

  const ShopDetailScreen({super.key, required this.shop});

  @override
  ConsumerState<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends ConsumerState<ShopDetailScreen> {
  late Future<_ShopDetailData> _detailFuture;

  ChairModel? _selectedExpert;
  DateTime? _selectedDate;
  String? _selectedTime;
  bool _isSubmitting = false;

  final List<DateTime> _availableDates = buildNextSevenDays();

  @override
  void initState() {
    super.initState();
    _detailFuture = _loadDetail();
  }

  Future<_ShopDetailData> _loadDetail() async {
    final repo = ref.read(shopsRepositoryProvider);

    final results = await Future.wait([
      repo.getById(widget.shop.id),
      repo.getChairs(widget.shop.id),
    ]);

    final shop = results[0] as ShopModel;
    final chairsJson = results[1] as List<Map<String, dynamic>>;

    final fetchedExperts = chairsJson
        .map(ChairModel.fromJson)
        .toList(growable: false);

    final experts = fetchedExperts.isNotEmpty ? fetchedExperts : shop.chairs;

    return _ShopDetailData(
      shop: shop.copyWith(
        distanceKm: widget.shop.distanceKm ?? shop.distanceKm,
        chairs: experts,
      ),
      experts: experts,
    );
  }

  void _reloadDetail() {
    setState(() {
      _detailFuture = _loadDetail();
    });
  }

  Future<void> _submitBooking(ShopModel shop) async {
    if (_selectedExpert == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      _showSnackBar('Lütfen uzman, tarih ve saat seçiniz.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final startAt = parseSlotDateTime(_selectedDate!, _selectedTime!);
      final endAt = slotEndAt(startAt);
      final repo = ref.read(appointmentsRepositoryProvider);

      await repo.requestAppointment(
        CreateAppointmentRequest(
          chairId: _selectedExpert!.id,
          shopId: shop.id,
          startAt: startAt,
          endAt: endAt,
        ),
      );

      ref.invalidate(myAppointmentsProvider);

      if (!mounted) return;
      _showSnackBar(
        'Randevu talebiniz gönderildi. İşletme onayı bekleniyor.',
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      _showSnackBar(_mapBookingError(error));
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Randevu gönderilemedi. Lütfen tekrar deneyin.');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _mapBookingError(ApiException error) {
    if (error.statusCode == 409) {
      return 'Seçtiğiniz saat dolu. Lütfen başka bir saat seçin.';
    }
    if (error.statusCode == 401) {
      return 'Oturumunuz sona erdi. Lütfen tekrar giriş yapın.';
    }
    return error.message;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.imagePlaceholder,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const PremiumBackground(),
          FutureBuilder<_ShopDetailData>(
            future: _detailFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingState();
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return _buildErrorState();
              }

              final data = snapshot.data!;
              return _buildContent(data);
            },
          ),
        ],
      ),
      bottomNavigationBar: FutureBuilder<_ShopDetailData>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }

          return BottomBookingBar(
            isLoading: _isSubmitting,
            onSubmit: () => _submitBooking(snapshot.data!.shop),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ShopHeroGallery(
            shop: widget.shop,
            onBack: context.pop,
            onFavorite: () {},
          ),
        ),
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ShopHeroGallery(
            shop: widget.shop,
            onBack: context.pop,
            onFavorite: () {},
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
            child: _ErrorCard(onRetry: _reloadDetail),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(_ShopDetailData data) {
    final shop = data.shop;
    final locationText = [shop.district, shop.city]
        .where((part) => part != null && part.trim().isNotEmpty)
        .join(', ');

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ShopHeroGallery(
            shop: shop,
            onBack: context.pop,
            onFavorite: () {},
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            0,
            AppSpacing.screenHorizontal,
            AppSpacing.sectionGap,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildShopHeader(shop, locationText),
              const SizedBox(height: AppSpacing.sectionGap),
              QuickInfoChips(expertCount: data.experts.length),
              const SizedBox(height: AppSpacing.sectionGap),
              const _SectionTitle(title: 'Uzmanlar'),
              const SizedBox(height: AppSpacing.itemGap),
              ExpertSelector(
                experts: data.experts,
                selectedExpertId: _selectedExpert?.id,
                onExpertSelected: (expert) {
                  setState(() => _selectedExpert = expert);
                },
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              const _SectionTitle(title: 'Tarih Seçin'),
              const SizedBox(height: AppSpacing.itemGap),
              DateSelector(
                dates: _availableDates,
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() => _selectedDate = date);
                },
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              const _SectionTitle(title: 'Saat Seçin'),
              const SizedBox(height: AppSpacing.itemGap),
              TimeSlotSelector(
                selectedSlot: _selectedTime,
                onSlotSelected: (slot) {
                  setState(() => _selectedTime = slot);
                },
              ),
              const SizedBox(height: 100),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildShopHeader(ShopModel shop, String locationText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          shop.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (locationText.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.white70,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  locationText,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 18),
            const SizedBox(width: 4),
            Text(
              '4.8',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '  (128 değerlendirme)',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          shop.description?.trim().isNotEmpty == true
              ? shop.description!.trim()
              : 'Randevu oluşturmak için işletme detaylarını inceleyin.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorCard({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.storefront_outlined, size: 56, color: Colors.white70),
          const SizedBox(height: 18),
          const Text(
            'İşletme yüklenemedi',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'İşletme bilgileri alınırken bir hata oluştu. Lütfen tekrar deneyin.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 22),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }
}

class _ShopDetailData {
  final ShopModel shop;
  final List<ChairModel> experts;

  const _ShopDetailData({
    required this.shop,
    required this.experts,
  });
}

extension on ShopModel {
  ShopModel copyWith({
    String? id,
    String? name,
    String? description,
    String? city,
    String? district,
    String? address,
    double? distanceKm,
    List<ShopImageModel>? images,
    List<ChairModel>? chairs,
  }) {
    return ShopModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      city: city ?? this.city,
      district: district ?? this.district,
      address: address ?? this.address,
      distanceKm: distanceKm ?? this.distanceKm,
      images: images ?? this.images,
      chairs: chairs ?? this.chairs,
    );
  }
}
