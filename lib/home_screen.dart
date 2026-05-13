import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
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

  int get _calorieGoal {
    if (mode == 'breastfeeding') return 2500;
    if (stage == '1') return 1800;
    if (stage == '2') return 2100;
    return 2400;
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
            Text('Hi, $name! 👋',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2196F3))),
            Text(
              mode == 'pregnant'
                  ? 'Trimester $stage'
                  : 'Breastfeeding',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Color(0xFF2196F3)),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calorie Card
            _buildCalorieCard(),
            const SizedBox(height: 16),
            // Stats Row
            Row(
              children: [
                Expanded(child: _buildStatCard('💧', 'Water', '0 / 8', 'glasses')),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('⚖️', 'Weight', '${weight}kg', 'current')),
              ],
            ),
            const SizedBox(height: 16),
            // Nutrition Summary
            _buildNutritionCard(),
            const SizedBox(height: 16),
            // Today's Meals
            _buildMealsCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF2196F3),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Log Food', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildCalorieCard() {
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
          const Text('Daily Calories',
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text('$_calorieGoal',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  fontWeight: FontWeight.bold)),
          const Text('kcal goal',
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.0,
              backgroundColor: Colors.white30,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0 kcal consumed',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text('0 kcal remaining',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
          Text(subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildNutritionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nutrition Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildNutrientRow('Protein', 0, 70, Colors.orange),
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
            value: current / goal,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildMealsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Today's Meals",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Icon(Icons.restaurant_outlined,
                    size: 48, color: Colors.grey.shade300),
                const SizedBox(height: 8),
                const Text('No meals logged yet',
                    style: TextStyle(color: Colors.grey)),
                const Text('Tap + Log Food to get started',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}