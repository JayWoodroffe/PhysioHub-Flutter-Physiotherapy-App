import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Exercise.dart';

class ExerciseController{
  //adds the exercise for a specific patient to the patient collection
  Future<void> addExerciseToPatient(String patientId, Exercise exercise) async {
    print("Adding exercise for patient ID: $patientId");
    print("Exercise data: ${exercise.toFirestore()}");
    try {
      // Get reference to the patient's document
      final docRef = FirebaseFirestore.instance.collection('patients').doc(patientId);

      // Log the document reference to verify it
      print("Document reference: ${docRef.path}");

      // Attempt to update the patient's document with the new exercise
      await docRef.update({
        'exercises': FieldValue.arrayUnion([exercise.toFirestore()])
      });

      // Log a success message after the update is successful
      print("Exercise successfully added to patient: $patientId");
    } catch (e) {
      // Log any errors that occur during the process
      print("Error adding exercise to patient: $e");
    }
  }

  Future<List<Exercise>> getExercisesForPatient(String patientId) async {
    final docRef = FirebaseFirestore.instance.collection('patients').doc(patientId);
    final docSnapshot = await docRef.get();
    final data = docSnapshot.data();

    if (data != null && data['exercises'] != null) {
      return (data['exercises'] as List<dynamic>).map((exerciseData) {
        return Exercise.fromFirestore(exerciseData as Map<String, dynamic>);
      }).toList();
    } else {
      return [];
    }
  }
}