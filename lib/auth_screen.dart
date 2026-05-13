import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
    if (_isLogin) {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
  );
} else {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
  );
}
if (mounted) {
  final user = FirebaseAuth.instance.currentUser;
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => OnboardingScreen(userId: user?.uid ?? '')),
  );
}
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _getFriendlyError(e.code);
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getFriendlyError(String code) {
    switch (code) {
      case 'user-not-found': return 'No account found with this email.';
      case 'wrong-password': return 'Incorrect password. Please try again.';
      case 'email-already-in-use': return 'An account already exists with this email.';
      case 'weak-password': return 'Password should be at least 6 characters.';
      case 'invalid-email': return 'Please enter a valid email address.';
      default: return 'Something went wrong. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.favorite, size: 64, color: Color(0xFF2196F3)),
              const SizedBox(height: 16),
              const Text('NutriMom',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
              const SizedBox(height: 8),
              Text(_isLogin ? 'Welcome back!' : 'Create your account',
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 40),
              // Name field (signup only)
              if (!_isLogin) ...[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Your name',
                    prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF2196F3)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Email field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email address',
                  prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF2196F3)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Password field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2196F3)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Error message
              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(_errorMessage!,
                      style: TextStyle(color: Colors.red.shade700, fontSize: 13)),
                ),
              const SizedBox(height: 24),
              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_isLogin ? 'Log In' : 'Create Account',
                          style: const TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 16),
              // Toggle login/signup
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                    _errorMessage = null;
                  });
                },
                child: Text(
                  _isLogin
                      ? "Don't have an account? Sign up"
                      : 'Already have an account? Log in',
                  style: const TextStyle(color: Color(0xFF2196F3)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}