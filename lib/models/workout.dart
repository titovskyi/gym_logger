import 'dart:convert';

List<Workout> workoutFromJson(String data) => List<Workout>.from(
      json.decode(data).map(
            (w) => Workout.fromJson(w),
          ),
    );

String workoutToJson(List<Workout> data) => json.encode(
      List<dynamic>.from(
        data.map((w) => w.toJson()),
      ),
    );

class Workout {
  final String id;
  final String title;
  final DateTime? date;

  Workout({
    required this.id,
    required this.title,
    required this.date,
  });

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
        id: json['id'],
        title: json['title'],
        date: DateTime.parse(json['date']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date!.toIso8601String(),
      };
}
