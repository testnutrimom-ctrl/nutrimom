import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'food_search_screen.dart';
import 'foods_to_avoid_screen.dart';
import 'auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Test Firestore write
  try {
    await FirebaseFirestore.instance
        .collection('test')
        .doc('test')
        .set({'hello': 'world'});
    print('TEST WRITE SUCCESS');
  } catch (e) {
    print('TEST WRITE FAILED: $e');
  }
  runApp(const NutriMomApp());
}

class NutriMomApp extends StatelessWidget {
  const NutriMomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriMom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const AuthWrapper(),
    );
  }
}
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF2196F3)),
            ),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(color: Color(0xFF2196F3)),
                  ),
                );
              }
              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                return HomeScreen(
                  name: userData['name'] ?? '',
                  mode: userData['mode'] ?? 'pregnant',
                  stage: userData['stage'] ?? '1',
                  weight: (userData['weight'] as num?)?.toDouble() ?? 0,
                );
              }
              return OnboardingScreen(userId: snapshot.data!.uid);
            },
          );
        }
        return const WelcomeScreen();
      },
    );
  }
}
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, size: 80, color: Color(0xFF2196F3)),
              const SizedBox(height: 24),
              const Text('NutriMom',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
              const SizedBox(height: 12),
              const Text('Your pregnancy & breastfeeding\nnutrition companion',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                 onPressed: () {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => const AuthScreen()));
},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Get Started', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const AuthScreen()));
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2196F3),
                    side: const BorderSide(color: Color(0xFF2196F3)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('I already have an account', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  final String userId;
  const OnboardingScreen({super.key, required this.userId});

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
    if (user != null) {
      try {
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

class HomeScreen extends StatefulWidget {
  final String name;
  final String mode;
  final String stage;
  final double weight;

  const HomeScreen({
    super.key,
    required this.name,
    required this.mode,
    required this.stage,
    required this.weight,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
List<Map<String, dynamic>> _loggedFoods = [];
int _waterGlasses = 0;
final List<Map<String, dynamic>> _weightLog = [];

  int get _calorieGoal {
    if (widget.mode == 'breastfeeding') return 2500;
    if (widget.stage == '1') return 1800;
    if (widget.stage == '2') return 2100;
    return 2400;
  }

  int get _caloriesConsumed {
  return _loggedFoods.fold(0, (sum, food) => sum + (food['calories'] as int));
}

@override
void initState() {
  super.initState();
  _loadFoods();
}

Future<void> _loadFoods() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final today = DateTime.now();
    final dateStr = '${today.year}-${today.month}-${today.day}';
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('foodLogs')
        .doc(dateStr)
        .collection('meals')
        .get();
    setState(() {
      _loggedFoods = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}

Future<void> _saveFood(Map<String, dynamic> food) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final today = DateTime.now();
    final dateStr = '${today.year}-${today.month}-${today.day}';
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('foodLogs')
        .doc(dateStr)
        .collection('meals')
        .add(food);
  }
}
void _showWaterDialog() {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Water Intake 💧',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
                const SizedBox(height: 8),
                const Text('Staying hydrated is essential during pregnancy & breastfeeding',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 24),
                // Glasses display
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(8, (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.water_drop,
                      size: 32,
                      color: index < _waterGlasses
                          ? const Color(0xFF2196F3)
                          : Colors.grey.shade300,
                    ),
                  )),
                ),
                const SizedBox(height: 16),
                Text('$_waterGlasses of 8 glasses',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
                const SizedBox(height: 24),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          if (_waterGlasses > 0) {
                            setModalState(() {});
                            setState(() => _waterGlasses--);
                          }
                        },
                        icon: const Icon(Icons.remove, color: Color(0xFF2196F3)),
                        label: const Text('Remove', style: TextStyle(color: Color(0xFF2196F3))),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF2196F3)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_waterGlasses < 8) {
                            setModalState(() {});
                            setState(() => _waterGlasses++);
                          }
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text('Add Glass', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_waterGlasses >= 8)
                  const Text('🎉 Great job! You reached your daily water goal!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      );
    },
  );
}
void _showWeightDialog() {
  final TextEditingController weightController = TextEditingController();
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Log Weight ⚖️',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
            const SizedBox(height: 8),
            const Text('Track your weight over time',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 24),
            // Weight history
            if (_weightLog.isNotEmpty) ...[
              const Text('Recent entries', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._weightLog.reversed.take(3).map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry['date'], style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    Text('${entry['weight']}kg',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
                  ],
                ),
              )),
              const Divider(),
              const SizedBox(height: 8),
            ],
            // New entry
            const Text('New entry', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter your weight',
                suffixText: 'kg',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (weightController.text.isNotEmpty) {
                    final now = DateTime.now();
                    setState(() {
                      _weightLog.add({
                        'weight': double.tryParse(weightController.text) ?? 0,
                        'date': '${now.day}/${now.month}/${now.year}',
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Weight', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, ${widget.name}! 👋',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
            Text(
              widget.mode == 'pregnant' ? 'Trimester ${widget.stage}' : 'Breastfeeding',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [
  IconButton(
    icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FoodsToAvoidScreen(
            mode: widget.mode,
            stage: widget.stage,
          ),
        ),
      );
    },
  ),
  IconButton(
    icon: const Icon(Icons.person_outline, color: Color(0xFF2196F3)),
    onPressed: () {},
  ),
],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalorieCard(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
  child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 4))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('💧', style: TextStyle(fontSize: 28)),
        const SizedBox(height: 8),
        const Text('Water', style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 4),
        Text('$_waterGlasses / 8',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
        const Text('glasses', style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _showWaterDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('+ Add', style: TextStyle(fontSize: 12)),
          ),
        ),
      ],
    ),
  ),
),
                const SizedBox(width: 12),
                Expanded(
  child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 4))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('⚖️', style: TextStyle(fontSize: 28)),
        const SizedBox(height: 8),
        const Text('Weight', style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 4),
        Text('${_weightLog.isEmpty ? widget.weight : _weightLog.last['weight']}kg',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
        const Text('current', style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _showWeightDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('+ Log', style: TextStyle(fontSize: 12)),
          ),
        ),
      ],
    ),
  ),
),
              ],
            ),
            const SizedBox(height: 16),
            _buildNutritionCard(),
            const SizedBox(height: 16),
           _buildCalorieCard(),
