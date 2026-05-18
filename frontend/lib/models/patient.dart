import 'package:hive/hive.dart';

part 'patient.g.dart';

@HiveType(typeId: 0)
class Patient {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int age;

  @HiveField(2)
  final int pregnancyWeek;

  @HiveField(3)
  final String preferredLanguage;

  @HiveField(4)
  final String village;

  @HiveField(5)
  final String? previousConditions;

  Patient({
    required this.name,
    required this.age,
    required this.pregnancyWeek,
    required this.preferredLanguage,
    required this.village,
    this.previousConditions,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'pregnancy_week': pregnancyWeek,
      'preferred_language': preferredLanguage,
      'village': village,
      'previous_conditions': previousConditions,
    };
  }
}
