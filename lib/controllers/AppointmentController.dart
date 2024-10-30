import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Appointment.dart';
import '../models/Doctor.dart';

class AppointmentControler
{
  final CollectionReference _appointmentsCollection =
  FirebaseFirestore.instance.collection('appointments');

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
}