const SizedBox(height: 16),
_buildNutritionCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final food = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FoodSearchScreen()),
          );
          if (food != null) {
  setState(() {
    _loggedFoods.add(food);
  });
  await _saveFood(food);
}
        },
        backgroundColor: const Color(0xFF2196F3),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Log Food', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildCalorieCard() {
    final progress = (_caloriesConsumed / _calorieGoal).clamp(0.0, 1.0);
    final remaining = _calorieGoal - _caloriesConsumed;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text('Daily Calories', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text('$_caloriesConsumed',
              style: const TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.bold)),
          Text('of $_calorieGoal kcal goal', style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white30,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$_caloriesConsumed kcal consumed',
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text('${remaining > 0 ? remaining : 0} kcal remaining',
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String emoji, String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildNutritionCard() {
    double totalProtein = _loggedFoods.fold(0, (sum, f) => sum + (f['protein'] as num).toDouble());
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nutrition Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildNutrientRow('Protein', totalProtein, 70, Colors.orange),
          const SizedBox(height: 10),
          _buildNutrientRow('Iron', 0, 27, Colors.red),
          const SizedBox(height: 10),
          _buildNutrientRow('Folate', 0, 600, Colors.green),
          const SizedBox(height: 10),
          _buildNutrientRow('Calcium', 0, 1000, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildNutrientRow(String name, double current, double goal, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontSize: 14)),
            Text('${current.toInt()} / ${goal.toInt()}${name == 'Protein' ? 'g' : 'mg'}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (current / goal).clamp(0.0, 1.0),
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildFoodsWarningBanner() {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FoodsToAvoidScreen(
            mode: widget.mode,
            stage: widget.stage,
          ),
        ),
      );
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Foods to Avoid ⚠️',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.orange)),
                SizedBox(height: 2),
                Text('Tap to see what foods to avoid during your journey',
                    style: TextStyle(color: Colors.orange, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.orange),
        ],
      ),
    ),
  );
}
}