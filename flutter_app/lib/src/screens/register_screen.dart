import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _first,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'First name', prefixIcon: Icon(Icons.person)),
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter first name' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _last,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Last name', prefixIcon: Icon(Icons.person_outline)),
                  validator: (v) => (v == null || v.isEmpty) ? 'Enter last name' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _email,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter email';
                    final emailReg = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
                    return emailReg.hasMatch(v) ? null : 'Invalid email';
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phone,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone)),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pass,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 chars' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  onPressed: auth.loading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          try {
                            await ref.read(authProvider.notifier).register(_first.text.trim(), _last.text.trim(), _email.text.trim(), _phone.text.trim(), _pass.text.trim());
                            if (mounted) {
                              // navigate to home
                              context.go('/home');
                            }
                          } catch (e) {
                            if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Register failed: $e')));
                          }
                        },
                  child: auth.loading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Create account'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Already have an account? Log in'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
