import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NumiService {
  static Future<int> getPoints() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return (doc.data()?['numiPoints'] as int?) ?? 0;
  }

  static Future<void> checkAndAwardPoints({
    required bool caloriesOnTrack,
    required bool waterGoalMet,
    required bool nutrientsTracked,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final today = DateTime.now();
    final dateStr = '${today.year}-${today.month}-${today.day}';

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = doc.data() ?? {};
    final lastChecked = data['numiLastChecked'] as String? ?? '';
    final currentPoints = (data['numiPoints'] as int?) ?? 0;
    final missedDays = (data['numiMissedDays'] as int?) ?? 0;

    if (lastChecked == dateStr) return;

    int pointsToAdd = 0;
    if (caloriesOnTrack) pointsToAdd++;
    if (waterGoalMet) pointsToAdd++;
    if (nutrientsTracked) pointsToAdd++;

    int newMissedDays = missedDays;
    int penalty = 0;

    if (pointsToAdd == 0) {
      newMissedDays++;
      if (newMissedDays >= 3) {
        penalty = 2;
        newMissedDays = 0;
      }
    } else {
      newMissedDays = 0;
    }

    final newPoints = (currentPoints + pointsToAdd - penalty).clamp(0, 9999);

    await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .set({
  'numiPoints': newPoints,
  'numiLastChecked': dateStr,
  'numiMissedDays': newMissedDays,
}, SetOptions(merge: true));
  }
}