import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/glass_container.dart';
import '../widgets/premium_background.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_onFocusChanged);
    _passFocus.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    // Rebuild to reflect focused borders/label color.
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _emailFocus.removeListener(_onFocusChanged);
    _passFocus.removeListener(_onFocusChanged);
    _emailFocus.dispose();
    _passFocus.dispose();
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
    required bool isFocused,
    Widget? suffix,
  }) {
    final Color borderColor =
        isFocused ? AppColors.accent : Colors.white.withValues(alpha: 0.12);
    final Color fillColor = isFocused
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.04);

    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.92)),
      suffixIcon: suffix,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      const Text(
                        'Tekrar Hoş Geldin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Randevularını yönetmek ve işletmeleri keşfetmek için giriş yap.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 26),
                      GlassContainer(
                        padding: const EdgeInsets.all(18),
                        borderRadius: 24,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailCtrl,
                              focusNode: _emailFocus,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: Colors.white),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return 'Lütfen email gir.';
                                final emailReg =
                                    RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                                return emailReg.hasMatch(v.trim())
                                    ? null
                                    : 'Geçerli bir email gir.';
                              },
                              decoration: _fieldDecoration(
                                label: 'E-posta',
                                icon: Icons.email_rounded,
                                isFocused: _emailFocus.hasFocus,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _passCtrl,
                              focusNode: _passFocus,
                              textInputAction: TextInputAction.done,
                              obscureText: _obscure,
                              style: const TextStyle(color: Colors.white),
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Lütfen şifre gir.';
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
                                    _obscure
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
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
                                  onPressed: auth.loading
                                      ? null
                                      : () async {
                                          if (!_formKey.currentState!
                                              .validate()) return;
                                          try {
                                            await ref
                                                .read(authProvider.notifier)
                                                .login(
                                                  _emailCtrl.text.trim(),
                                                  _passCtrl.text.trim(),
                                                );
                                            if (!mounted) return;
                                            context.go('/home');
                                          } catch (e) {
                                            if (!mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Giriş başarısız: $e')),
                                            );
                                          }
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
                                  child: auth.loading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        )
                                      : const Text(
                                          'Giriş Yap',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Hesabın yok mu?',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                TextButton(
                                  onPressed: () => context.go('/register'),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    foregroundColor: AppColors.accentLight,
                                  ),
                                  child: const Text(
                                    'Kayıt Ol',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ],
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
