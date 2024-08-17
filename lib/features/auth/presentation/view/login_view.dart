import 'package:finalproject/features/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4EB),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/logo.png', // Replace with your logo asset
                    height: 150,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Upgrade your score',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Brand Regular',
                      color: Color(0xFF8E7F55),
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    key: const ValueKey('username'),
                    controller: _usernameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.mail, color: Color(0xFF8E7F55)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      labelText: 'Username',
                      labelStyle: const TextStyle(color: Color(0xFF8E7F55)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const ValueKey('password'),
                    controller: _passwordController,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock, color: Color(0xFF8E7F55)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscure ? Icons.visibility : Icons.visibility_off,
                          color: const Color(0xFF8E7F55),
                        ),
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Color(0xFF8E7F55)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Handle forgot password
                      },
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(color: Color(0xFF0B84FF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8E7F55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () async {
                      await ref.read(authViewModelProvider.notifier).loginStudent(
                            _usernameController.text,
                            _passwordController.text,
                          );
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(fontSize: 18, fontFamily: 'Brand Bold'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Color(0xFF8E7F55)),
                        ),
                        TextButton(
                          key: const ValueKey('registerButton'),
                          onPressed: () {
                            ref.read(authViewModelProvider.notifier).openRegisterView();
                          },
                          child: const Text(
                            'Signup here.',
                            style: TextStyle(color: Color(0xFF0B84FF)),
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
    );
  }
}
