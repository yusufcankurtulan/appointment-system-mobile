import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/glass_container.dart';
import '../widgets/premium_background.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _firstName = TextEditingController(text: user?.firstName ?? '');
    _lastName = TextEditingController(text: '');
    _email = TextEditingController(text: user?.email ?? '');
    _phone = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
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
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.92)),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: _buildBorder(Colors.white.withValues(alpha: 0.14)),
      enabledBorder: _buildBorder(Colors.white.withValues(alpha: 0.14)),
      focusedBorder: _buildBorder(AppColors.accentLight),
      labelStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.65),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const PremiumBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: GlassContainer(
                  padding: const EdgeInsets.all(22),
                  borderRadius: 28,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 34,
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.person_rounded,
                                color: Colors.white, size: 32),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.firstName != null &&
                                          user!.firstName!.isNotEmpty
                                      ? '${user.firstName} ${_lastName.text}'
                                          .trim()
                                      : 'Profil Bilgilerin',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  user?.role == 'OWNER'
                                      ? 'İşletme Sahibi'
                                      : 'Müşteri',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.65),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _firstName,
                              style: const TextStyle(color: Colors.white),
                              decoration: _fieldDecoration(
                                label: 'Ad',
                                icon: Icons.person_rounded,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _lastName,
                              style: const TextStyle(color: Colors.white),
                              decoration: _fieldDecoration(
                                label: 'Soyad',
                                icon: Icons.person_outline_rounded,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _email,
                              enabled: false,
                              style: const TextStyle(color: Colors.white70),
                              decoration: _fieldDecoration(
                                label: 'E-posta',
                                icon: Icons.email_rounded,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _phone,
                              style: const TextStyle(color: Colors.white),
                              decoration: _fieldDecoration(
                                label: 'Telefon',
                                icon: Icons.phone_rounded,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF3B82F6),
                                      Color(0xFF8B5CF6)
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
                                  onPressed: () {
                                    if (!_formKey.currentState!.validate())
                                      return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Profil kaydedildi.')),
                                    );
                                  },
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
                                    'Kaydet',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  await ref
                                      .read(authProvider.notifier)
                                      .logout();
                                  if (mounted) context.go('/login');
                                },
                                icon: const Icon(Icons.logout_rounded),
                                label: const Text('Çıkış Yap'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                      color:
                                          Colors.white.withValues(alpha: 0.18)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
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
          ),
        ],
      ),
    );
  }
}
