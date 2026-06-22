import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../widgets/glass_container.dart';
import '../widgets/premium_background.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _pass = TextEditingController();

  // OWNER fields
  final _shopName = TextEditingController();
  final _shopDesc = TextEditingController();
  final _city = TextEditingController();
  final _district = TextEditingController();
  final _address = TextEditingController();
  final _ownerPhone = TextEditingController();

  final FocusNode _firstFocus = FocusNode();
  final FocusNode _lastFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  final FocusNode _shopNameFocus = FocusNode();
  final FocusNode _shopDescFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _districtFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _ownerPhoneFocus = FocusNode();

  bool _obscure = true;
  String _role = 'CUSTOMER';
  bool get _isOwner => _role == 'OWNER';


  @override
  void initState() {
    super.initState();
    for (final f in [
      _firstFocus,
      _lastFocus,
      _emailFocus,
      _phoneFocus,
      _passFocus,
    ]) {
      f.addListener(_onFocusChanged);
    }
  }

  void _onFocusChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final c in [_first, _last, _email, _phone, _pass]) {
      c.dispose();
    }
    for (final f in [
      _firstFocus,
      _lastFocus,
      _emailFocus,
      _phoneFocus,
      _passFocus
    ]) {
      f.removeListener(_onFocusChanged);
      f.dispose();
    }
    super.dispose();
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: color, width: 1.2),
    );
  }

  void _selectRole(String role) {
    setState(() => _role = role);
  }

  Widget _roleCard({
    required String role,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final bool active = _role == role;

    final Color borderColor = active ? AppColors.accentLight : Colors.white.withOpacity(0.14);
    final Color shadowColor = active ? AppColors.accent.withOpacity(0.42) : Colors.black.withOpacity(0.08);

    return InkWell(
      onTap: () => _selectRole(role),
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: active
              ? const LinearGradient(
                  colors: [
                    Color(0xFF3B82F6),
                    Color(0xFF8B5CF6),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          border: Border.all(color: borderColor, width: 1.1),
          color: active ? null : Colors.white.withOpacity(0.05),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: active ? 26 : 14,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: active ? Colors.white.withOpacity(0.14) : Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 22,
                color: Colors.white.withOpacity(active ? 0.98 : 0.86),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.68),
                      fontSize: 12.5,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            if (active)
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.accentLight,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Widget _customerBaseFields() {
    return Column(
      children: [
        TextFormField(
          controller: _first,
          focusNode: _firstFocus,
          textInputAction: TextInputAction.next,
          style: const TextStyle(color: Colors.white),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Lütfen adını gir.' : null,
          decoration: _fieldDecoration(
            label: 'Ad',
            icon: Icons.person_rounded,
            isFocused: _firstFocus.hasFocus,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _last,
          focusNode: _lastFocus,
          textInputAction: TextInputAction.next,
          style: const TextStyle(color: Colors.white),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Lütfen soyadını gir.' : null,
          decoration: _fieldDecoration(
            label: 'Soyad',
            icon: Icons.person_outline_rounded,
            isFocused: _lastFocus.hasFocus,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _email,
          focusNode: _emailFocus,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'Lütfen e-posta gir.';
            }
            final emailReg = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
            return emailReg.hasMatch(v.trim()) ? null : 'Geçerli bir e-posta gir.';
          },
          decoration: _fieldDecoration(
            label: 'E-posta',
            icon: Icons.email_rounded,
            isFocused: _emailFocus.hasFocus,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _phone,
          focusNode: _phoneFocus,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Colors.white),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Lütfen telefon numaranı gir.' : null,
          decoration: _fieldDecoration(
            label: 'Telefon',
            icon: Icons.phone_rounded,
            isFocused: _phoneFocus.hasFocus,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _pass,
          focusNode: _passFocus,
          textInputAction: TextInputAction.done,
          obscureText: _obscure,
          style: const TextStyle(color: Colors.white),
          validator: (v) {
            if (v == null || v.length < 6) {
              return 'Şifre en az 6 karakter olmalı.';
            }
            return null;
          },
          decoration: _fieldDecoration(
            label: 'Şifre',
            icon: Icons.lock_rounded,
            isFocused: _passFocus.hasFocus,
            suffix: IconButton(
              onPressed: () {
                setState(() => _obscure = !_obscure);
              },
              icon: Icon(
                _obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                color: Colors.white.withOpacity(0.85),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _ownerFields() {
    return Column(
      children: [
        const SizedBox(height: 4),
        TextFormField(
          controller: _shopName,
          focusNode: _shopNameFocus,
          textInputAction: TextInputAction.next,
          style: const TextStyle(color: Colors.white),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Lütfen işletme adını gir.' : null,
          decoration: _fieldDecoration(
            label: 'İşletme Adı',
            icon: Icons.storefront_rounded,
            isFocused: _shopNameFocus.hasFocus,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _shopDesc,
          focusNode: _shopDescFocus,
          textInputAction: TextInputAction.next,
          style: const TextStyle(color: Colors.white),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Lütfen işletme açıklaması gir.' : null,
          decoration: _fieldDecoration(
            label: 'İşletme Açıklaması',
            icon: Icons.description_rounded,
            isFocused: _shopDescFocus.hasFocus,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _city,
          focusNode: _cityFocus,
          textInputAction: TextInputAction.next,
          style: const TextStyle(color: Colors.white),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Lütfen şehir gir.' : null,
          decoration: _fieldDecoration(
            label: 'Şehir',
            icon: Icons.location_city_rounded,
            isFocused: _cityFocus.hasFocus,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _district,
          focusNode: _districtFocus,
          textInputAction: TextInputAction.next,
          style: const TextStyle(color: Colors.white),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Lütfen ilçe gir.' : null,
          decoration: _fieldDecoration(
            label: 'İlçe',
            icon: Icons.location_on_rounded,
            isFocused: _districtFocus.hasFocus,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _address,
          focusNode: _addressFocus,
          textInputAction: TextInputAction.next,
          style: const TextStyle(color: Colors.white),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Lütfen adres gir.' : null,
          decoration: _fieldDecoration(
            label: 'Adres',
            icon: Icons.map_rounded,
            isFocused: _addressFocus.hasFocus,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _ownerPhone,
          focusNode: _ownerPhoneFocus,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Colors.white),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Lütfen işletme telefonu gir.' : null,
          decoration: _fieldDecoration(
            label: 'İşletme Telefonu',
            icon: Icons.phone_in_talk_rounded,
            isFocused: _ownerPhoneFocus.hasFocus,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  InputDecoration _fieldDecoration({

    required String label,
    required IconData icon,
    required bool isFocused,
    Widget? suffix,
  }) {
    final Color borderColor = isFocused ? AppColors.accent : Colors.white.withOpacity(0.12);
    final Color fillColor = isFocused ? Colors.white.withOpacity(0.06) : Colors.white.withOpacity(0.04);

    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.92)),
      suffixIcon: suffix,
      filled: true,
      fillColor: fillColor,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: _buildBorder(borderColor),
      enabledBorder: _buildBorder(borderColor),
      focusedBorder: _buildBorder(AppColors.accentLight),
      labelStyle: TextStyle(
        color: isFocused ? AppColors.accentLight : Colors.white.withOpacity(0.65),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _onNext() {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final extra = <String, String?>{
      'role': _role,
      'firstName': _first.text.trim(),
      'lastName': _last.text.trim(),
      'email': _email.text.trim(),
      'phone': _phone.text.trim(),
      'password': _pass.text.trim(),
    };

    if (_role == 'OWNER') {
      extra.addAll({
        'shopName': _shopName.text.trim(),
        'shopDescription': _shopDesc.text.trim(),
        'city': _city.text.trim(),
        'district': _district.text.trim(),
        'address': _address.text.trim(),
        'shopPhone': _ownerPhone.text.trim(),
      });
    }

    context.go('/location-permission', extra: extra);
  }


  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

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
                      'Hesabını Oluştur',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Yakınındaki işletmeleri keşfet ve kolayca randevu oluştur.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 26),
                    GlassContainer(
                      padding: const EdgeInsets.all(18),
                      borderRadius: 28,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // STEP 1: Hesap Türü Seçimi
                            Column(
                              children: [
                                const SizedBox(height: 2),
                                Text(
                                  'Hesabınızı nasıl kullanmak istiyorsunuz?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.92),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Lütfen size en uygun hesap türünü seçin.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                _roleCard(
                                  role: 'CUSTOMER',
                                  icon: Icons.person_rounded,
                                  title: 'Randevu Almak İstiyorum',
                                  description: 'Yakındaki işletmeleri keşfedin ve kolayca randevu oluşturun.',
                                ),
                                const SizedBox(height: 12),
                                _roleCard(
                                  role: 'OWNER',
                                  icon: Icons.storefront_rounded,
                                  title: 'İşletmemi Yönetmek İstiyorum',
                                  description: 'Randevuları yönetin ve müşterilerinizle iletişimde kalın.',
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            // STEP 2: Form
                            _customerBaseFields(),
                            if (_isOwner) const SizedBox(height: 10),
                            if (_isOwner) _ownerFields(),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text(
                        'Zaten hesabın var mı? Giriş yap',
                        style: TextStyle(color: AppColors.accentLight),
                      ),
                    ),
                    const SizedBox(height: 86),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 18),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: auth.loading ? null : _onNext,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.accent,
                  Color(0xFF8B5CF6),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: auth.loading
                ? const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : const Center(
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

