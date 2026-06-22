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
      prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.92)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.04),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: _buildBorder(Colors.white.withOpacity(0.12)),
      enabledBorder: _buildBorder(Colors.white.withOpacity(0.12)),
      focusedBorder: _buildBorder(AppColors.accentLight),
      labelStyle: TextStyle(
        color: Colors.white.withOpacity(0.65),
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassContainer(
                  padding: const EdgeInsets.all(22),
                  borderRadius: 28,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.person_rounded, color: Colors.white, size: 30),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              user?.firstName != null && user!.firstName!.isNotEmpty
                                  ? '${user.firstName} (Profil)'
                                  : 'Profil',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
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
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppColors.accent, Color(0xFF8B5CF6)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accent.withOpacity(0.28),
                                      blurRadius: 18,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (!_formKey.currentState!.validate()) return;
                                    // Backend profil güncellemesi bu adımda bulunmadığı için UI tarafında placeholder.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Profil kaydedildi (demo).')),
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
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  await ref.read(authProvider.notifier).logout();
                                  if (mounted) {
                                    // GoRouter redirect ile /login'a düşer.
                                  context.go('/login');



                                  }
                                },
                                icon: const Icon(Icons.logout_rounded),
                                label: const Text('Çıkış Yap'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(color: Colors.white.withOpacity(0.18)),
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

