import 'package:hive_flutter/hive_flutter.dart';
import 'package:frontend/models/patient.dart';
import 'package:frontend/models/assessment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageServiceProvider = Provider((ref) => StorageService());

class StorageService {
  static const String _patientBox = 'patientBox';
  static const String _assessmentBox = 'assessmentBox';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PatientAdapter());
    Hive.registerAdapter(AssessmentAdapter());
    await Hive.openBox<Patient>(_patientBox);
    await Hive.openBox<Assessment>(_assessmentBox);
  }

  Future<void> savePatient(Patient patient) async {
    final box = Hive.box<Patient>(_patientBox);
    await box.put('current_patient', patient);
  }

  Patient? getPatient() {
    final box = Hive.box<Patient>(_patientBox);
    return box.get('current_patient');
  }

  Future<void> saveAssessment(Assessment assessment) async {
    final box = Hive.box<Assessment>(_assessmentBox);
    await box.add(assessment);
  }

  List<Assessment> getAssessments() {
    final box = Hive.box<Assessment>(_assessmentBox);
    return box.values.toList().reversed.toList();
  }

  Assessment? getLastAssessment() {
    final assessments = getAssessments();
    return assessments.isNotEmpty ? assessments.first : null;
  }
}
