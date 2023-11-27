import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_logger/providers/calendar_provider.dart';
import 'package:gym_logger/screens/new_exercises.dart';
import 'package:gym_logger/models/workout.dart';
import 'package:gym_logger/services/workout.service.dart';

import 'package:gym_logger/widgets/calendar.dart';

class Calendar extends ConsumerStatefulWidget {
  const Calendar({super.key});

  @override
  ConsumerState<Calendar> createState() => _CalendarState();
}

class _CalendarState extends ConsumerState<Calendar> {
  late List<Workout> workouts = [];

  @override
  void initState() {
    super.initState();

    _getUserWorkouts();
  }

  void _getUserWorkouts() async {
    final userWorkouts = await WorkoutService().getUserWorkouts();

    setState(() {
      workouts = userWorkouts;
    });
  }

  void _openNewExercise() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final choosenDate = ref.watch(calendarProvider);

          return NewExercises(choosenDate: choosenDate);
        },
      ),
    );

    _getUserWorkouts();
  }

  List<Widget> _contentWithEvents() {
    final currentDate = ref.watch(calendarProvider);
    final currentDateEvents = workouts.isNotEmpty
        ? workouts
            .where((el) => el.date!.difference(currentDate).inDays == 0)
            .toList()
        : [];

    return [
      const CalendarWidget(),
      for (final workout in currentDateEvents) Text(workout.title),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Column(
      children: [
        CalendarWidget(),
      ],
    );

    if (workouts != null && workouts!.isNotEmpty) {
      content = Column(
        children: _contentWithEvents(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: content,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        onPressed: _openNewExercise,
        child: const Icon(Icons.add),
      ),
    );
  }
}
