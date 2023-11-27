import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarNotifier extends StateNotifier<DateTime> {
  CalendarNotifier() : super(DateTime.now());

  void updateChoosenDate(DateTime choosenDate) {
    state = choosenDate;
  }
}

final calendarProvider = StateNotifierProvider<CalendarNotifier, DateTime>(
    (ref) => CalendarNotifier());
