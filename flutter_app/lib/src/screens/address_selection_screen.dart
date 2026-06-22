import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../models/istanbul_address.dart';
import '../widgets/glass_container.dart';
import '../widgets/premium_background.dart';

class AddressSelectionScreen extends ConsumerStatefulWidget {
  final Function(AddressSelection address) onAddressSelected;

  const AddressSelectionScreen({
    super.key,
    required this.onAddressSelected,
  });

  @override
  ConsumerState<AddressSelectionScreen> createState() =>
      _AddressSelectionScreenState();
}

class _AddressSelectionScreenState
    extends ConsumerState<AddressSelectionScreen> {
  String? _selectedDistrict;
  String? _selectedNeighborhood;
  String? _selectedStreet;
  String? _buildingNumber;

  late List<IstanbulDistrict> _districts;
  late List<IstanbulNeighborhood> _neighborhoods = [];
  late List<String> _streets = [];

  @override
  void initState() {
    super.initState();
    _districts = istanbulData;
  }

  void _onDistrictChanged(String? district) {
    setState(() {
      _selectedDistrict = district;
      _selectedNeighborhood = null;
      _selectedStreet = null;
      _streets = [];

      if (district != null) {
        final selectedDist =
            _districts.firstWhere((d) => d.name == district, orElse: () {
          throw Exception('District not found');
        });
        _neighborhoods = selectedDist.neighborhoods;
      } else {
        _neighborhoods = [];
      }
    });
  }

  void _onNeighborhoodChanged(String? neighborhood) {
    setState(() {
      _selectedNeighborhood = neighborhood;
      _selectedStreet = null;

      if (neighborhood != null && _neighborhoods.isNotEmpty) {
        final selectedNeigh = _neighborhoods
            .firstWhere((n) => n.name == neighborhood, orElse: () {
          throw Exception('Neighborhood not found');
        });
        _streets = selectedNeigh.streets;
      } else {
        _streets = [];
      }
    });
  }

  void _onStreetChanged(String? street) {
    setState(() {
      _selectedStreet = street;
    });
  }

  void _submitAddress() {
    if (_selectedDistrict == null ||
        _selectedNeighborhood == null ||
        _selectedStreet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm adres bilgilerini seçin')),
      );
      return;
    }

    final address = AddressSelection(
      city: 'İstanbul',
      district: _selectedDistrict!,
      neighborhood: _selectedNeighborhood!,
      street: _selectedStreet!,
      buildingNumber:
          _buildingNumber?.isNotEmpty ?? false ? _buildingNumber : null,
    );

    widget.onAddressSelected(address);
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: color, width: 1.2),
    );
  }

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
    required bool isFocused,
  }) {
    final Color borderColor =
        isFocused ? AppColors.accent : Colors.white.withValues(alpha: 0.12);
    final Color fillColor = isFocused
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.04);

    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.92)),
      filled: true,
      fillColor: fillColor,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: _buildBorder(borderColor),
      enabledBorder: _buildBorder(borderColor),
      focusedBorder: _buildBorder(AppColors.accentLight),
      labelStyle: TextStyle(
        color: isFocused
            ? AppColors.accentLight
            : Colors.white.withValues(alpha: 0.65),
        fontWeight: FontWeight.w600,
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
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'İşletme Adresini Seç',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'İstanbul\'da bulunan işletmenizin konumunu seçin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GlassContainer(
                      padding: const EdgeInsets.all(18),
                      borderRadius: 24,
                      child: Column(
                        children: [
                          // District Dropdown
                          DropdownButtonFormField<String>(
                            initialValue: _selectedDistrict,
                            items: _districts
                                .map((d) => DropdownMenuItem(
                                      value: d.name,
                                      child: Text(
                                        d.name,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ))
                                .toList(),
                            onChanged: _onDistrictChanged,
                            style: const TextStyle(color: Colors.white),
                            dropdownColor: AppColors.background,
                            decoration: _fieldDecoration(
                              label: 'İlçe',
                              icon: Icons.location_city_rounded,
                              isFocused: false,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Neighborhood Dropdown
                          DropdownButtonFormField<String>(
                            initialValue: _selectedNeighborhood,
                            items: _neighborhoods
                                .map((n) => DropdownMenuItem(
                                      value: n.name,
                                      child: Text(
                                        n.name,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ))
                                .toList(),
                            onChanged: _selectedDistrict != null
                                ? _onNeighborhoodChanged
                                : null,
                            style: const TextStyle(color: Colors.white),
                            dropdownColor: AppColors.background,
                            decoration: _fieldDecoration(
                              label: 'Mahalle',
                              icon: Icons.domain_rounded,
                              isFocused: false,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Street Dropdown
                          DropdownButtonFormField<String>(
                            initialValue: _selectedStreet,
                            items: _streets
                                .map((s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(
                                        s,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ))
                                .toList(),
                            onChanged: _selectedNeighborhood != null
                                ? _onStreetChanged
                                : null,
                            style: const TextStyle(color: Colors.white),
                            dropdownColor: AppColors.background,
                            decoration: _fieldDecoration(
                              label: 'Sokak/Cadde',
                              icon: Icons.map_rounded,
                              isFocused: false,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Building Number Field
                          TextFormField(
                            onChanged: (value) =>
                                setState(() => _buildingNumber = value),
                            style: const TextStyle(color: Colors.white),
                            decoration: _fieldDecoration(
                              label: 'Bina No (İsteğe bağlı)',
                              icon: Icons.home_rounded,
                              isFocused: false,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Address Preview
                          if (_selectedStreet != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white.withValues(alpha: 0.08),
                                  border: Border.all(
                                    color: AppColors.accentLight
                                        .withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Adresiniz:',
                                      style: TextStyle(
                                        color: Colors.white
                                            .withValues(alpha: 0.65),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      AddressSelection(
                                        city: 'İstanbul',
                                        district: _selectedDistrict!,
                                        neighborhood: _selectedNeighborhood!,
                                        street: _selectedStreet!,
                                        buildingNumber: _buildingNumber,
                                      ).fullAddress,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 18),
                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF3B82F6),
                                    Color(0xFF8B5CF6),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accent
                                        .withValues(alpha: 0.28),
                                    blurRadius: 18,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _submitAddress,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  elevation: 0,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: const Text(
                                  'Adresi Seç',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
