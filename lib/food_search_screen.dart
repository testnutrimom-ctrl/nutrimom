import 'package:flutter/material.dart';
import 'foods_to_avoid_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;

Future<void> _searchFood(String query) async {
  if (query.isEmpty) {
    setState(() {
      _results = [];
      _hasSearched = false;
    });
    return;
  }
  setState(() {
    _isLoading = true;
    _hasSearched = true;
  });
  try {
    final response = await http.get(Uri.parse(
      'https://api.nal.usda.gov/fdc/v1/foods/search?query=$query&api_key=o22hd3kIVgH9N5ioLMc3djREpsEujeQSNHRIMUMd&pageSize=10',
    ));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final foods = data['foods'] as List;
setState(() {
  final seen = <String>{};
  _results = foods.map((food) {
    final nutrients = food['foodNutrients'] as List;
    double getnutrient(int id) {
      final n = nutrients.firstWhere(
        (n) => n['nutrientId'] == id,
        orElse: () => {'value': 0},
      );
      return (n['value'] as num?)?.toDouble() ?? 0;
    }
    // Get a clean name
    String name = food['description'] ?? 'Unknown';
    name = name.split(',').first.trim();
    name = name.toLowerCase().split(' ').map((word) =>
        word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : word
    ).join(' ');
    return {
      'name': name,
      'calories': getnutrient(1008).round(),
      'protein': getnutrient(1003),
      'carbs': getnutrient(1005),
      'fat': getnutrient(1004),
      'serving': '100g',
    };
  }).where((food) {
    // Remove duplicates by name
    final name = food['name'] as String;
    if (seen.contains(name)) return false;
    seen.add(name);
    return (food['calories'] as int) > 0;
  }).toList();
  _isLoading = false;
});
    }
  } catch (e) {
    setState(() => _isLoading = false);
  }
}
  void _showQuantityDialog(Map<String, dynamic> food) {
    int quantity = 1;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final totalCalories = (food['calories'] as int) * quantity;
            final totalProtein = (food['protein'] as double) * quantity;
            final totalCarbs = (food['carbs'] as double) * quantity;
            final totalFat = (food['fat'] as double) * quantity;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(food['name'],
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Text(food['serving'], style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 24),
                  // Quantity selector
                  const Text('Quantity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) setModalState(() => quantity--);
                        },
                        icon: const Icon(Icons.remove_circle_outline, size: 36, color: Color(0xFF2196F3)),
                      ),
                      const SizedBox(width: 24),
                      Text('$quantity',
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
                      const SizedBox(width: 24),
                      IconButton(
                        onPressed: () => setModalState(() => quantity++),
                        icon: const Icon(Icons.add_circle_outline, size: 36, color: Color(0xFF2196F3)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Nutrition summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F9FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNutrientInfo('Calories', '$totalCalories', 'kcal', Colors.blue),
                        _buildNutrientInfo('Protein', totalProtein.toStringAsFixed(1), 'g', Colors.orange),
                        _buildNutrientInfo('Carbs', totalCarbs.toStringAsFixed(1), 'g', Colors.green),
                        _buildNutrientInfo('Fat', totalFat.toStringAsFixed(1), 'g', Colors.red),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Add button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context, {
                          'name': food['name'],
                          'calories': totalCalories,
                          'protein': totalProtein,
                          'carbs': totalCarbs,
                          'fat': totalFat,
                          'serving': '${quantity}x ${food['serving']}',
                          'quantity': quantity,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Add $quantity serving${quantity > 1 ? 's' : ''} — $totalCalories kcal',
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNutrientInfo(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(unit, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Search Food',
            style: TextStyle(color: Color(0xFF2196F3), fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Color(0xFF2196F3)),
      ),
      body: Column(
        children: [
          // Foods to avoid warning banner
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FoodsToAvoidScreen(mode: 'pregnant', stage: '1'),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: const Color(0xFFFFF3E0),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('Check foods to avoid during pregnancy & breastfeeding',
                        style: TextStyle(color: Colors.orange, fontSize: 12)),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.orange, size: 20),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: (value) => _searchFood(value),
              decoration: InputDecoration(
                hintText: 'Search for a food...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF2196F3)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _searchFood('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF5F9FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2196F3)))
                : !_hasSearched
                    ? _buildSuggestions()
                    : _results.isEmpty
                        ? _buildNoResults()
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _results.length,
                            itemBuilder: (context, index) =>
                                _buildFoodCard(_results[index]),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Common Foods', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Banana', 'Egg', 'Chicken', 'Milk', 'Yogurt', 'Oatmeal', 'Salmon']
                .map((food) => GestureDetector(
                      onTap: () {
                        _searchController.text = food;
                        _searchFood(food);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(food, style: const TextStyle(color: Color(0xFF2196F3))),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No foods found', style: TextStyle(color: Colors.grey, fontSize: 16)),
          const Text('Try a different search term', style: TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildFoodCard(Map<String, dynamic> food) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(food['name'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(food['serving'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildNutrientChip('${food['calories']} kcal', Colors.blue),
                const SizedBox(width: 6),
                _buildNutrientChip('P: ${food['protein']}g', Colors.orange),
                const SizedBox(width: 6),
                _buildNutrientChip('C: ${food['carbs']}g', Colors.green),
                const SizedBox(width: 6),
                _buildNutrientChip('F: ${food['fat']}g', Colors.red),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _showQuantityDialog(food),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: const Text('Add'),
        ),
      ),
    );
  }

  Widget _buildNutrientChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}