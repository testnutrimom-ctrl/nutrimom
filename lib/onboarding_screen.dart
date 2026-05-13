import 'package:flutter/material.dart';
import 'package:nutrimom/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String? _userMode;
  String? _trimester;
  String? _babyAge;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentPage++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: List.generate(4, (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 4,
                    decoration: BoxDecoration(
                      color: index <= _currentPage
                          ? const Color(0xFF2196F3)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildNamePage(),
                  _buildModePage(),
                  _buildStagePage(),
                  _buildWeightPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNamePage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hi there! 👋', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
          const SizedBox(height: 12),
          const Text('What should we call you?', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 40),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Your first name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
              ),
            ),
          ),
          const SizedBox(height: 32),
          _buildNextButton(() {
            if (_nameController.text.isNotEmpty) _nextPage();
          }),
        ],
      ),
    );
  }

  Widget _buildModePage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your journey 💙', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
          const SizedBox(height: 12),
          const Text('Which best describes you right now?', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 40),
          _buildOptionCard('🤰', 'Pregnant', 'pregnant'),
          const SizedBox(height: 16),
          _buildOptionCard('🤱', 'Breastfeeding', 'breastfeeding'),
          const SizedBox(height: 32),
          _buildNextButton(() {
            if (_userMode != null) _nextPage();
          }),
        ],
      ),
    );
  }

  Widget _buildStagePage() {
    final isPregnant = _userMode == 'pregnant';
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(isPregnant ? 'Your trimester 🌱' : 'Baby\'s age 👶',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
          const SizedBox(height: 12),
          Text(isPregnant ? 'Which trimester are you in?' : 'How old is your baby?',
              style: const TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 40),
          if (isPregnant) ...[
            _buildOptionCard('🌿', 'First Trimester (Weeks 1–12)', '1'),
            const SizedBox(height: 12),
            _buildOptionCard('🌸', 'Second Trimester (Weeks 13–26)', '2'),
            const SizedBox(height: 12),
            _buildOptionCard('🌺', 'Third Trimester (Weeks 27–40)', '3'),
          ] else ...[
            _buildOptionCard('🍼', 'Under 6 months', 'under6'),
            const SizedBox(height: 12),
            _buildOptionCard('🧸', '6 months or older', 'over6'),
          ],
          const SizedBox(height: 32),
          _buildNextButton(() {
            if (isPregnant && _trimester != null) _nextPage();
            if (!isPregnant && _babyAge != null) _nextPage();
          }),
        ],
      ),
    );
  }

  Widget _buildWeightPage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Almost done! ⚖️', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
          const SizedBox(height: 12),
          const Text('What is your current weight?', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 40),
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Weight in kg',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
              ),
              suffixText: 'kg',
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
             onPressed: () async {
  if (_weightController.text.isNotEmpty) {
    final user = FirebaseAuth.instance.currentUser;
    print('Current user: $user');
    if (user != null) {
      try {
        print('Saving to Firestore...');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'name': _nameController.text,
          'mode': _userMode ?? 'pregnant',
          'stage': _trimester ?? _babyAge ?? '1',
          'weight': double.tryParse(_weightController.text) ?? 0,
          'createdAt': DateTime.now().toIso8601String(),
        });
        print('Saved successfully!');
      } catch (e) {
        print('Firestore error: $e');
      }
    } else {
      print('No user logged in!');
    }
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            name: _nameController.text,
            mode: _userMode ?? 'pregnant',
            stage: _trimester ?? _babyAge ?? '1',
            weight: double.tryParse(_weightController.text) ?? 0,
          ),
        ),
      );
    }
  }
},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Start Tracking!', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(String emoji, String label, String value) {
    final isSelected = _userMode == value || _trimester == value || _babyAge == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (value == 'pregnant' || value == 'breastfeeding') {
            _userMode = value;
          } else if (value == '1' || value == '2' || value == '3') {
            _trimester = value;
          } else {
            _babyAge = value;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF2196F3) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Text(label, style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF2196F3) : Colors.black87,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Continue', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}