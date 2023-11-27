import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_logger/models/workout.dart';

class WorkoutsNotifier extends StateNotifier<List<Workout>> {
  WorkoutsNotifier() : super([]);

  final List<Workout> newTraining = [];

  void addWorkouts() {
    state = [...state, ...newTraining];
  }

  void addWorkoutToTraining(
    Workout workout,
    DateTime date,
  ) {
    if (newTraining.contains(workout)) return;

    newTraining.add(Workout(
      id: workout.id,
      title: workout.title,
      date: date,
    ));
  }
}

final workoutsProvider = StateNotifierProvider<WorkoutsNotifier, List<Workout>>(
    (ref) => WorkoutsNotifier());
