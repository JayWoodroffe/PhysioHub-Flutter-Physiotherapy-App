import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Exercise.dart';

class ExerciseController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //adds the exercise for a specific patient to the patient collection
  Future<void> addExerciseToPatient(String patientId, Exercise exercise) async {
    print("Adding exercise for patient ID: $patientId");
    print("Exercise data: ${exercise.toFirestore()}");
    try {
      // Get reference to the patient's document
      final docRef = _firestore.collection('patients').doc(patientId);

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
    final docRef = _firestore.collection('patients').doc(patientId);
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

  //function to delete exercises based on a list of selected ids
  Future<void> deleteExercises(String patientId, List<String> selectedIds) async{
    try {
      //reference the patient's document in firestore
      DocumentReference patientDocRef = _firestore.collection('patients').doc(
          patientId);

      //start firestore transaction to safely update the document
      await _firestore.runTransaction((transaction) async {
        //get the patient's document snapshot
        DocumentSnapshot patientSnapshot = await transaction.get(patientDocRef);

        if (patientSnapshot.exists) {
          //retrieve the current exercise list
          List<dynamic> exercises = patientSnapshot.get('exercises') ?? [];
          exercises = exercises.where((exercise) => !selectedIds.contains(
              exercise['id'])).toList();

          //update the exercises field in firestore with the filtered list
          transaction.update(patientDocRef, {'exercises': exercises});
        }
      });
      print('selected exercises deleted succesfully');
    }catch(e){
      print('error deleting selected exerciss $e');
      throw e;
    }
  }
}