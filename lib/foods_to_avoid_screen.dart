import 'package:flutter/material.dart';

class FoodsToAvoidScreen extends StatelessWidget {
  final String mode;
  final String stage;

  const FoodsToAvoidScreen({
    super.key,
    required this.mode,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Foods to Avoid ⚠️',
            style: TextStyle(color: Color(0xFF2196F3), fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Color(0xFF2196F3)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      mode == 'pregnant'
                          ? 'These foods may pose risks during pregnancy. Always consult your doctor.'
                          : 'These foods may affect your breast milk or baby. Always consult your doctor.',
                      style: const TextStyle(color: Colors.orange, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Food categories
            ..._getFoodCategories().map((category) => _buildCategoryCard(category)),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFoodCategories() {
    if (mode == 'pregnant') {
      return [
        {
          'title': '🐟 High Mercury Fish',
          'color': Colors.red,
          'items': [
            {'name': 'Shark', 'reason': 'Very high mercury levels harmful to baby\'s nervous system'},
            {'name': 'Swordfish', 'reason': 'High mercury content, avoid completely'},
            {'name': 'King Mackerel', 'reason': 'High mercury, choose safer fish like salmon instead'},
            {'name': 'Tilefish', 'reason': 'One of the highest mercury fish'},
            {'name': 'Bigeye Tuna', 'reason': 'High mercury, limit canned tuna to 2 servings/week'},
          ],
        },
        {
          'title': '🧀 Unpasteurized Foods',
          'color': Colors.orange,
          'items': [
            {'name': 'Soft cheeses (Brie, Camembert)', 'reason': 'Risk of Listeria bacteria'},
            {'name': 'Raw milk', 'reason': 'May contain harmful bacteria'},
            {'name': 'Unpasteurized juice', 'reason': 'Risk of E. coli and Salmonella'},
          ],
        },
        {
          'title': '🥩 Undercooked Foods',
          'color': Colors.deepOrange,
          'items': [
            {'name': 'Raw or undercooked meat', 'reason': 'Risk of Toxoplasma and Salmonella'},
            {'name': 'Raw sushi/sashimi', 'reason': 'Risk of parasites and bacteria'},
            {'name': 'Raw or undercooked eggs', 'reason': 'Risk of Salmonella'},
            {'name': 'Raw sprouts', 'reason': 'Risk of E. coli and Salmonella'},
          ],
        },
        {
          'title': '☕ High Caffeine',
          'color': Colors.brown,
          'items': [
            {'name': 'More than 200mg caffeine/day', 'reason': 'Linked to low birth weight'},
            {'name': 'Energy drinks', 'reason': 'High caffeine and other stimulants'},
            {'name': 'Herbal teas (some)', 'reason': 'Some herbs not safe in pregnancy'},
          ],
        },
        {
          'title': '🍷 Alcohol',
          'color': Colors.purple,
          'items': [
            {'name': 'All alcoholic beverages', 'reason': 'No safe amount during pregnancy — causes fetal alcohol syndrome'},
          ],
        },
        {
          'title': '🥫 Other Foods to Limit',
          'color': Colors.teal,
          'items': [
            {'name': 'Processed meats (hot dogs, deli meat)', 'reason': 'Risk of Listeria unless heated until steaming'},
            {'name': 'Liver and liver products', 'reason': 'Very high vitamin A can harm baby'},
            {'name': 'Unwashed fruits and vegetables', 'reason': 'Risk of Toxoplasma and pesticides'},
          ],
        },
      ];
    } else {
      return [
        {
          'title': '☕ Caffeine',
          'color': Colors.brown,
          'items': [
            {'name': 'Excessive coffee', 'reason': 'Caffeine passes into breast milk, can make baby irritable'},
            {'name': 'Energy drinks', 'reason': 'High caffeine affects baby\'s sleep'},
            {'name': 'Limit to 200-300mg caffeine/day', 'reason': 'Safe upper limit while breastfeeding'},
          ],
        },
        {
          'title': '🍷 Alcohol',
          'color': Colors.purple,
          'items': [
            {'name': 'Alcoholic beverages', 'reason': 'Alcohol passes into breast milk'},
            {'name': 'If consumed, wait 2-3 hours', 'reason': 'Before breastfeeding after one drink'},
          ],
        },
        {
          'title': '🐟 High Mercury Fish',
          'color': Colors.red,
          'items': [
            {'name': 'Shark, Swordfish, King Mackerel', 'reason': 'Mercury passes into breast milk'},
            {'name': 'Limit fish to 2-3 servings/week', 'reason': 'Choose low-mercury options like salmon'},
          ],
        },
        {
          'title': '🌿 Herbs & Supplements',
          'color': Colors.green,
          'items': [
            {'name': 'Sage', 'reason': 'Can reduce milk supply'},
            {'name': 'Peppermint in large amounts', 'reason': 'May reduce milk supply'},
            {'name': 'Parsley in large amounts', 'reason': 'May reduce milk supply'},
          ],
        },
        {
          'title': '⚠️ Possible Baby Sensitivities',
          'color': Colors.orange,
          'items': [
            {'name': 'Dairy products', 'reason': 'Some babies react to cow\'s milk proteins'},
            {'name': 'Spicy foods', 'reason': 'May cause gas or fussiness in some babies'},
            {'name': 'Gassy vegetables (broccoli, cabbage)', 'reason': 'May cause gas in some babies'},
          ],
        },
      ];
    }
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    final color = category['color'] as Color;
    final items = category['items'] as List<Map<String, dynamic>>;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Text(category['title'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ),
          // Items
          ...items.map((item) => Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.cancel, color: color, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 2),
                      Text(item['reason'],
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}