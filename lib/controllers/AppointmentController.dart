import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Appointment.dart';
import '../models/Doctor.dart';

class AppointmentController {
  final CollectionReference _appointmentsCollection;

  AppointmentController({
    FirebaseFirestore? firestore,
  }) : _appointmentsCollection =
  (firestore ?? FirebaseFirestore.instance).collection('appointments');

  Future<String?> createAppointment(Appointment newAppointment) async {
    try {
      await _appointmentsCollection.add(newAppointment.toFirestore());
      print('Appointment added successfully');
    } on FirebaseException catch (e) {
      print('Failed to add appointment: $e');
      // Handle Firestore-specific errors here
      throw e; // Re-throw the error if needed
    } catch (e) {
      print('An unexpected error occurred: $e');
      // Handle general errors here
      throw e; // Re-throw the error if needed
    }
  }

  Future<List<Appointment>> getAppointments(String doctorId) async{
    try{
      QuerySnapshot querySnapshot = await _appointmentsCollection
          .where('doctorId', isEqualTo: doctorId)
          .get();

      //convert each document to an appointment model
      List<Appointment> appointments = querySnapshot.docs.map((doc){
        return Appointment.fromFirestore(doc);
      }).toList();
      return appointments;

    }
    catch(e){
      print("Error fetching patients: $e");
      return [];
    }
  }
}