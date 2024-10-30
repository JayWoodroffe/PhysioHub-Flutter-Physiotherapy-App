import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment{
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime dateTime;
  const Appointment(this.id, this.patientId, this.doctorId, this.dateTime);

  // Factory method to create an Appointment from Firestore data
  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Appointment(
      doc.id, // Use Firestore document ID as the Appointment ID
      data['patientId'] ?? '', // Use null-aware operator to handle missing data
      data['doctorId'] ?? '',
      (data['dateTime'] as Timestamp).toDate(), // Convert Firestore Timestamp to DateTime
    );
  }

  // Method to convert an Appointment to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'dateTime': Timestamp.fromDate(dateTime), // Convert DateTime to Firestore Timestamp
    };
  }
}