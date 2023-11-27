import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_logger/constants/translation.constants.dart';
import 'package:gym_logger/providers/calendar_provider.dart';
import 'package:gym_logger/providers/workouts_provider.dart';
import 'package:gym_logger/models/workout.dart';
import 'package:gym_logger/services/workout.service.dart';

class NewExercises extends ConsumerStatefulWidget {
  final DateTime choosenDate;

  const NewExercises({super.key, required this.choosenDate});

  @override
  ConsumerState<NewExercises> createState() {
    return NewExercisesState();
  }
}

class NewExercisesState extends ConsumerState<NewExercises> {
  late List<Workout> _allWorkouts = [];
  late List<Workout> _userWorkouts = [];

  int count = 0;
  List<Workout> trainingWorkouts = [];

  List<Workout> get _userWorkoutsByDate => _userWorkouts
      .where(
          (el) => el.date!.difference(ref.read(calendarProvider)).inDays == 0)
      .toList();

  @override
  void initState() {
    super.initState();

    _getAllWorkouts();
    _getUserWorkouts();
  }

  void _getAllWorkouts() async {
    _allWorkouts = await WorkoutService().getAllWorkouts();
  }

  void _getUserWorkouts() async {
    final workouts = await WorkoutService().getUserWorkouts();

    setState(() {
      _userWorkouts = workouts;
    });
  }

  void _addWorkoutToTraining(Workout item) async {
    final workoutExist = _userWorkoutsByDate.where((el) => item.id == el.id);

    if (workoutExist.isEmpty) {
      trainingWorkouts.add(Workout(
          id: item.id, title: item.title, date: ref.read(calendarProvider)));
    }
  }

  void _saveWorkouts() async {
    await WorkoutService()
        .postWorkouts(trainingWorkouts, ref.read(calendarProvider));
  }

  void _openAddWorkoutDialog() async {
    Widget content = const Text(NO_WORKOUTS);

    if (_allWorkouts.isNotEmpty) {
      content = Column(
        children: [
          for (final workout in _allWorkouts)
            GestureDetector(
              child: Text(workout.title),
              onTap: () {
                _addWorkoutToTraining(workout);
              },
            ),
          ElevatedButton(
            onPressed: () {
              _saveWorkouts();

              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      );
    }

    await showModalBottomSheet(
      context: context,
      builder: (ctx) => SizedBox(
        width: double.infinity,
        child: content,
      ),
      isScrollControlled: true,
      useSafeArea: true,
    );

    setState(() {
      _userWorkouts = [..._userWorkouts, ...trainingWorkouts];
      trainingWorkouts = [];

      print(trainingWorkouts);
    });
  }

  void _addNewTraining() async {
    // await WorkoutService().postWorkouts(trainingWorkouts);

    _popScreen();
  }

  void _popScreen() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add workouts'),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        onPressed: _addNewTraining,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Column(
          children: [
            OutlinedButton(
              onPressed: _openAddWorkoutDialog,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  Text('Add workout'),
                ],
              ),
            ),
            for (final workout in _userWorkoutsByDate) Text(workout.title),
          ],
        ),
      ),
    );
  }
}
