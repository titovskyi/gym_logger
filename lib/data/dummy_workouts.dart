import 'dart:convert';

final String dummyWorkouts = json.encode([
  {
    'id': 'First',
    'title': 'First Workout',
    'date': DateTime.now().toIso8601String(),
  },
  {
    'id': 'Second',
    'title': 'Second Workout',
    'date': DateTime.now().toIso8601String(),
  }
]);
