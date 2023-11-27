import 'dart:convert';

import 'package:gym_logger/data/dummy_workouts.dart';
import 'package:gym_logger/models/workout.dart';

String userWorkouts = json.encode([]);

class WorkoutService {
  Future<List<Workout>> getAllWorkouts() async {
    try {
      return await Future.delayed(
        const Duration(seconds: 0),
        () {
          return workoutFromJson(dummyWorkouts);
        },
      );
    } catch (e) {
      print(e.toString());

      return [];
    }
  }

  Future<List<Workout>> getUserWorkouts() async {
    try {
      return await Future.delayed(
        const Duration(seconds: 0),
        () {
          return workoutFromJson(userWorkouts);
        },
      );
    } catch (e) {
      print(e);

      return [];
    }
  }

  Future<void> postWorkouts(List<Workout> training, DateTime date) async {
    try {
      final List<Workout> alreadyExistUserWorkouts =
          workoutFromJson(userWorkouts);

      userWorkouts = workoutToJson(
        List.from(alreadyExistUserWorkouts)..addAll(training),
      );
    } catch (e) {
      print(e);
    }
  }
}
