import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'signup_screen.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _loading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _loading = true);
    try {
      final auth = ref.read(authServiceProvider);
      await auth.signInWithEmail(_email, _password);
      setState(() => _loading = false);
      Navigator.of(context).pushReplacementNamed('/home');
      return;
    } catch (e) {
      // local fallback
      final box = Hive.box('focusflow');
      final stored = box.get('local_user');
      if (stored != null && stored['email'] == _email && stored['password'] == _password) {
        setState(() => _loading = false);
        Navigator.of(context).pushReplacementNamed('/home');
        return;
      }
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text('Welcome back', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Sign in to continue to FocusFlow', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email',
                      onSaved: (v) => _email = v ?? '',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (v) => v != null && v.length >= 6 ? null : 'Password min 6 chars',
                      onSaved: (v) => _password = v ?? '',
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        child: _loading ? const CircularProgressIndicator() : const Text('Sign in'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(onPressed: () {}, child: const Text('Forgot password?')),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(onPressed: () async {
                      try {
                        final auth = ref.read(authServiceProvider);
                        final user = await auth.signInWithGoogle();
                        if (user != null) Navigator.of(context).pushReplacementNamed('/home');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google sign-in failed: ${e.toString()}')));
                      }
                    }, icon: const Icon(Icons.login), label: const Text('Sign in with Google')),
                    const SizedBox(height: 12),
                    TextButton(onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignupScreen()));
                    }, child: const Text('Create a local account')),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
